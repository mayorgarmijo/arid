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

use_data(arid_humans, arid_animals, arid_plants, arid_sites, arid_c14, overwrite = TRUE)
