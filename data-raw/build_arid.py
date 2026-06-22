"""
build_arid.py
Construye las tablas limpias de ARID a partir del SAAID original.

Uso:
    python3 build_arid.py --input saaid_v.2.0_2023_filtrado.xlsx --outdir .
    python3 build_arid.py --input saaid.xlsx --outdir . --c14 mendez-quiros.xlsx

Outputs (.xlsx):
    arid_humans.xlsx    — una fila por tejido analizado (formato largo)
    arid_animals.xlsx   — una fila por tejido analizado (formato largo)
    arid_plants.xlsx
    arid_sites.xlsx
    arid_c14.xlsx       — todos los fechados radiocarbónicos
"""

import argparse
import re
import unicodedata
import pandas as pd
from pathlib import Path

# ── Filtro geográfico ─────────────────────────────────────────────────────────
TARGET_REGIONS = ["North Coast of Chile", "Northern Chile"]

# ── Ecozona desde altitud ─────────────────────────────────────────────────────
def assign_ecozone(alt):
    if pd.isna(alt):
        return None
    alt = float(alt)
    if alt < 130:
        return "Coast"
    elif alt < 1700:
        return "Lowlands"
    elif alt < 3700:
        return "Precordillera"
    else:
        return "Altiplano"

# ── Eliminar tildes (ASCII-safe) ──────────────────────────────────────────────
def remove_accents(s):
    if not isinstance(s, str):
        return s
    return "".join(
        c for c in unicodedata.normalize("NFD", s)
        if unicodedata.category(c) != "Mn"
    )

def strip_accents_df(df):
    """Aplica remove_accents a todas las columnas de tipo object."""
    for col in df.select_dtypes(include="object").columns:
        df[col] = df[col].map(lambda x: remove_accents(x) if isinstance(x, str) else x)
    return df

# ── Normalización de período ──────────────────────────────────────────────────
def normalize_period(s):
    if pd.isna(s):
        return s
    s = str(s)
    s = re.sub(r"\s*\(Northern Chile\)", "", s)
    s = re.sub(r"\s*\bPeriod\b", "", s)
    s = re.sub(r"\s*\bHorizon\b", "", s)
    return s.strip()

PERIOD_BROAD_MAP = {
    # Archaic
    "Archaic":              "Archaic",
    "Early Archaic":        "Archaic",
    "Middle Archaic":       "Archaic",
    "Late Archaic":         "Archaic",
    "Middle/Late Archaic":  "Archaic",
    # Formative
    "Formative":                     "Formative",
    "Early Formative":               "Formative",
    "Middle Formative":              "Formative",
    "Late Formative":                "Formative",
    "Formative/Middle":              "Formative",
    "Tarajne phase - Early Formative": "Formative",
    # Middle
    "Middle": "Middle",
    # Late Intermediate
    "Late Intermediate":             "Late Intermediate",
    "Late Intermediate/Late":        "Late Intermediate",
    "Late Intermediate-Late":        "Late Intermediate",
    "Late Intermediate/Pica phase":  "Late Intermediate",
    "Middle/Late Intermediate":      "Late Intermediate",
    "Middle/Late Intermediate/Late": "Late Intermediate",
    # Late
    "Late":        "Late",
    "Late Period":  "Late",
    # Others
    "Hispanic":               "Hispanic",
    "Colonial":               "Colonial",
    "Modern":                 "Modern",
    "Archaeological (no date)": "Archaeological",
}

def infer_period_broad(period_normalized):
    if pd.isna(period_normalized):
        return None
    return PERIOD_BROAD_MAP.get(str(period_normalized).strip(), None)

# ── Normalización de región administrativa ────────────────────────────────────
ADMIN_MAP = {
    "Arica and Parinacota Region": "Arica y Parinacota",
    "Parinacota and Arica Region": "Arica y Parinacota",
    "Arica and Parincota Region":  "Arica y Parinacota",
    "Parincota and Arica Region":  "Arica y Parinacota",
    "Tarapacá Region":             "Tarapaca",
    "Tarpacá Region":              "Tarapaca",
    "Antofagasta Region":          "Antofagasta",
    "Atacama Region":              "Atacama",
}

