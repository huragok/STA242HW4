library(BMLGrid)
context("Run BMLGrid simulation where key routines are rewritten in C++")

test_that("Illegal inputs", {
  expect_error(crunBMLGrid2(cbind(c(1.0, 0), c(0, 2.0)), 100), "Wrong grid format: values should be 0, 1, 2 only!")
  expect_error(crunBMLGrid2(cbind(c(1L, 0L), c(0L, 2L)), -1), 'numSteps must be an integer greater than or equal to 0!')
  expect_error(crunBMLGrid2(cbind(c(1L, 0L), c(0L, 2L)), 1.5), 'numSteps must be an integer greater than or equal to 0!')
  expect_error(crunBMLGrid2(cbind(c(1L, 0L), c(0L, 2L)), 'a'), 'numSteps must be an integer greater than or equal to 0!')
})

g <- createBMLGrid(0, 0, c(red = 0, blue = 0))
g.out <- crunBMLGrid2(g, 0)
test_that("Degenerate cases", {
  expect_equal(nrow(g.out), 0)
  expect_equal(ncol(g.out), 0)
  expect_equal(sum(1 == g.out), 0)
  expect_equal(sum(2 == g.out), 0)
})

g <- createBMLGrid(33, 35, c(red = 8, blue = 17))
g.out <- crunBMLGrid2(g, 100)
test_that("Preservation of grid size and number of cars", {
  expect_equal(nrow(g.out), 33)
  expect_equal(ncol(g.out), 35)
  expect_equal(sum(1 == g.out), 8)
  expect_equal(sum(2 == g.out), 17)
})

nrep <- 5
numSteps <- 10000
g1.list <- replicate(nrep, createBMLGrid(100, 99, c(red = 1980, blue = 1980)), simplify = FALSE) # The critical case
g1.list.out.c <- sapply(g1.list, crunBMLGrid2, numSteps)
g1.list.out <- sapply(g1.list, runBMLGrid, numSteps)

g2.list <- replicate(nrep, createBMLGrid(100, 99, c(red = 1000, blue = 2000)), simplify = FALSE) # The ordered case
g2.list.out.c <- sapply(g2.list, crunBMLGrid2, numSteps)
g2.list.out <- sapply(g2.list, runBMLGrid, numSteps)

g3.list <- replicate(nrep, createBMLGrid(100, 99, c(red = 3000, blue = 2500)), simplify = FALSE) # The grid lock case
g3.list.out.c <- sapply(g3.list, crunBMLGrid2, numSteps)
g3.list.out <- sapply(g3.list, runBMLGrid, numSteps)

g4.list <- replicate(nrep, createBMLGrid(100, 99, c(red = 0, blue = 2500)), simplify = FALSE) # No red cars and blue cars move smoothly
g4.list.out.c <- sapply(g4.list, crunBMLGrid2, numSteps)
g4.list.out <- sapply(g4.list, runBMLGrid, numSteps)

g5.list <- replicate(nrep, createBMLGrid(100, 99, c(red = 8000, blue = 0)), simplify = FALSE) # No blue cars and red cars move smoothly
g5.list.out.c <- sapply(g5.list, crunBMLGrid2, numSteps)
g5.list.out <- sapply(g5.list, runBMLGrid, numSteps)

g6.list <- replicate(nrep, createBMLGrid(100, 99, c(red = 4950, blue = 4950)), simplify = FALSE) # Total grid lock
g6.list.out.c <- sapply(g6.list, crunBMLGrid2, numSteps)
g6.list.out <- sapply(g6.list, runBMLGrid, numSteps)

test_that("Same result as the original runBMLGrid()", {
  expect_equal(all(g1.list.out == g1.list.out.c), TRUE)
  expect_equal(all(g2.list.out == g2.list.out.c), TRUE)
  expect_equal(all(g3.list.out == g3.list.out.c), TRUE)
  expect_equal(all(g4.list.out == g4.list.out.c), TRUE)
  expect_equal(all(g5.list.out == g5.list.out.c), TRUE)
  expect_equal(all(g6.list.out == g6.list.out.c), TRUE)
})
