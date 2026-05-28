## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)
dir.create("corrections")

library(usethis)

arid_humans  <- read.csv("data-raw/arid_humans.csv")
arid_animals <- read.csv("data-raw/arid_animals.csv")
arid_plants  <- read.csv("data-raw/arid_plants.csv")
arid_sites   <- read.csv("data-raw/arid_sites.csv")

use_data(arid_humans, arid_animals, arid_plants, arid_sites)


library(ARID)
head(arid_humans)
nrow(arid_sites)

library(ARID)
head(arid_humans)