SPECIAL_LOCALITY = {
    "From Laguna Lejía (~4500 masl) to the eastern margin of the Salar de Atacama, near Talabre (2700 masl)":
        ("Laguna Lejia to Salar de Atacama", "Antofagasta"),
}

GEO_COL = "Valley, locality, closest town, political jurisdiction"

# ── Columnas a eliminar siempre ───────────────────────────────────────────────
DROP_ALWAYS = [
    "Country",
    "Age_System_Relative", "Age_System_Absolute",
    "δ18O standard", "δ18Ophosphate",
    "206Pb/204Pb", "207Pb/204Pb", "208Pb/204Pb",
    "Compilation_Reference", "Compilation_Full_Reference",
    "Biome_1", "Biome 1",
    "Biome_2", "Biome 2",
    "Region",
    "Exact_coordinates?",
    "Site_location_radius (km)", "Site location_radius (km)",
    "Ref_coordinates",
    "Archaeological_site_type", "Archaeological_site_function", "Archaeological_site_description",
    "Archaeological_Culture", "Archeological_Culture",
    "Other_isotope_or_analytical_value", "Other_isotope_or_analytical_value.1",
    "Other_isotope_or analytical value",
    "Description_ of_other_isotope_or analytical_value",
    "Description_ of_ other_isotope_or_analytical_value",
    "Extra_information", "Description_of_extra_information",
    "Additional_info_source",
    "Preservation_criteria",
    "Comments",
    "Original_Full_Reference",
    "Link_to_source_2", "Link_ to_source_2",
    "Entry",
]

# ── Renombrado de columnas → snake_case limpio ────────────────────────────────
RENAME = {
    "Site_Name": "site_name",
    "Sample_Id": "sample_id",
    "Lab_Id": "lab_id",
    "Latitude (WGS 84)": "lat",
    "Longitude (WGS 84)": "lon",
    "Altitude (masl)": "altitude_masl",
    "Relative_chronology (Period/phase)": "period",
    "Relative_date_from": "period_from",
    "Relative_date_to": "period_to",
    "Absolute_chronology_method": "c14_method",
    "Radiocarbon_Lab_Code": "c14_lab_code",
    "Conventional_14C_date": "c14_bp",
    "Conventional_14C_date (BP)": "c14_bp",
    "Conventional 14C_date (BP)": "c14_bp",
    "Error (±1σ)": "c14_error",
    "Calibrated/modelled 14C (95%)_from": "c14_cal_from",
    "Calibrated/modelled 14C (95%)_to": "c14_cal_to",
    "Material_dated": "material_dated",
    "Sample_type": "sample_type",
    "Tissue": "tissue",
    "Element": "element",
    "Tissue_age": "tissue_age",
    "Tissue.1": "tissue_carbonate",
    "Element.1": "element_carbonate",
    "Tissue_age.1": "tissue_age_carbonate",
    "Sex_indiv": "sex",
    "Age_category": "age_category",
    "Min_age": "age_min",
    "Max_age": "age_max",
    "Min_age.1": "tissue_age_min",
    "Max_age.1": "tissue_age_max",
    "Min_age.2": "tissue_age_carbonate_min",
    "Max_age.2": "tissue_age_carbonate_max",
    "%Yield": "yield_pct",
    "wt%C": "wt_C",
    "wt%N": "wt_N",
    "C:N": "CN_ratio",
    "δ13C": "d13C",
    "δ15N": "d15N",
    "wt%S": "wt_S",
    "δ34S": "d34S",
    "δ13Ccarbonate": "d13C_carbonate",
    "δ18Ocarbonate": "d18O_carbonate",
    "δ18O": "d18O",
    "87Sr/86Sr": "Sr87_Sr86",
    "Original_Reference": "reference_short",
    "Link_ to_source": "doi",
    "Link_to_source": "doi",
    "Link_to_source_1": "doi",
    "Type_source": "type_source",
    "Taxon/local name": "taxon_local",
    "Genus/Species": "genus_species",
    "Phostosynthetic_Pathway": "photosynthetic_pathway",
    "Plant_domesticate": "plant_domesticate",
    "Periodo": "period_broad",
}

