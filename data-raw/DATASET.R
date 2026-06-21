# Script para regenerar los objetos de datos del paquete ARID.
# Ejecutar desde la raíz del proyecto con: source("data-raw/DATASET.R")

library(usethis)
library(readxl)

arid_humans  <- read_xlsx("data-raw/arid_humans.xlsx",  guess_max = Inf)
arid_animals <- read_xlsx("data-raw/arid_animals.xlsx", guess_max = Inf)
arid_plants  <- read_xlsx("data-raw/arid_plants.xlsx")
arid_sites   <- read_xlsx("data-raw/arid_sites.xlsx")
arid_c14     <- read_xlsx("data-raw/arid_c14.xlsx")

use_data(arid_humans, arid_animals, arid_plants, arid_sites, arid_c14, overwrite = TRUE)
