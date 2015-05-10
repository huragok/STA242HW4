library(BMLGrid)
context("Create a BMLGrid object")

test_that("Illegal inputs", {
  expect_error(createBMLGrid(-1, 1, c(red = 2, blue = 2)))
  expect_error(createBMLGrid(1, 1, c(red = -1, blue = 2)))
  expect_error(createBMLGrid(1, 1, c(red = 2, blue = 2)))
})

g <- createBMLGrid(33, 35, c(red = 8, blue = 17))
test_that("Grid size and number of cars", {
  expect_equal(nrow(g), 33)
  expect_equal(ncol(g), 35)
  expect_equal(sum(1 == g), 8)
  expect_equal(sum(2 == g), 17)
  expect_match(typeof(createBMLGrid(33, 35, c(red = 8, blue = 17))), "integer")
})