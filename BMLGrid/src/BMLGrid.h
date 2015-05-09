#ifndef BMLGRID
#define BMLGRID

#include <Rcpp.h>
using namespace Rcpp;

// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins(cpp11)]]

//' Simulator for Biham-Middleton-Levine Traffic Model.
//' 
//' The function that actuall runs the Biham-Middleton-Levine Traffic Model from an initial state by a given number of steps.
//' @param g A BMLGrid class object representing the initial state of the grid.
//' @param numSteps Number of moves/periods.
//' @examples
//' library(BMLGrid)
//' g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))
//' g.out = crunBMLGrid(g, 10000)
//' plot(g.out)
//' @export
// [[Rcpp::export]]
IntegerMatrix crunBMLGrid(IntegerMatrix g, int numSteps);

// Function to locate in grid 'g' all cars of 'color', equivalent to which()
IntegerVector locateColor(const IntegerVector& g, int color);

// Function to move cars of a certain color to their next location if possible
bool moveCars(IntegerMatrix& g, IntegerVector& color, std::function<int(int,int,int)> nextLoc);

// Function to return the location (cyclicly) above the current location
int nextLocUp(int loc, int r, int c);

// Function to return the location (cyclicly) above the current location
int nextLocRight(int loc, int r, int c);
#endif