DOMESTICATE_MAP = {"Yes": "Crop", "No": "Wild", "Managed": "Managed"}

# Columnas C14 que migran a arid_c14
C14_COLS = ["c14_method", "c14_lab_code", "c14_bp", "c14_error",
            "c14_cal_from", "c14_cal_to", "material_dated"]

# ── Columnas que van a arid_sites ─────────────────────────────────────────────
SITE_COLS = [
    "site_name", "lat", "lon", "altitude_masl",
    "locality", "admin_region", "ecozone",
    "period", "period_broad", "period_from", "period_to",
]

# ── Columnas que se conservan en arid_c14 ─────────────────────────────────────
C14_KEEP = [
    "lab_id", "sample_id", "site_name", "locality", "admin_region",
    "ecozone", "altitude_masl", "reference_short", "c14_method",
    "c14_lab_code", "c14_bp", "c14_error", "c14_cal_from", "c14_cal_to",
    "material", "source_table", "d13C_ams",
]

# Mapeo renombre para reshaping a largo (carbonate src → dst)
CARB_RENAME = {
    "tissue_carbonate":         "tissue",
    "element_carbonate":        "element",
    "tissue_age_carbonate":     "tissue_age",
    "tissue_age_carbonate_min": "tissue_age_min",
    "tissue_age_carbonate_max": "tissue_age_max",
    "d13C_carbonate":           "d13C",
    "d18O_carbonate":           "d18O",
}
CARB_DETECT = ["d13C_carbonate", "d18O_carbonate"]


# ── Funciones ─────────────────────────────────────────────────────────────────

def parse_geo(val):
    if pd.isna(val):
        return pd.Series({"locality": None, "admin_region": None})
    val = str(val).strip()
    if val in SPECIAL_LOCALITY:
        loc, adm = SPECIAL_LOCALITY[val]
        return pd.Series({"locality": loc, "admin_region": adm})
    for pattern, normalized in ADMIN_MAP.items():
        if val.endswith(pattern):
            loc = val[: -len(pattern)].rstrip(", ").strip()
            return pd.Series({"locality": loc, "admin_region": normalized})
    return pd.Series({"locality": val, "admin_region": None})


def load_and_filter(path, sheet):
    df = pd.read_excel(path, sheet_name=sheet)
    return df[(df["Country"] == "Chile") & (df["Region"].isin(TARGET_REGIONS))].copy()


def clean_table(df):
    # Parseo geográfico
    parsed = df[GEO_COL].apply(parse_geo)
    df["locality"] = parsed["locality"]
    df["admin_region"] = parsed["admin_region"]

    # Eliminar columnas vacías, sin nombre (notas editoriales) + las siempre eliminadas
    empty_cols   = [c for c in df.columns if df[c].isna().all()]
    unnamed_cols = [c for c in df.columns if str(c).startswith("Unnamed:")]
    to_drop = set(DROP_ALWAYS + empty_cols + unnamed_cols + [GEO_COL])
    df = df.drop(columns=[c for c in to_drop if c in df.columns])

    # Renombrar
    df = df.rename(columns={k: v for k, v in RENAME.items() if k in df.columns})

    # Ecozona desde altitud
    if "altitude_masl" in df.columns:
        df["ecozone"] = df["altitude_masl"].apply(assign_ecozone)

    # Normalizar período y derivar period_broad si no viene de la fuente
    if "period" in df.columns:
        df["period"] = df["period"].map(normalize_period)
    if "period_broad" not in df.columns and "period" in df.columns:
        df["period_broad"] = df["period"].map(infer_period_broad)

    # Mapeo plant_domesticate
    if "plant_domesticate" in df.columns:
        df["plant_domesticate"] = df["plant_domesticate"].map(DOMESTICATE_MAP)

    return df


def extract_c14(df, source_table):
    """Extrae filas con fechados C14 de una tabla de muestras."""
    c14_present = [c for c in C14_COLS if c in df.columns]
    detect_cols = [c for c in ["c14_bp", "c14_lab_code"] if c in df.columns]
    if not detect_cols:
        return pd.DataFrame()

    has_c14 = df[detect_cols].notna().any(axis=1)
    subset = df.loc[has_c14].copy()

    context_cols = [c for c in ["lab_id", "sample_id", "site_name", "locality",
                                 "admin_region", "ecozone", "altitude_masl",
                                 "reference_short"] if c in subset.columns]
    out = subset[context_cols + c14_present].copy()
    out = out.rename(columns={"material_dated": "material"})
    out["source_table"] = source_table
    out["lab_id"]       = subset.get("lab_id", pd.Series(dtype=str))
    return out


