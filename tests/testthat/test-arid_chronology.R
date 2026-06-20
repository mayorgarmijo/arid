test_that("arid_chronology returns a data frame", {
  result <- arid_chronology(arid_merge("humans"))
  expect_s3_class(result, "data.frame")
})

test_that("arid_chronology adds date_from, date_to, date_source columns", {
  result <- arid_chronology(arid_merge("humans"))
  expect_true(all(c("date_from", "date_to", "date_source") %in% colnames(result)))
})

test_that("arid_chronology date_source is C14 or period", {
  result <- arid_chronology(arid_merge("humans"))
  expect_true(all(result$date_source[!is.na(result$date_source)] %in% c("C14", "period")))
})

test_that("arid_chronology unit BCE returns numeric values", {
  result <- arid_chronology(arid_merge("humans"), unit = "BCE")
  valid <- result$date_from[!is.na(result$date_from)]
  expect_true(is.numeric(valid))
  # Broad sanity check: nothing outside the range of human history
  expect_true(all(valid > -50000 & valid < 10000))
})

test_that("arid_chronology unit BP returns numeric values in expected range", {
  result <- arid_chronology(arid_merge("humans"), unit = "BP")
  valid <- result$date_from[!is.na(result$date_from)]
  # Most archaeological dates in northern Chile: < 12000 BP
  # Modern samples may yield small negative BP (recent CE dates), so no lower bound
  expect_true(all(valid < 15000))
})

test_that("arid_chronology errors without lab_id column", {
  df <- data.frame(site_name = "X", period_from = -1000)
  expect_error(arid_chronology(df), "lab_id")
})
