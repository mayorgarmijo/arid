"""
One-shot script to process Vidal-Elgueta et al. (2024) maize d18O data
and append rows to data-raw/arid_plants.xlsx in long format.

Run from project root: python data-raw/process_vidal_elgueta_2024.py
"""
import pandas as pd
import numpy as np

SITE_META = {
    "Caserones":           dict(site_name="Caserones",             locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1289, admin_region="Tarapaca",          lat=-20.02, lon=-69.57, period_broad="Formative",        period="Late Formative"),
    "Cerro colorado 7":    dict(site_name="Alero Cerro Colorado 7", locality="Salar de Llamara",       ecozone="Precordillera", altitude_masl=2600, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Colonial",          period="Colonial"),
    "DGA quipisca":        dict(site_name="DGA Quipisca",           locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1121, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Modern",            period="Modern"),
    "Huaylacan":           dict(site_name="Huaylacan",              locality="Lluta",                  ecozone="Lowlands",     altitude_masl=143,  admin_region="Arica y Parinacota",lat=None,   lon=None,   period_broad="Late Intermediate", period="Late Intermediate"),
    "Iluga tumulos":       dict(site_name="Iluga Tumulos",          locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1145, admin_region="Tarapaca",          lat=-20.02, lon=-69.61, period_broad="Formative",        period="Early Formative"),
    "Millune":             dict(site_name="Millune",                locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1500, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Late",              period="Late"),
    "Pica 8":              dict(site_name="Pica 8",                 locality="Inland oases, Pica",     ecozone="Lowlands",     altitude_masl=1225, admin_region="Tarapaca",          lat=-20.49, lon=-69.36, period_broad="Late Intermediate", period="Late Intermediate"),
    "Pintados 1307":       dict(site_name="PT1307",                 locality="Pampa del Tamarugal",    ecozone="Lowlands",     altitude_masl=981,  admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Formative",        period="Early Formative"),
    "Ramaditas":           dict(site_name="Ramaditas",              locality="Llamara",                ecozone="Lowlands",     altitude_masl=1112, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Formative",        period="Early Formative"),
    "Tarapacá 40":         dict(site_name="Tarapaca 40",            locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1291, admin_region="Tarapaca",          lat=-20.02, lon=-69.57, period_broad="Formative",        period="Formative"),
    "Tarapacá Viejo":      dict(site_name="Tarapaca Viejo",         locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1426, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Late",              period="Late"),
    "PT 2372 (ILP014)":    dict(site_name="PT2372",                 locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1117, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Late Intermediate", period="Late Intermediate"),
    "PT2373 (ILP015)":     dict(site_name="PT2373",                 locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1117, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Late Intermediate", period="Late Intermediate"),
    "PT2698":              dict(site_name="PT2698",                 locality="Pampa del Tamarugal",    ecozone="Lowlands",     altitude_masl=1111, admin_region="Tarapaca",          lat=None,   lon=None,   period_broad="Formative",        period="Early Formative"),
    "Tarapacá 13":         dict(site_name="Tarapaca 13",            locality="Middle Tarapaca Valley", ecozone="Lowlands",     altitude_masl=1395, admin_region="Tarapaca",          lat=-20.02, lon=-69.57, period_broad="Late Intermediate", period="Late Intermediate"),
}

FIXED = dict(
    taxon_local="Maíz",
    genus_species="Zea mays",
    type_source="archaeobotanical",
    photosynthetic_pathway="C4",
    plant_domesticate="domesticate",
    has_c14=False,
    reference_short="Vidal-Elgueta et al. (2024)",
    doi="10.1016/j.jasrep.2024.104775",
    d13C=None, d15N=None, d34S=None, Sr87_Sr86=None,
    wt_C=None, wt_N=None, CN_ratio=None,
    period_from=None, period_to=None,
)

def to_float(v):
    try:
        f = float(v)
        return f if not np.isnan(f) else None
    except (TypeError, ValueError):
        return None

def make_base_row(id_intern, site_key, prefix):
    meta = SITE_META[site_key]
    sample_type = "modern" if meta["period_broad"] == "Modern" else "archaeological"
    lab_id = f"VE2024_{prefix}{int(id_intern)}"
    row = {**FIXED, **meta,
           "lab_id": lab_id,
           "sample_id": lab_id,
           "sample_type": sample_type}
    return row

rows = []

# --- Kernels ---
k = pd.read_excel("data-raw/Vidal-Elgueta et al. 2024.xlsx",
                  sheet_name="Data kernel", header=[0, 1])
k.columns = [
    "id", "sample_type_src", "site", "mass_mg",
    "om_pct", "om_C", "om_O", "om_d18O", "om_CO",
    "st_pct", "st_C", "st_O", "st_d18O", "st_CO", "st_Dd18O",
    "cel_pct", "cel_C", "cel_O", "cel_d18O", "cel_CO", "cel_extra"
]

for _, r in k.iterrows():
    if pd.isna(r["id"]):
        continue
    site_key = r["site"]
    if site_key not in SITE_META:
        print(f"WARNING: unknown site '{site_key}', skipping")
        continue
    base = make_base_row(r["id"], site_key, "K")

    for tissue, col in [("Kernel OM", "om_d18O"), ("Kernel starch", "st_d18O"), ("Kernel cellulose", "cel_d18O")]:
        val = to_float(r[col])
        if val is not None:
            rows.append({**base, "tissue": tissue, "d18O": val})

# --- Cobs ---
c = pd.read_excel("data-raw/Vidal-Elgueta et al. 2024.xlsx",
                  sheet_name="Data cobs", header=[0, 1])
c.columns = [
    "id", "sample_type_src", "site",
    "om_pct", "om_C", "om_O", "om_d18O", "om_CO",
    "cel_pct", "cel_C", "cel_O", "cel_d18O", "cel_CO",
    "d2HCN", "d_extra"
]

for _, r in c.iterrows():
    if pd.isna(r["id"]):
        continue
    site_key = r["site"]
    if site_key not in SITE_META:
        print(f"WARNING: unknown site '{site_key}', skipping")
        continue
    base = make_base_row(r["id"], site_key, "C")

    for tissue, col in [("Cob OM", "om_d18O"), ("Cob cellulose", "cel_d18O")]:
        val = to_float(r[col])
        if val is not None:
            rows.append({**base, "tissue": tissue, "d18O": val})

new_df = pd.DataFrame(rows)
print(f"New rows generated: {len(new_df)}")
print(new_df["tissue"].value_counts())
print(new_df["site_name"].value_counts())

# Append to arid_plants.xlsx
existing = pd.read_excel("data-raw/arid_plants.xlsx")
combined = pd.concat([existing, new_df], ignore_index=True)
combined.to_excel("data-raw/arid_plants.xlsx", index=False)
print(f"\narid_plants.xlsx updated: {len(existing)} existing + {len(new_df)} new = {len(combined)} total rows")