def to_long(df):
    """Reshapea tabla a formato largo: una fila por tejido analizado."""
    organic_cols  = [c for c in ["tissue", "element", "tissue_age",
                                  "tissue_age_min", "tissue_age_max",
                                  "yield_pct", "wt_C", "wt_N", "CN_ratio",
                                  "d13C", "d15N", "wt_S", "d34S"] if c in df.columns]
    carbonate_src = [c for c in CARB_RENAME.keys() if c in df.columns]
    detect_carb   = [c for c in CARB_DETECT if c in df.columns]

    sr_col    = ["Sr87_Sr86"] if "Sr87_Sr86" in df.columns else []
    base_cols = [c for c in df.columns
                 if c not in organic_cols + carbonate_src + sr_col]

    # Filas orgánicas
    org = df[base_cols + organic_cols + sr_col].copy()
    org["tissue_type"] = "organic"

    if not carbonate_src or not detect_carb:
        return org

    # Filas carbonato (solo donde hay datos de carbonato)
    has_carb = df[detect_carb].notna().any(axis=1)
    carb = df.loc[has_carb, base_cols + carbonate_src].copy()
    carb = carb.rename(columns={k: v for k, v in CARB_RENAME.items() if k in carb.columns})
    carb["tissue_type"] = "carbonate"

    return pd.concat([org, carb], ignore_index=True)


def build_sites(tables, c14_df=None):
    def first_notnull(s):
        vals = s.dropna()
        return vals.iloc[0] if len(vals) else None

    frames = [
        tbl[[c for c in SITE_COLS if c in tbl.columns]].drop_duplicates()
        for tbl in tables.values()
    ]
    if c14_df is not None:
        c14_site_cols = [c for c in ["site_name", "altitude_masl", "locality",
                                      "admin_region", "ecozone"] if c in c14_df.columns]
        frames.append(c14_df[c14_site_cols].drop_duplicates())

    sites_raw = pd.concat(frames, ignore_index=True)
    sites = sites_raw.groupby("site_name").agg(first_notnull).reset_index()
    return sites


C14_ADMIN_MAP = {
    "Tarapaca": "Tarapaca",
    "Arica":    "Arica y Parinacota",
}


