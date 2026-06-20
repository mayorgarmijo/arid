# ARID — Atacama Repository of Isotopic Data

ARID is an open, collaborative repository of isotopic data for the Atacama Desert of northern Chile, covering the regions of Arica y Parinacota, Tarapaca, and Antofagasta. It compiles published isotopic measurements from human, animal, and plant samples into a set of clean, analysis-ready datasets accessible directly from R.

## Installation

```r
# Install from GitHub
remotes::install_github("mayorgarmijo/arid")
```

## Datasets

ARID includes five datasets:

| Dataset | Description | Rows |
|---|---|---|
| `arid_humans` | Isotopic data from human skeletal and soft tissue samples (long format) | 2,598 |
| `arid_animals` | Isotopic data from faunal remains (long format) | 424 |
| `arid_plants` | Isotopic data from botanical remains | 576 |
| `arid_sites` | Geographic and chronological context for 422 archaeological sites | 422 |
| `arid_c14` | Radiocarbon dates from archaeological contexts in northern Chile | 1,127 |

### Long format (humans and animals)

`arid_humans` and `arid_animals` are stored in **long format**: one row per tissue analysed. Individuals with both organic (collagen, keratin) and carbonate (apatite) measurements appear in two rows, distinguished by the `tissue_type` column (`"organic"` or `"carbonate"`). This eliminates the `_carbonate` column family and makes tissue-specific filtering straightforward.

```r
# Only organic tissue rows
subset(arid_humans, tissue_type == "organic")

# Only carbonate rows
subset(arid_humans, tissue_type == "carbonate")
```

### Key isotopic variables

| Variable | Description |
|---|---|
| `d13C` | delta-13C from organic or carbonate tissue (per mille VPDB) |
| `d15N` | delta-15N from organic tissue (per mille AIR) |
| `d34S` | delta-34S (per mille VCDT) |
| `d18O` | delta-18O from carbonate tissue (per mille VPDB; carbonate rows only) |
| `Sr87_Sr86` | 87Sr/86Sr ratio |
| `wt_C`, `wt_N`, `CN_ratio` | Collagen quality indicators |
| `tissue` | Tissue type (e.g. Bone collagen, Hair keratin, Bone apatite) |
| `tissue_type` | "organic" or "carbonate" |

### Chronological columns

All date values in ARID use the **BCE/CE** system (negative = BCE, positive = CE):

| Column | Description |
|---|---|
| `period_broad` | Broad period category (e.g. Archaic, Formative, Late Intermediate, Late) |
| `period` | Sub-period or phase (e.g. Early Archaic, Late Formative) |
| `period_from` | Start of cultural period (BCE/CE) |
| `period_to` | End of cultural period (BCE/CE) |
| `has_c14` | Whether a direct radiocarbon date exists in `arid_c14` |

## Geographic coverage

ARID currently includes samples from 422 archaeological sites across three administrative regions of northern Chile. Samples are classified by:

- **`admin_region`**: Arica y Parinacota · Tarapaca · Antofagasta
- **`ecozone`**: Coast (< 130 masl) · Lowlands (130–1700 masl) · Precordillera (1700–3700 masl) · Altiplano (> 3700 masl)
- **`locality`**: Specific site locality (e.g. Lower Azapa Valley, Loa basin, San Pedro de Atacama Oasis)

## Usage

```r
library(ARID)

# Access datasets directly
head(arid_humans)
head(arid_c14)

# Combine tables
all_samples <- arid_merge()
humans      <- arid_merge("humans")

# Filter by ecozone
coastal <- arid_filter(tables = "humans", ecozone = "Coast")

# Filter by broad period
formative <- arid_filter(period_broad = "Formative")

# Filter by sub-period
early_archaic <- arid_filter(period = "Early Archaic")

# Filter by administrative region
antofagasta <- arid_filter(tables = "humans", admin_region = "Antofagasta")

# Combine filters (AND logic)
coastal_formative <- arid_filter(tables = "humans", ecozone = "Coast",
                                 period_broad = "Formative")

# Filter further with dplyr (e.g. only collagen)
library(dplyr)
collagen_only <- arid_filter(ecozone = "Coast") |>
  filter(grepl("collagen", tissue, ignore.case = TRUE))
```

## The `arid_merge()` function

`arid_merge()` combines one or more sample tables into a single data frame. Each table already contains site-level context and is stored in long format. When more than one table is selected, a `source` column identifies the origin of each row.

```r
# Single table
arid_merge("humans")
arid_merge("animals")
arid_merge("plants")

# Multiple tables — adds a 'source' column
arid_merge(c("humans", "animals"))
arid_merge()  # all three tables

# Select tissue type after merging
subset(arid_merge("humans"), tissue_type == "organic")
```

## The `arid_filter()` function

`arid_filter()` wraps `arid_merge()` and applies contextual filters in a single call. At least one filter argument must be provided. All arguments accept character vectors for multi-value filtering (OR logic within each argument, AND logic across arguments).

```r
# Filter by ecozone
arid_filter(ecozone = "Altiplano")

# Multiple ecozones at once
arid_filter(ecozone = c("Coast", "Lowlands"))

# Filter by broad period
arid_filter(period_broad = "Formative")

# Filter by specific sub-period
arid_filter(period = "Late Formative")

# Combine filters (AND logic)
arid_filter(tables = "humans", ecozone = "Altiplano", admin_region = "Antofagasta")

# By locality
arid_filter(locality = "Lower Azapa Valley")
```

## The `arid_chronology()` function

`arid_chronology()` assigns date ranges to samples. For samples with a direct radiocarbon date, the calibrated range from `arid_c14` is used (linked via `lab_id`). For the rest, the cultural period range is used as a fallback. Results include `date_from`, `date_to`, and `date_source` ("C14" or "period").

```r
# Assign dates in BCE/CE (default)
df <- arid_merge("humans")
df <- arid_chronology(df)

# In cal BP
df_bp <- arid_chronology(arid_merge("humans"), unit = "BP")

# Check which samples have direct C14 dates
table(df$date_source)
```

## Citation

If you use ARID in a publication, please cite it as:

> Mayorga, D. (*year*). ARID: Atacama Repository of Isotopic Data. R package. https://github.com/mayorgarmijo/arid

## Data sources

ARID compiles data from peer-reviewed publications. Each record includes a short citation (`reference_short`) and a DOI (`doi`) linking to the original source.

## Contributing

Contributions are welcome. To add new data or correct existing records, please open an issue or submit a pull request on [GitHub](https://github.com/mayorgarmijo/arid).

## License

Code: [GPL (>= 3)](LICENSE.md) · Data: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
