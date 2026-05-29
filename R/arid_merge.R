#' Merge ARID tables with site information
#'
#' @description
#' Joins one or more ARID sample tables with `arid_sites`, adding geographic,
#' chronological and ecological context to each sample. Optionally reshapes
#' isotope data to long format for tissue-level analysis.
#'
#' @param tables Character vector. One or more of `"humans"`, `"animals"`,
#'   `"plants"`. Defaults to all three.
#' @param long Logical. If `TRUE`, reshapes isotope columns to long format
#'   (one row per tissue measurement). Default is `FALSE`.
#'
#' @return A data frame with sample data joined to site context. If
#'   `length(tables) > 1`, a `source` column identifies the original table.
#'
#' @examples
#' # Humans with site context
#' arid_merge("humans")
#'
#' # All tables combined
#' arid_merge()
#'
#' # Long format for tissue comparison
#' arid_merge("humans", long = TRUE)
#'
#' @export
arid_merge <- function(tables = c("humans", "animals", "plants"), long = FALSE) {

  valid <- c("humans", "animals", "plants")
  tables <- match.arg(tables, valid, several.ok = TRUE)

  # Columnas de sitio a agregar
  site_cols <- c(
    "site_name", "locality", "admin_region", "ecozone",
    "lat", "lon", "altitude_masl",
    "period", "period_from", "period_to"
  )
  sites_sub <- arid_sites[, intersect(site_cols, colnames(arid_sites))]

  # Cargar y combinar tablas solicitadas
  frames <- lapply(tables, function(tbl) {
    df <- switch(tbl,
                 humans  = arid_humans,
                 animals = arid_animals,
                 plants  = arid_plants
    )
    if (length(tables) > 1) df$source <- tbl
    df
  })

  combined <- dplyr::bind_rows(frames)

  # Join con arid_sites — evitar duplicar columnas ya existentes
  site_add <- setdiff(colnames(sites_sub), colnames(combined))
  sites_join <- sites_sub[, c("site_name", site_add), drop = FALSE]
  result <- merge(combined, sites_join, by = "site_name", all.x = TRUE)

  # Formato long (una fila por bloque de tejido)
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
      names(df_organic) <- gsub("_carbonate$", "", names(df_organic))

      df_carbonate <- result[, c(base_cols, cols_carbonate)]
      df_carbonate$tissue_block <- "carbonate"
      names(df_carbonate) <- gsub("_carbonate$", "", names(df_carbonate))

      result <- dplyr::bind_rows(df_organic, df_carbonate)
      result <- result[!is.na(result$tissue_block), ]
    }
  }

  result
}
