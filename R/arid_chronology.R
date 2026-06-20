#' Assign chronological date ranges to ARID samples
#'
#' @description
#' Adds `date_from`, `date_to`, and `date_source` columns to a data frame
#' returned by `arid_merge()` or `arid_filter()`. For samples with a direct
#' radiocarbon date (`has_c14 == TRUE`), the calibrated range from `arid_c14`
#' is used. For the rest, the cultural period range (`period_from` /
#' `period_to`) is used as a fallback. Results are returned in the selected
#' unit system.
#'
#' Agrega columnas `date_from`, `date_to` y `date_source` a un data frame
#' generado por `arid_merge()` o `arid_filter()`. Para muestras con fechado
#' radiocarbónico propio (`has_c14 == TRUE`), se usa el rango calibrado de
#' `arid_c14`. Para el resto, se usa como alternativa el rango del período
#' cultural (`period_from` / `period_to`).
#'
#' @details
#' **Date systems / Sistemas de fechas:**
#' - All dates in ARID — including `period_from`/`period_to` and
#'   the calibrated radiocarbon ranges in `arid_c14` — are stored in
#'   **BCE/CE** (negative = BCE, positive = CE).
#' - When `unit = "BP"`, dates are converted to cal BP: `BP = 1950 - CE`.
#'
#' @param data A data frame from `arid_merge()` or `arid_filter()`.
#'   Must contain a `lab_id` column.
#' @param unit Character. Output date system: `"BCE"` (default; negative =
#'   BCE, positive = CE) or `"BP"` (cal BP).
#'
#' @return The input data frame with three new columns:
#'   \describe{
#'     \item{date_from}{Start of date range in the selected unit.}
#'     \item{date_to}{End of date range in the selected unit.}
#'     \item{date_source}{`"C14"` if a direct radiocarbon date was found in
#'       `arid_c14`; `"period"` if the period range was used as a fallback.}
#'   }
#'
#' @seealso [arid_merge()], [arid_filter()], [arid_c14].
#'
#' @examples
#' # Assign chronology in BCE/CE (default)
#' df <- arid_merge("humans")
#' df <- arid_chronology(df)
#' head(df[, c("sample_id", "date_from", "date_to", "date_source")])
#'
#' # In cal BP
#' df_bp <- arid_chronology(arid_merge("humans"), unit = "BP")
#'
#' @export
arid_chronology <- function(data, unit = c("BCE", "BP")) {
  unit <- match.arg(unit)

  if (!"lab_id" %in% colnames(data)) {
    stop("'data' must contain a 'lab_id' column (output of arid_merge or arid_filter).")
  }

  # Seleccionar fechados C14 vinculados a muestras isotópicas (tienen lab_id)
  c14_sub <- arid_c14[!is.na(arid_c14$lab_id),
                       c("lab_id", "c14_cal_from", "c14_cal_to")]

  result <- merge(data, c14_sub, by = "lab_id", all.x = TRUE,
                  suffixes = c("", "_c14join"))

  # c14_cal_from/to are already in BCE/CE (normalized during build)
  # Priorizar C14 sobre rango del período (ambos en BCE/CE)
  result$date_from   <- ifelse(!is.na(result$c14_cal_from), result$c14_cal_from, result$period_from)
  result$date_to     <- ifelse(!is.na(result$c14_cal_to),   result$c14_cal_to,   result$period_to)
  result$date_source <- ifelse(!is.na(result$c14_cal_from), "C14", "period")

  result$c14_cal_from <- NULL
  result$c14_cal_to   <- NULL

  if (unit == "BP") {
    result$date_from <- 1950 - result$date_from
    result$date_to   <- 1950 - result$date_to
  }

  result
}
