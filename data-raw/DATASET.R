# Script para regenerar los objetos de datos del paquete ARID.
# Ejecutar desde la raíz del proyecto con: source("data-raw/DATASET.R")

library(usethis)
library(readxl)

arid_humans  <- read_xlsx("data-raw/arid_humans.xlsx",  guess_max = Inf)
arid_animals <- read_xlsx("data-raw/arid_animals.xlsx", guess_max = Inf)
arid_plants  <- read_xlsx("data-raw/arid_plants.xlsx")
arid_sites   <- read_xlsx("data-raw/arid_sites.xlsx")
arid_c14     <- read_xlsx("data-raw/arid_c14.xlsx")

PERIOD_BROAD_LEVELS <- c(
  "Archaic", "Formative", "Formative/Middle", "Middle",
  "Middle/Late Intermediate", "Middle/Late Intermediate/Late", "Late Intermediate",
  "Late Intermediate/Late", "Late",
  "Hispanic", "Colonial", "Modern", "Archaeological"
)

PERIOD_LEVELS <- c(
  "Early Archaic", "Middle Archaic", "Late Archaic", "Middle/Late Archaic", "Archaic",
  "Tarajne phase - Early Formative", "Early Formative", "Middle Formative",
  "Late Formative", "Formative", "Formative/Middle",
  "Middle", "Middle/Late Intermediate", "Middle/Late Intermediate/Late",
  "Late Intermediate/Pica phase", "Late Intermediate",
  "Late Intermediate-Late", "Late Intermediate/Late",
  "Late", "Hispanic", "Colonial", "Modern", "Archaeological (no date)"
)

ECOZONE_LEVELS <- c("Coast", "Lowlands", "Precordillera", "Altiplano")

apply_factors <- function(df) {
  if ("period_broad" %in% names(df))
    df$period_broad <- factor(df$period_broad, levels = PERIOD_BROAD_LEVELS, ordered = TRUE)
  if ("period" %in% names(df))
    df$period <- factor(df$period, levels = PERIOD_LEVELS, ordered = TRUE)
  if ("ecozone" %in% names(df))
    df$ecozone <- factor(df$ecozone, levels = ECOZONE_LEVELS, ordered = TRUE)
  df
}

arid_humans  <- apply_factors(arid_humans)
arid_animals <- apply_factors(arid_animals)
arid_plants  <- apply_factors(arid_plants)
arid_sites   <- apply_factors(arid_sites)
arid_c14     <- apply_factors(arid_c14)

reorder_cols <- function(df, cols) df[, intersect(cols, names(df))]

HUMANS_COLS <- c(
  "admin_region", "locality", "ecozone", "site_name",
  "lab_id", "sample_id", "sex",
  "period_broad", "period", "period_from", "period_to",
  "tissue", "d13C", "d15N", "d34S", "Sr87_Sr86", "d18O",
  "lat", "lon", "altitude_masl",
  "age_category", "age_min", "age_max", "sample_type", "element", "tissue_type",
  "tissue_age", "tissue_age_min", "tissue_age_max",
  "wt_C", "wt_N", "CN_ratio", "wt_S", "yield_pct",
  "has_c14", "reference_short", "doi"
)

ANIMALS_COLS <- c(
  "admin_region", "locality", "ecozone", "site_name",
  "lab_id", "sample_id", "type_source", "taxon_local", "genus_species",
  "period_broad", "period", "period_from", "period_to",
  "tissue", "d13C", "d15N", "d34S", "Sr87_Sr86", "d18O",
  "lat", "lon", "altitude_masl",
  "sample_type", "element", "tissue_type",
  "wt_C", "wt_N", "CN_ratio", "wt_S", "yield_pct",
  "has_c14", "reference_short", "doi"
)

PLANTS_COLS <- c(
  "admin_region", "locality", "ecozone", "site_name",
  "lab_id", "sample_id", "type_source", "taxon_local", "genus_species",
  "photosynthetic_pathway", "plant_domesticate",
  "period_broad", "period", "period_from", "period_to",
  "d13C", "d15N", "d34S", "Sr87_Sr86",
  "lat", "lon", "altitude_masl",
  "sample_type", "wt_C", "wt_N", "CN_ratio",
  "has_c14", "reference_short", "doi"
)

SITES_COLS <- c(
  "admin_region", "locality", "ecozone", "site_name",
  "period_broad", "period", "period_from", "period_to",
  "lat", "lon", "altitude_masl"
)

C14_COLS <- c(
  "admin_region", "locality", "ecozone", "site_name",
  "lab_id", "sample_id",
  "c14_bp", "c14_error", "c14_cal_from", "c14_cal_to",
  "c14_method", "c14_lab_code", "material", "d13C_ams",
  "altitude_masl", "source_table", "reference_short"
)

arid_humans  <- reorder_cols(arid_humans,  HUMANS_COLS)
arid_animals <- reorder_cols(arid_animals, ANIMALS_COLS)
arid_plants  <- reorder_cols(arid_plants,  PLANTS_COLS)
arid_sites   <- reorder_cols(arid_sites,   SITES_COLS)
arid_c14     <- reorder_cols(arid_c14,     C14_COLS)

use_data(arid_humans, arid_animals, arid_plants, arid_sites, arid_c14, overwrite = TRUE)
