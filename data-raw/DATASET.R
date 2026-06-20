# Script para regenerar los objetos de datos del paquete ARID.
# Ejecutar desde la raíz del proyecto con: source("data-raw/DATASET.R")

library(usethis)

arid_humans  <- read.csv("data-raw/arid_humans.csv",  stringsAsFactors = FALSE)
arid_animals <- read.csv("data-raw/arid_animals.csv", stringsAsFactors = FALSE)
arid_plants  <- read.csv("data-raw/arid_plants.csv",  stringsAsFactors = FALSE)
arid_sites   <- read.csv("data-raw/arid_sites.csv",   stringsAsFactors = FALSE)
arid_c14     <- read.csv("data-raw/arid_c14.csv",     stringsAsFactors = FALSE)

use_data(arid_humans, arid_animals, arid_plants, arid_sites, arid_c14, overwrite = TRUE)
