"""
build_arid.py
Construye las tablas limpias de ARID a partir del SAAID original.

Uso:
    python build_arid.py --input saaid_v_2_0_2023-2.xlsx --outdir ../data-raw

Outputs:
    arid_humans.csv
    arid_animals.csv
    arid_plants.csv
    arid_sites.csv
    ../corrections/site_corrections.csv  (solo si no existe; si existe lo respeta)
"""

import argparse
import pandas as pd
from pathlib import Path

# ── Filtro geográfico ─────────────────────────────────────────────────────────
TARGET_REGIONS = ["North Coast of Chile", "Northern Chile"]

# ── Normalización de Biome_2 → ecozone ───────────────────────────────────────
BIOME2_MAP = {
    "Atacama Desert":                    "Transversal valley",
    "Atacama Desert-Altiplano":          "Altiplano",
    "Atacama Desert-Cordillera de la costa": "Cordillera de la costa",
    "Atacama Desert-Inland":             "Transversal valley",
    "Atacama Desert-Interior Desert":    "Interior Desert",
    "Atacama Desert-Littoral":           "Littoral",
    "Atacama Desert-Middle depression":  "Middle depression",
    "Atacama Desert-Precordillera":      "Altiplano",
    "Atacama Desert-Transversal valley": "Transversal valley",
}

# ── Normalización de región administrativa ────────────────────────────────────
ADMIN_MAP = {
    "Arica and Parinacota Region": "Arica y Parinacota",
    "Parinacota and Arica Region": "Arica y Parinacota",
    "Arica and Parincota Region":  "Arica y Parinacota",
    "Parincota and Arica Region":  "Arica y Parinacota",
    "Tarapacá Region":             "Tarapacá",
    "Tarpacá Region":              "Tarapacá",
    "Antofagasta Region":          "Antofagasta",
    "Atacama Region":              "Atacama",
}

# Casos especiales sin región al final del string
SPECIAL_LOCALITY = {
    "From Laguna Lejía (~4500 masl) to the eastern margin of the Salar de Atacama, near Talabre (2700 masl)":
        ("Laguna Lejía to Salar de Atacama", "Antofagasta"),
}

GEO_COL = "Valley, locality, closest town, political jurisdiction"

# ── Columnas a eliminar siempre ───────────────────────────────────────────────
DROP_ALWAYS = [
    "Country",
    "Age_System_Relative", "Age_System_Absolute",
    "δ18O standard", "δ18Ophosphate",
    "206Pb/204Pb", "207Pb/204Pb", "208Pb/204Pb",
    "Compilation_Reference", "Compilation_Full_Reference",
    # Columnas eliminadas por decisión de diseño ARID
    "Biome_1", "Biome 1",
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
    "Tissue": "tissue_collagen",
    "Element": "element_collagen",
    "Tissue_age": "tissue_age_collagen",
    "Tissue.1": "tissue_carbonate",
    "Element.1": "element_carbonate",
    "Tissue_age.1": "tissue_age_carbonate",
    "Sex_indiv": "sex",
    "Age_category": "age_category",
    "Min_age": "age_min",
    "Max_age": "age_max",
    "Min_age.1": "tissue_age_collagen_min",
    "Max_age.1": "tissue_age_collagen_max",
    "Min_age.2": "tissue_age_carbonate_min",
    "Max_age.2": "tissue_age_carbonate_max",
    "%Yield": "yield_pct",
    "wt%C": "wt_C",
    "wt%N": "wt_N",
    "C:N": "CN_ratio",
    "δ13C": "d13C_collagen",
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
}

# ── Columnas que van a arid_sites ─────────────────────────────────────────────
SITE_COLS = [
    "site_name", "lat", "lon", "altitude_masl",
    "locality", "admin_region", "ecozone",
    "period", "period_from", "period_to",
]


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
    parsed = df[GEO_COL].apply(parse_geo)
    df["locality"] = parsed["locality"]
    df["admin_region"] = parsed["admin_region"]

    biome_col = "Biome_2" if "Biome_2" in df.columns else "Biome 2"
    df["ecozone"] = df[biome_col].map(BIOME2_MAP)

    empty_cols = [c for c in df.columns if df[c].isna().all()]
    to_drop = set(DROP_ALWAYS + empty_cols + [GEO_COL, biome_col])
    df = df.drop(columns=[c for c in to_drop if c in df.columns])

    df = df.rename(columns={k: v for k, v in RENAME.items() if k in df.columns})

    return df


def build_sites(tables, corrections_path):
    def first_notnull(s):
        vals = s.dropna()
        return vals.iloc[0] if len(vals) else None

    frames = [
        tbl[[c for c in SITE_COLS if c in tbl.columns]].drop_duplicates()
        for tbl in tables.values()
    ]
    sites_raw = pd.concat(frames, ignore_index=True)
    sites = sites_raw.groupby("site_name").agg(first_notnull).reset_index()

    all_ecozones = (
        pd.concat([tbl[["site_name", "ecozone"]] for tbl in tables.values()])
        .groupby("site_name")["ecozone"]
        .nunique()
    )
    conflicted = all_ecozones[all_ecozones > 1].index.tolist()

    corrections_path = Path(corrections_path)

    if not corrections_path.exists():
        conflict_rows = []
        for site in conflicted:
            ecozones = (
                pd.concat([tbl[["site_name", "ecozone"]] for tbl in tables.values()])
                .query("site_name == @site")["ecozone"]
                .dropna()
                .unique()
                .tolist()
            )
            current = sites.loc[sites["site_name"] == site, "ecozone"].values[0]
            conflict_rows.append({
                "site_name": site,
                "ecozone_in_data": " | ".join(ecozones),
                "ecozone_corrected": current,
                "notes": "",
            })
        corrections_df = pd.DataFrame(conflict_rows)
        corrections_path.parent.mkdir(parents=True, exist_ok=True)
        corrections_df.to_csv(corrections_path, index=False)
        print(f"  → Archivo de correcciones generado: {corrections_path}")
        print(f"    Revisá y editá 'ecozone_corrected' para los {len(conflicted)} sitios con conflicto.")
    else:
        corrections_df = pd.read_csv(corrections_path)
        for _, row in corrections_df.iterrows():
            if pd.notna(row["ecozone_corrected"]):
                sites.loc[sites["site_name"] == row["site_name"], "ecozone"] = row["ecozone_corrected"]
        print(f"  → Correcciones aplicadas desde {corrections_path} ({len(corrections_df)} sitios).")

    return sites


def main(input_path, outdir):
    outdir = Path(outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    corrections_path = Path(outdir).parent / "corrections" / "site_corrections.csv"

    print("Cargando y filtrando datos...")
    tables = {}
    for sheet in ["Humans", "Animals", "Plants"]:
        raw = load_and_filter(input_path, sheet)
        df = clean_table(raw)
        tables[sheet.lower()] = df
        print(f"  {sheet}: {tables[sheet.lower()].shape}")

    print("\nConstruyendo arid_sites...")
    sites = build_sites(tables, corrections_path)
    print(f"  arid_sites: {sites.shape}")

    print("\nGuardando CSVs...")
    sites.to_csv(outdir / "arid_sites.csv", index=False)
    for name, tbl in tables.items():
        tbl.to_csv(outdir / f"arid_{name}.csv", index=False)
        print(f"  arid_{name}.csv — {tbl.shape[0]} filas, {tbl.shape[1]} columnas")

    print("\nListo.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, help="Ruta al SAAID .xlsx")
    parser.add_argument("--outdir", default=".", help="Directorio de salida")
    args = parser.parse_args()
    main(args.input, args.outdir)
