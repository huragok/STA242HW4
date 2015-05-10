library(BMLGrid)
context("Run BMLGrid simulation")

test_that("Illegal inputs", {
  expect_error(runBMLGrid(cbind(c(1.0, 0), c(0, 2.0)), 100), "Wrong grid format: values should be 0, 1, 2 only!")
  expect_error(runBMLGrid(cbind(c(1L, 0L), c(0L, 2L)), -1), 'numSteps must be an integer greater than or equal to 0!')
  expect_error(runBMLGrid(cbind(c(1L, 0L), c(0L, 2L)), 1.5), 'numSteps must be an integer greater than or equal to 0!')
  expect_error(runBMLGrid(cbind(c(1L, 0L), c(0L, 2L)), 'a'), 'numSteps must be an integer greater than or equal to 0!')
})

g <- createBMLGrid(0, 0, c(red = 0, blue = 0))
g.out <- runBMLGrid(g, 0)
test_that("Degenerate cases", {
  expect_equal(nrow(g.out), 0)
  expect_equal(ncol(g.out), 0)
  expect_equal(sum(1 == g.out), 0)
  expect_equal(sum(2 == g.out), 0)
})

g <- createBMLGrid(33, 35, c(red = 8, blue = 17))
g.out <- runBMLGrid(g, 100)
test_that("Preservation of grid size and number of cars", {
  expect_equal(nrow(g.out), 33)
  expect_equal(ncol(g.out), 35)
  expect_equal(sum(1 == g.out), 8)
  expect_equal(sum(2 == g.out), 17)
})