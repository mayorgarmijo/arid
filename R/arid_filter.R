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
#'   `"Arica y Parinacota"`, `"Tarapacá"`, `"Antofagasta"`.
#' @param period Character vector. One or more chronological periods
#'   (e.g. `"Early Archaic (Northern Chile)"`).
#' @param locality Character vector. One or more localities
#'   (e.g. `"Lower Azapa Valley"`).
#' @param long Logical. If `TRUE`, reshapes isotope columns to long format.
#'   Passed directly to `arid_merge()`. Default is `FALSE`.
#'
#' @return A filtered data frame.
#'
#' @seealso [arid_merge()] for the underlying combine function.
#'
#' @examples
#' # Humans from the Altiplano
#' arid_filter(tables = "humans", ecozone = "Altiplano")
#'
#' # Multiple ecozones and an administrative region
#' arid_filter(ecozone = c("Coast", "Lowlands"), admin_region = "Antofagasta")
#'
#' # Specific period in long format
#' arid_filter(period = "Early Archaic (Northern Chile)", long = TRUE)
#'
#' @export
arid_filter <- function(tables = c("humans", "animals", "plants"),
                        ecozone      = NULL,
                        admin_region = NULL,
                        period       = NULL,
                        locality     = NULL,
                        long         = FALSE) {

  # Validar que se proporcionó al menos un filtro
  if (is.null(ecozone) && is.null(admin_region) && is.null(period) && is.null(locality)) {
    stop("At least one filter must be provided: ecozone, admin_region, period, or locality.")
  }

  valid  <- c("humans", "animals", "plants")
  tables <- match.arg(tables, valid, several.ok = TRUE)

  # Obtener datos combinados
  result <- arid_merge(tables = tables, long = long)

  # Capturar valores antes del filter para evitar ambigüedad con nombres de columna
  ez  <- ecozone
  ar  <- admin_region
  per <- period
  loc <- locality

  if (!is.null(ez))  result <- dplyr::filter(result, .data$ecozone      %in% ez)
  if (!is.null(ar))  result <- dplyr::filter(result, .data$admin_region %in% ar)
  if (!is.null(per)) result <- dplyr::filter(result, .data$period       %in% per)
  if (!is.null(loc)) result <- dplyr::filter(result, .data$locality     %in% loc)

  result
}
