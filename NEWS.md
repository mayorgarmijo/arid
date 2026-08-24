# ARID (development)

## CN_ratio proxy values / Valores aproximados de CN_ratio

- Filled `CN_ratio` for 260 organic rows that had no per-sample C:N in their
  source, at the user's request, using proxy values instead of leaving them
  blank: Ballester and Clarot (2014) and citation variants (14 rows) now use
  3.25, the midpoint of the 2.9–3.6 range reported as personal communication
  in Santana-Sagredo et al. (2021); Tomczak (2001) (243 rows) now uses the
  per-site average C:N from that paper's "Preservation Values" table. See
  `?arid_humans` for details — these are not individual lab measurements.

## Data completeness fixes / Correcciones de completitud de datos

- Filled gaps found by re-checking primary source spreadsheets against
  `arid_humans` for several already-integrated papers: Andrade et al. (2016),
  De Souza et al. (2019), Knudson and Torres-Rouff (2014), Knudson et al.
  (2015), McRostie (2014), Sandness (1992), Santana-Sagredo et al. (2019),
  and Tomczak (2001) — missing individuals, missing 87Sr/86Sr values, and
  incomplete `lab_id`/`sample_id` fields.
- Removed 158 mechanically-generated empty `tissue_type == "organic"` rows
  (a `to_long()` artifact from build_arid.py: an organic row was always
  emitted even when a source record had only carbonate data).
- Corrected 15 samples that were mis-attributed to Santana-Sagredo et al.
  (2021) — that paper's Supp. Table 4 is a compilation of other studies; these
  particular samples are primary to Santana-Sagredo et al. (2019) and are now
  correctly attributed there instead of duplicated under both references.
- `arid_c14` gains 8 radiocarbon dates recovered from the Andrade et al.
  (2016) and De Souza et al. (2019) source tables.
- `arid_humans`: 4,364 rows (net change after removing empty placeholder
  rows and duplicate-attribution fixes, despite ~175 new rows added).

## New data / Nuevos datos

- Added human isotopic samples from the south coast of Peru (Tacna and
  Moquegua regions), integrated into `arid_humans`. `arid_humans` gains a
  `country` column (`"Chile"` or `"Peru"`).
- `arid_filter()` gains a `country` argument.
- New `period` values from the Peru data: `Middle Horizon`,
  `Middle Horizon (Tumilaca phase)`, `Late Intermediate (Estuquina phase)`,
  `Republican`. The Peruvian "Early Intermediate Period" is treated as
  equivalent to `Formative` and recorded as such.
- `arid_humans`: 4,392 rows (3,298 Chile + 1,094 Peru: 1,079 Moquegua +
  15 Tacna).

# ARID 0.1.0 (development)

## Breaking changes / Cambios importantes

- `arid_humans` and `arid_animals` are now in **long format**: one row per
  tissue analysed. The `_carbonate` column family is replaced by a `tissue_type`
  column (`"organic"` / `"carbonate"`) and a unified `d18O` column.
- Radiocarbon dates have been moved out of `arid_humans`, `arid_animals`, and
  `arid_plants` into `arid_c14` (linked via `lab_id`). A `has_c14` column flags
  records that have a direct date in `arid_c14`.
- All string data is now ASCII-safe (accented characters removed).
- All date values (period ranges and calibrated radiocarbon dates) use the
  **BCE/CE** system (negative = BCE, positive = CE).
- `arid_merge()` and `arid_filter()` no longer accept a `long` argument (data
  is already in long format).
- `arid_filter()` gains a `period_broad` argument for filtering by broad period.
- Period names in `arid_animals` and `arid_plants` are now normalized
  (no "(Northern Chile)", "Period", or "Horizon" suffixes).
- `plant_domesticate` categories are now `Wild`, `Crop`, `Managed`
  (previously `No`, `Yes`, `Managed`).
- Dataset files are now `.xlsx` (previously `.csv`).

## New function / Nueva función

- `arid_chronology()`: assigns `date_from`, `date_to`, and `date_source` to any
  data frame from `arid_merge()` / `arid_filter()`. Uses direct radiocarbon
  dates from `arid_c14` where available, falls back to cultural period ranges.
  Supports `unit = "BCE"` (default) or `unit = "BP"`.

## New functions / Nuevas funciones

- `arid_merge()`: Combines one or more sample tables into a single data frame.
- `arid_filter()`: Wraps `arid_merge()` and applies contextual filters
  (ecozone, admin_region, period, period_broad, locality) in a single call.

## Datasets

- `arid_humans`: 2,598 rows in long format (1,821 organic + 777 carbonate).
  Includes `period_broad` and `has_c14` columns.
- `arid_animals`: 424 rows in long format (362 organic + 62 carbonate).
  Includes `period_broad` and `has_c14` columns.
- `arid_plants`: 576 rows. Period names normalized; `plant_domesticate`
  standardized to Wild/Crop/Managed; `period_broad` added.
- `arid_sites`: 422 sites (expanded from 195, now includes sites from
  radiocarbon databases).
- `arid_c14`: 1,127 radiocarbon dates integrating direct dates from isotopic
  samples and context-level dates from published radiocarbon databases.
