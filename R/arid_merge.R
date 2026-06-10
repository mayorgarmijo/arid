#' Combine ARID sample tables
#'
#' @description
#' Binds one or more ARID sample tables into a single data frame. Each table
#' already includes site-level context (locality, admin_region, ecozone, period,
#' coordinates). When more than one table is selected, a `source` column
#' identifies the origin of each row. Optionally reshapes isotope data to long
#' format for tissue-level analysis.
#'
#' Combina una o más tablas de muestras ARID en un único data frame. Cada tabla
#' ya incluye contexto de sitio (locality, admin_region, ecozone, period,
#' coordenadas). Cuando se selecciona más de una tabla, una columna `source`
#' identifica la tabla de origen de cada fila.
#'
#' @param tables Character vector. One or more of `"humans"`, `"animals"`,
#'   `"plants"`. Defaults to all three.
#' @param long Logical. If `TRUE`, reshapes isotope columns to long format
#'   (one row per tissue block: organic / carbonate). Default is `FALSE`.
#'
#' @return A data frame. If `length(tables) > 1`, includes a `source` column.
#'
#' @seealso [arid_filter()] to combine and filter in a single call.
#'
#' @examples
#' # Single table
#' arid_merge("humans")
#'
#' # All tables combined — adds a 'source' column
#' arid_merge()
#'
#' # Long format: one row per tissue block
#' arid_merge("humans", long = TRUE)
#'
#' @export
arid_merge <- function(tables = c("humans", "animals", "plants"), long = FALSE) {

  valid  <- c("humans", "animals", "plants")
  tables <- match.arg(tables, valid, several.ok = TRUE)

  # Cargar y combinar tablas solicitadas
  frames <- lapply(tables, function(tbl) {
    df <- switch(tbl,
                 humans  = arid_humans,
                 animals = arid_animals,
                 plants  = arid_plants)
    if (length(tables) > 1) df$source <- tbl
    df
  })

  result <- dplyr::bind_rows(frames)

  # Formato long: una fila por bloque de tejido (orgánico / carbonato)
  if (long) {
    iso_organic   <- c("tissue", "element", "tissue_age",
                       "yield_pct", "wt_C", "wt_N", "CN_ratio",
                       "d13C", "d15N", "wt_S", "d34S")
    iso_carbonate <- c("tissue_carbonate", "element_carbonate", "tissue_age_carbonate",
                       "d13C_carbonate", "d18O_carbonate")

    cols_organic   <- intersect(iso_organic,   colnames(result))
    cols_carbonate <- intersect(iso_carbonate, colnames(result))

    if (length(cols_organic) > 0 && length(cols_carbonate) > 0) {
      base_cols <- setdiff(colnames(result), c(cols_organic, cols_carbonate))

      df_organic <- result[, c(base_cols, cols_organic)]
      df_organic$tissue_block <- "organic"

      df_carbonate <- result[, c(base_cols, cols_carbonate)]
      df_carbonate$tissue_block <- "carbonate"
      names(df_carbonate) <- gsub("_carbonate$", "", names(df_carbonate))

      result <- dplyr::bind_rows(df_organic, df_carbonate)
      result <- result[!is.na(result$tissue_block), ]
    }
  }

  result
}
