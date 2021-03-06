#ifndef BMLGRID
#define BMLGRID

#include <Rcpp.h>
using namespace Rcpp;

// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins(cpp11)]]

//' Simulator for Biham-Middleton-Levine Traffic Model written in c++.
//' 
//' The function that actually runs the Biham-Middleton-Levine Traffic Model from an initial state by a given number of steps.
//' @param g A BMLGrid class object representing the initial state of the grid.
//' @param numSteps Number of moves/periods.
//' @param warningGridLock bool value indicating whether to prompt to Rcout when grid lock is detected. Default value is false.
//' @examples
//' library(BMLGrid)
//' g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))
//' g.out = crunBMLGrid1(g, 10000)
//' plot(g.out)
//' @export
// [[Rcpp::export]]
IntegerMatrix crunBMLGrid1(IntegerMatrix g, int numSteps, bool warningGridLock = false);

// Function to locate in grid 'g' all cars of 'color', equivalent to which()
IntegerVector locateColor(const IntegerVector& g, int color);

// Function to move cars of a certain color to their next location if possible
// 
// The function that actuall runs the Biham-Middleton-Levine Traffic Model from an initial state by a given number of steps.
// @param g A BMLGrid class object representing the current state of the grid.
// @param loc The location of cars of a certain color that we would like to move.
// @param nextLoc The function to use to get the next location of a car, either nextLocUp() for blue car or nextLocRight() for red car.
// @param buffer_loc_next The vector that holds the intermediate variable of the next locations. Supplied to function to avoid repeated construction/destruction.
// @param buffer_movable The vector that holds the intermediate bool variable indicating whether a car is movable or not.
bool moveCars(IntegerMatrix& g, IntegerVector& loc, std::function<int(int,int,int)> nextLoc, IntegerVector& buffer_loc_next, std::vector<bool>& buffer_movable);

// Function to return the location (cyclicly) above the current location
int nextLocUp(int loc, int r, int c);

// Function to return the location (cyclicly) above the current location
int nextLocRight(int loc, int r, int c);

//' Function to get the vector index of the grid right to the current grid.
//' 
//' c++ implementation of the idx_right() fucntion
//' @param idx Current locations (vector index in the grid) of cars of a certain color.
//' @param r numbers of rows
//' @param c number of columns
// [[Rcpp::export]]
IntegerVector cidx_right(IntegerVector idx, int r, int c);

//' Function to get the vector index of the grid above the current grid.
//' 
//' c++ implementation of the idx_up() fucntion
//' @param idx Current locations (vector index in the grid) of cars of a certain color.
//' @param r numbers of rows
// [[Rcpp::export]]
IntegerVector cidx_up(IntegerVector idx, int r);
#endif