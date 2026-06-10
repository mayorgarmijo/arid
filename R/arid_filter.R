#' Filter ARID data by geographic and chronological variables
#'
#' @description
#' Calls `arid_merge()` internally and filters the result by one or more
#' contextual variables. At least one filter argument must be provided.
#' Multiple values per argument are accepted (treated as OR within that filter).
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
#' @return A filtered data frame with sample data joined to site context.
#'
#' @examples
#' # Humanos del Altiplano
#' arid_filter(tables = "humans", ecozone = "Altiplano")
#'
#' # Varias ecozonas y región administrativa
#' arid_filter(ecozone = c("Coast", "Lowlands"), admin_region = "Antofagasta")
#'
#' # Período específico en formato largo
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
    stop("Debe especificarse al menos un filtro: ecozone, admin_region, period o locality.")
  }

  valid <- c("humans", "animals", "plants")
  tables <- match.arg(tables, valid, several.ok = TRUE)

  # Obtener datos combinados con contexto de sitio
  result <- arid_merge(tables = tables, long = long)

  # Aplicar filtros para cada argumento no-NULL
  if (!is.null(ecozone))      result <- dplyr::filter(result, .data$ecozone      %in% ecozone)
  if (!is.null(admin_region)) result <- dplyr::filter(result, .data$admin_region %in% admin_region)
  if (!is.null(period))       result <- dplyr::filter(result, .data$period       %in% period)
  if (!is.null(locality))     result <- dplyr::filter(result, .data$locality     %in% locality)

  result
}
