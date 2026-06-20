# ARID 0.1.0 (development)

## New functions / Nuevas funciones

- `arid_merge()`: Combines one or more sample tables into a single data frame,
  with optional long-format reshaping for tissue-level analysis.
- `arid_filter()`: Wraps `arid_merge()` and applies contextual filters
  (ecozone, admin_region, period, locality) in a single call.

## Datasets

- `arid_humans`: 1,821 isotopic measurements from human samples. Includes new
  `period_broad` column with simplified period groupings.
- `arid_animals`: 362 isotopic measurements from faunal remains.
- `arid_plants`: 576 isotopic measurements from botanical remains.
- `arid_sites`: Geographic and chronological context for 195 archaeological sites.
- `arid_c14`: 1,003 radiocarbon dates from Tarapacá and Arica y Parinacota
  (Méndez-Quiros et al. 2023 supplementary data).
