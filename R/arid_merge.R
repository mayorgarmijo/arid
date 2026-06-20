#' Combine ARID sample tables
#'
#' @description
#' Binds one or more ARID sample tables into a single data frame. Each table
#' already includes site-level context (locality, admin_region, ecozone, period,
#' coordinates) and is stored in long format (one row per tissue analysed). When
#' more than one table is selected, a `source` column identifies the origin of
#' each row.
#'
#' Combina una o más tablas de muestras ARID en un único data frame. Cada tabla
#' ya incluye contexto de sitio (locality, admin_region, ecozone, period,
#' coordenadas) y está en formato largo (una fila por tejido analizado). Cuando
#' se selecciona más de una tabla, una columna `source` identifica el origen de
#' cada fila.
#'
#' @param tables Character vector. One or more of `"humans"`, `"animals"`,
#'   `"plants"`. Defaults to all three.
#'
#' @return A data frame. If `length(tables) > 1`, includes a `source` column.
#'
#' @seealso [arid_filter()] to combine and filter in a single call;
#'   [arid_chronology()] to assign dates to the result.
#'
#' @examples
#' # Single table
#' arid_merge("humans")
#'
#' # All tables combined — adds a 'source' column
#' arid_merge()
#'
#' # Only organic tissue rows
#' subset(arid_merge("humans"), tissue_type == "organic")
#'
#' @export
arid_merge <- function(tables = c("humans", "animals", "plants")) {

  valid  <- c("humans", "animals", "plants")
  tables <- match.arg(tables, valid, several.ok = TRUE)

  frames <- lapply(tables, function(tbl) {
    df <- switch(tbl,
                 humans  = arid_humans,
                 animals = arid_animals,
                 plants  = arid_plants)
    if (length(tables) > 1) df$source <- tbl
    df
  })

  dplyr::bind_rows(frames)
}