def build_c14_mendez(path):
    df = pd.read_excel(path, sheet_name="Supl. 1", header=1)
    df.columns = df.columns.str.strip()

    df = df.rename(columns={
        "ID":               "record_id",
        "Region":           "admin_region",
        "Basin":            "locality",
        "Z":                "altitude_masl",
        "Altitudinal Belt": "altitudinal_belt",
        "Site":             "site_name",
        "Unit":             "unit",
        "Sub unit":         "sub_unit",
        "Lab id.":          "c14_lab_code",
        "Material":         "material",
        "Material detail":  "material_detail",
        "14C Age":          "c14_bp",
        "±σ":               "c14_error",
        "δ13C (‰)":         "d13C_ams",
        "Reference":        "reference_short",
        "Domestic":         "context_domestic",
        "Funerary":         "context_funerary",
        "Agriculture":      "context_agriculture",
        "Other":            "context_other",
        "from":             "c14_cal_from",
        "to":               "c14_cal_to",
        "median":           "c14_cal_median",
    })

    df["admin_region"]  = df["admin_region"].map(C14_ADMIN_MAP).fillna(df["admin_region"])
    df["altitude_masl"] = pd.to_numeric(df["altitude_masl"], errors="coerce")
    df["ecozone"]       = df["altitude_masl"].apply(assign_ecozone)
    df["source_table"]  = "context"
    df["lab_id"]        = None
    # Convertir c14_cal_from/to de cal BP a BCE/CE para consistencia con SAAID
    for col in ["c14_cal_from", "c14_cal_to", "c14_cal_median"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
            df[col] = 1950 - df[col]
    # Quitar columnas no necesarias
    drop_cols = ["altitudinal_belt", "unit", "sub_unit", "material_detail",
                 "context_domestic", "context_funerary", "context_agriculture",
                 "context_other", "c14_cal_median"]
    df = df.drop(columns=drop_cols, errors="ignore")
    return df


def load_mocha(mocha_path):
    """Carga datos de Mocha 2 desde xlsx y normaliza al formato ARID."""
    if not Path(mocha_path).exists():
        return None

    df = pd.read_excel(mocha_path)

    # Renombrar columnas Unicode (nombres exactos del archivo)
    df = df.rename(columns={
        'δ¹³C VPDB (‰)': 'd13C',
        'δ¹⁵N AIR (‰)': 'd15N',
    })

    # Normalizar
    df['site_name'] = df['Site'].fillna('Mocha 2')
    df['sample_id'] = df['Sample'].fillna('unknown')
    df['sex'] = df['Sex'].fillna('Unknown')
    df['age_category'] = df['Age'].fillna('Unknown')
    df['reference_short'] = 'Wande et al. (2026)'
    df['doi'] = df['DOI'].iloc[0] if 'DOI' in df.columns else None

    # Coordenadas de Mocha 2: UTM 19S (470450.77 E, 7809263.13 S) → WGS84
    df['lat'] = -19.81231
    df['lon'] = -69.28215
    df['altitude_masl'] = 1650  # aprox. precordillera Tarapacá
    df['admin_region'] = 'Tarapaca'
    df['locality'] = 'Mocha'
    df['ecozone'] = assign_ecozone(df['altitude_masl'].iloc[0])

    # Período: Late Intermediate/Late (1250-1450 CE)
    df['period'] = 'Late Intermediate'
    df['period_broad'] = infer_period_broad('Late Intermediate')
    df['period_from'] = 1250
    df['period_to'] = 1450

    # Estructura de tejido: todos colágeno orgánico
    df['tissue'] = 'Bone collagen'
    df['element'] = df['Sample'].str.extract(r'(Mandib|Rib|Femur|Tibia|Fibula|Humerus)', expand=False)
    df['element'] = df['element'].fillna('Bone')
    df['tissue_type'] = 'organic'
    df['CN_ratio'] = df.get('C/N', None)
    df['wt_C'] = df.get('%C', None)
    df['wt_N'] = df.get('%N', None)

    # Columnas mínimas para ARID
    cols_out = ['site_name', 'sample_id', 'sex', 'age_category', 'reference_short', 'doi',
                'lat', 'lon', 'altitude_masl', 'admin_region', 'locality', 'ecozone',
                'period', 'period_broad', 'period_from', 'period_to',
                'tissue', 'element', 'tissue_type',
                'd13C', 'd15N', 'CN_ratio', 'wt_C', 'wt_N']

    df = df[[c for c in cols_out if c in df.columns]]

    # Convertir tipos
    for col in ['d13C', 'd15N', 'CN_ratio', 'wt_C', 'wt_N']:
        df[col] = pd.to_numeric(df[col], errors='coerce')

    return df


def main(input_path, outdir, c14_path=None, mocha_path=None):
    outdir = Path(outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    print("Cargando y filtrando datos...")
    tables = {}
    for sheet in ["Humans", "Animals", "Plants"]:
        raw = load_and_filter(input_path, sheet)
        df  = clean_table(raw)
        tables[sheet.lower()] = df
        print(f"  {sheet}: {df.shape}")

    # ── Extraer C14 de tablas de muestras ─────────────────────────────────────
    print("\nExtrayendo fechados C14 de tablas de muestras...")
    isotope_c14_frames = []
    for name, df in tables.items():
        c14_part = extract_c14(df, source_table=name)
        if len(c14_part):
            isotope_c14_frames.append(c14_part)
            print(f"  {name}: {len(c14_part)} fechados")
        # Marcar has_c14 y eliminar columnas C14 de la tabla de muestras
        c14_detect = [c for c in ["c14_bp", "c14_lab_code"] if c in df.columns]
        if c14_detect:
            tables[name]["has_c14"] = df[c14_detect].notna().any(axis=1)
        c14_to_drop = [c for c in C14_COLS if c in df.columns]
        tables[name] = tables[name].drop(columns=c14_to_drop)

    # ── Cargar Mocha 2 y concatenar con humans ───────────────────────────────────
    if mocha_path and Path(mocha_path).exists():
        print("\nCargando Mocha 2...")
        mocha = load_mocha(mocha_path)
        if mocha is not None:
            # Normalizar columnas de humans para que coincidan
            humans_cols = set(tables["humans"].columns)
            mocha_cols = set(mocha.columns)
            mocha_norm = mocha[[c for c in mocha.columns if c in humans_cols or c in ['site_name','sample_id','sex','age_category','reference_short','doi','lat','lon','altitude_masl','admin_region','locality','ecozone','period','period_broad','period_from','period_to','tissue','element','tissue_type','d13C','d15N','CN_ratio','wt_C','wt_N']]]
            # Agregar columnas faltantes de humans a mocha
            for col in humans_cols:
                if col not in mocha_norm.columns:
                    mocha_norm[col] = None
            # Concatenar
            tables["humans"] = pd.concat([tables["humans"], mocha_norm[[c for c in tables["humans"].columns]]], ignore_index=True)
            print(f"  Mocha 2: {mocha.shape[0]} individuos agregados")

    # ── Formato largo para humans y animals ───────────────────────────────────
    print("\nAplicando formato largo...")
    for name in ["humans", "animals"]:
        if name in tables:
            tables[name] = to_long(tables[name])
            print(f"  {name}: {tables[name].shape}")

    # ── Construir arid_c14 unificado ──────────────────────────────────────────
    mendez_c14 = None
    if c14_path:
        print("\nCargando Mendez-Quiros C14...")
        mendez_c14 = build_c14_mendez(Path(c14_path))
        print(f"  mendez_quiros: {mendez_c14.shape}")

    c14_frames = isotope_c14_frames + ([mendez_c14] if mendez_c14 is not None else [])
    if c14_frames:
        arid_c14 = pd.concat(c14_frames, ignore_index=True)
        arid_c14 = arid_c14[[c for c in C14_KEEP if c in arid_c14.columns]]
    else:
        arid_c14 = pd.DataFrame()

    # ── arid_sites ─────────────────────────────────────────────────────────────
    print("\nConstruyendo arid_sites...")
    sites = build_sites(tables, mendez_c14)
    print(f"  arid_sites: {sites.shape}")

    # ── Aplicar remove_accents a todas las tablas ──────────────────────────────
    print("\nEliminando tildes...")
    for name in list(tables.keys()):
        tables[name] = strip_accents_df(tables[name])
    sites     = strip_accents_df(sites)
    if not arid_c14.empty:
        arid_c14 = strip_accents_df(arid_c14)

    # ── Guardar como .xlsx ─────────────────────────────────────────────────────
    print("\nGuardando .xlsx...")
    sites.to_excel(outdir / "arid_sites.xlsx", index=False, engine="xlsxwriter")
    print(f"  arid_sites.xlsx — {sites.shape[0]} filas, {sites.shape[1]} columnas")

    for name, tbl in tables.items():
        tbl.to_excel(outdir / f"arid_{name}.xlsx", index=False, engine="xlsxwriter")
        print(f"  arid_{name}.xlsx — {tbl.shape[0]} filas, {tbl.shape[1]} columnas")

    if not arid_c14.empty:
        arid_c14.to_excel(outdir / "arid_c14.xlsx", index=False, engine="xlsxwriter")
        print(f"  arid_c14.xlsx — {arid_c14.shape[0]} filas, {arid_c14.shape[1]} columnas")

    print("\nListo.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input",  required=True, help="Ruta al SAAID .xlsx")
    parser.add_argument("--outdir", default=".",   help="Directorio de salida")
    parser.add_argument("--c14",    default=None,  help="Ruta al archivo Mendez-Quiros C14 .xlsx")
    parser.add_argument("--mocha",  default=None,  help="Ruta al archivo Mocha 2 isotopes .xlsx")
    args = parser.parse_args()
    main(args.input, args.outdir, args.c14, args.mocha)
