#' Filter ARID data by geographic and chronological variables
#'
#' @description
#' Calls `arid_merge()` internally and filters the result by one or more
#' contextual variables. At least one filter argument must be provided.
#' Multiple values per argument are accepted (OR logic within each argument,
#' AND logic across arguments).
#'
#' Llama a `arid_merge()` internamente y filtra el resultado por una o más
#' variables contextuales. Debe proporcionarse al menos un argumento de filtro.
#' Cada argumento acepta vectores de valores (lógica OR dentro del argumento,
#' lógica AND entre argumentos).
#'
#' @param tables Character vector. One or more of `"humans"`, `"animals"`,
#'   `"plants"`. Defaults to all three.
#' @param ecozone Character vector. One or more ecozones to keep:
#'   `"Coast"`, `"Lowlands"`, `"Precordillera"`, `"Altiplano"`.
#' @param admin_region Character vector. One or more administrative regions:
#'   `"Arica y Parinacota"`, `"Tarapaca"`, `"Antofagasta"`.
#' @param period Character vector. One or more sub-periods
#'   (e.g. `"Early Archaic"`, `"Late Formative"`).
#' @param period_broad Character vector. One or more broad period categories
#'   (e.g. `"Archaic"`, `"Formative"`, `"Late Intermediate"`, `"Late"`).
#' @param locality Character vector. One or more localities
#'   (e.g. `"Lower Azapa Valley"`).
#' @param tissue_type Character vector. One or more of `"organic"`,
#'   `"carbonate"` (humans and animals only; ignored for plant rows, which
#'   have no `tissue_type` column).
#'
#' @return A filtered data frame.
#'
#' @seealso [arid_merge()] for the underlying combine function;
#'   [arid_chronology()] to assign dates to the result.
#'
#' @examples
#' # Humans from the Altiplano
#' arid_filter(tables = "humans", ecozone = "Altiplano")
#'
#' # Multiple ecozones and an administrative region
#' arid_filter(ecozone = c("Coast", "Lowlands"), admin_region = "Antofagasta")
#'
#' # Broad period filter
#' arid_filter(period_broad = "Formative")
#'
#' # Specific sub-period
#' arid_filter(period = "Early Archaic")
#'
#' # Only carbonate tissue rows for humans
#' arid_filter(tables = "humans", tissue_type = "carbonate")
#'
#' @export
arid_filter <- function(tables       = c("humans", "animals", "plants"),
                        ecozone      = NULL,
                        admin_region = NULL,
                        period       = NULL,
                        period_broad = NULL,
                        locality     = NULL,
                        tissue_type  = NULL) {

  if (is.null(ecozone) && is.null(admin_region) && is.null(period) &&
      is.null(period_broad) && is.null(locality) && is.null(tissue_type)) {
    stop("At least one filter must be provided: ecozone, admin_region, period, period_broad, locality, or tissue_type.")
  }

  result <- arid_merge(tables = tables)

  # Capturar valores antes del filter para evitar ambigüedad con nombres de columna
  ez  <- ecozone
  ar  <- admin_region
  per <- period
  pb  <- period_broad
  loc <- locality
  tt  <- tissue_type

  if (!is.null(ez))  result <- dplyr::filter(result, .data$ecozone      %in% ez)
  if (!is.null(ar))  result <- dplyr::filter(result, .data$admin_region %in% ar)
  if (!is.null(per)) result <- dplyr::filter(result, .data$period       %in% per)
  if (!is.null(pb))  result <- dplyr::filter(result, .data$period_broad %in% pb)
  if (!is.null(loc)) result <- dplyr::filter(result, .data$locality     %in% loc)
  if (!is.null(tt))  result <- dplyr::filter(result, .data$tissue_type  %in% tt)

  result
}
