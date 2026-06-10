# Declarar variables globales para evitar NOTEs en R CMD CHECK
utils::globalVariables(c("arid_humans", "arid_animals", "arid_plants", ".data"))
