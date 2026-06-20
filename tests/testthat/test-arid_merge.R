test_that("arid_merge returns a data frame", {
  result <- arid_merge("humans")
  expect_s3_class(result, "data.frame")
  expect_gt(nrow(result), 0)
})

test_that("arid_merge single table has no source column", {
  result <- arid_merge("humans")
  expect_false("source" %in% colnames(result))
})

test_that("arid_merge multiple tables adds source column", {
  result <- arid_merge(c("humans", "animals"))
  expect_true("source" %in% colnames(result))
  expect_setequal(unique(result$source), c("humans", "animals"))
})

test_that("arid_merge all tables combines all three", {
  result <- arid_merge()
  expect_setequal(unique(result$source), c("humans", "animals", "plants"))
})

test_that("arid_merge data is already in long format with tissue_type column", {
  result <- arid_merge("humans")
  expect_true("tissue_type" %in% colnames(result))
  expect_true(all(result$tissue_type %in% c("organic", "carbonate")))
  # both tissue types are present
  expect_true("organic" %in% result$tissue_type)
  expect_true("carbonate" %in% result$tissue_type)
})

test_that("arid_merge rejects invalid table names", {
  expect_error(arid_merge("fungi"))
})
