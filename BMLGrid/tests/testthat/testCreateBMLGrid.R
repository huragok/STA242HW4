library(BMLGrid)
context("Create a BMLGrid object.")

test_that("Illegal inputs", {
  expect_error(createBMLGrid(-1, 1, c(red = 2, blue = 2)))
  expect_error(createBMLGrid(1, 1, c(red = -1, blue = 2)))
  expect_error(createBMLGrid(1, 1, c(red = 2, blue = 2)))
})

test_that("Grid size and number of cars", {
  expect_equal(nrow(createBMLGrid(33, 35, c(red = 8, blue = 17))), 33)
  expect_equal(ncol(createBMLGrid(33, 35, c(red = 8, blue = 17))), 35)
  expect_equal(sum(1 == createBMLGrid(33, 35, c(red = 8, blue = 17))), 8)
  expect_equal(sum(2 == createBMLGrid(33, 35, c(red = 8, blue = 17))), 17)
  expect_match(typeof(createBMLGrid(33, 35, c(red = 8, blue = 17))), "integer")
})