# This file was generated by Rcpp::compileAttributes
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' Simulator for Biham-Middleton-Levine Traffic Model written in c++.
#' 
#' The function that actually runs the Biham-Middleton-Levine Traffic Model from an initial state by a given number of steps.
#' @param g A BMLGrid class object representing the initial state of the grid.
#' @param numSteps Number of moves/periods.
#' @param warningGridLock bool value indicating whether to prompt to Rcout when grid lock is detected. Default value is false.
#' @examples
#' library(BMLGrid)
#' g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))
#' g.out = crunBMLGrid1(g, 10000)
#' plot(g.out)
#' @export
crunBMLGrid1 <- function(g, numSteps, warningGridLock = FALSE) {
    .Call('BMLGrid_crunBMLGrid1', PACKAGE = 'BMLGrid', g, numSteps, warningGridLock)
}

#' Function to get the vector index of the grid right to the current grid.
#' 
#' c++ implementation of the idx_right() fucntion
#' @param idx Current locations (vector index in the grid) of cars of a certain color.
#' @param r numbers of rows
#' @param c number of columns
cidx_right <- function(idx, r, c) {
    .Call('BMLGrid_cidx_right', PACKAGE = 'BMLGrid', idx, r, c)
}

#' Function to get the vector index of the grid above the current grid.
#' 
#' c++ implementation of the idx_up() fucntion
#' @param idx Current locations (vector index in the grid) of cars of a certain color.
#' @param r numbers of rows
cidx_up <- function(idx, r) {
    .Call('BMLGrid_cidx_up', PACKAGE = 'BMLGrid', idx, r)
}

