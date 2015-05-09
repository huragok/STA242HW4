#include "BMLGrid.h"
using namespace Rcpp;

IntegerMatrix crunBMLGrid(IntegerMatrix g, int numSteps)
{
  int r = g.nrow();
  int c = g.ncol();

  IntegerVector red = locateColor(g, 1);
  IntegerVector blue = locateColor(g, 2);
  
  if (0 == r || 0 == c || 0 == red.size() + blue.size() || numSteps < 0)
  {
    Rcout << "Degenerate BMLGrid object." << std::endl;
    return(g);
  }
  
  bool movable_last = true;
  bool movable;
  for (int step = 0; step < numSteps; step++)
  {
    if (0 == step % 2)
    {
      movable = moveCars(g, blue, nextLocUp);
    }
    else
    {
      movable = moveCars(g, red, nextLocRight);
    }
    if (!movable_last && !movable)
    {
      Rcout << "Grid lock detected at step " << step + 1 << std::endl;
      break;
    }
    else
    {
      movable_last = movable;
    }
  }
  return g;
}

IntegerVector locateColor(const IntegerVector& g, int color)
{
  IntegerVector v = seq(0, g.size() - 1);
  return v[g == color];
}

bool moveCars(IntegerMatrix& g, IntegerVector& color, std::function<int(int,int,int)> nextLoc)
{
  int r = g.nrow();
  int c = g.ncol();
  bool movable_any = false;
  int loc_next;
  IntegerVector::iterator itr;
  for (itr = color.begin(); itr != color.end(); itr++)
  {
    loc_next = nextLoc(*itr, r, c);
    if (g[loc_next] == 0) // The next location is not occupied, move the car
    {
      g[loc_next] = g[*itr];
      g[*itr] = 0;
      *itr = loc_next;
      movable_any = true;
    }
  }
  return movable_any;
}

int nextLocUp(int loc, int r, int c)
{
  return((loc + 1) % r + (loc / r) * r);
}

int nextLocRight(int loc, int r, int c)
{
  return((loc + r) % (r * c));
}
