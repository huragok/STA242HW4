#include <Rcpp.h>
using namespace Rcpp;

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
NumericMatrix crunBMLGrid(NumericMatrix g, int numSteps) {
  int r = g.nrow();
  int c = g.ncol();
  Rcout << r << c;
  return g;
}
