library(BMLGrid)
context("Run BMLGrid simulation in c++")

# Illegal inputs will cause an error directly due to c++ strict typing

g <- createBMLGrid(0, 0, c(red = 0, blue = 0))
g.out <- crunBMLGrid(g, 0)
test_that("Degenerate cases", {
  expect_equal(nrow(g.out), 0)
  expect_equal(ncol(g.out), 0)
  expect_equal(sum(1 == g.out), 0)
  expect_equal(sum(2 == g.out), 0)
})

g1 <- createBMLGrid(100, 99, c(red = 2000, blue = 3000))
g1.out.c <- crunBMLGrid(g1, 1000)
g1.out <- runBMLGrid(g1, 1000)
g2 <- createBMLGrid(100, 99, c(red = 1000, blue = 2000))
g2.out.c <- crunBMLGrid(g2, 10000)
g2.out <- runBMLGrid(g2, 10000)
test_that("Same result as the original runBMLGrid()", {
  expect_equal(all(g1.out == g1.out.c), TRUE)
  expect_equal(all(g2.out == g2.out.c), TRUE)
})