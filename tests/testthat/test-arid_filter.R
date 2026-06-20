test_that("arid_filter errors without filter arguments", {
  expect_error(arid_filter(), "At least one filter must be provided")
})

test_that("arid_filter returns a data frame", {
  result <- arid_filter(ecozone = "Coast")
  expect_s3_class(result, "data.frame")
})

test_that("arid_filter ecozone keeps only matching rows", {
  result <- arid_filter(ecozone = "Altiplano")
  expect_true(all(result$ecozone == "Altiplano"))
})

test_that("arid_filter accepts multiple values (OR logic)", {
  result <- arid_filter(ecozone = c("Coast", "Lowlands"))
  expect_true(all(result$ecozone %in% c("Coast", "Lowlands")))
  expect_gt(nrow(result), 0)
})

test_that("arid_filter applies AND logic across arguments", {
  result <- arid_filter(ecozone = "Coast", admin_region = "Antofagasta")
  expect_true(all(result$ecozone == "Coast"))
  expect_true(all(result$admin_region == "Antofagasta"))
})

test_that("arid_filter tables argument is respected", {
  result <- arid_filter(tables = "humans", ecozone = "Coast")
  expect_false("source" %in% colnames(result))
})

test_that("arid_filter period_broad filter works", {
  result <- arid_filter(tables = "humans", period_broad = "Formative")
  expect_true(all(result$period_broad == "Formative"))
  expect_gt(nrow(result), 0)
})

test_that("arid_filter period filter works", {
  result <- arid_filter(tables = "humans", period = "Early Archaic")
  expect_true(all(result$period == "Early Archaic"))
})
