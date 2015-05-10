#include "BMLGrid.h"
using namespace Rcpp;

IntegerMatrix crunBMLGrid(IntegerMatrix gInput, int numSteps)
{
  IntegerMatrix g = clone(gInput); // Copy the input matrix so that it won't be affected by the undefined behavior of modifying inputs
  int r = g.nrow();
  int c = g.ncol();
  if (0 == r || 0 == c || numSteps < 0)
  {
    //Rcout << "Degenerate BMLGrid object." << std::endl;
    return(g);
  }
  
  IntegerVector red = locateColor(g, 1);
  IntegerVector blue = locateColor(g, 2);
  IntegerVector white = locateColor(g, 0);
  
  int buffer_size = ((red.size() > blue.size()) ? red.size() : blue.size());
  IntegerVector buffer_loc_next(buffer_size);
  std::vector<bool> buffer_movable(buffer_size);
  
  if (red.size() + blue.size() + white.size() != r * c)
  {
    stop("Wrong grid format: values should be 0, 1, 2 only!");
  }
  if (0 == red.size() + blue.size())
  {
    //Rcout << "Degenerate BMLGrid object." << std::endl;
    return(g);
  }
  
  bool movable_last = true;
  bool movable;
  for (int step = 0; step < numSteps; step++)
  {
    if (0 == step % 2)
    {
      movable = moveCars(g, blue, nextLocUp, buffer_loc_next, buffer_movable);
    }
    else
    {
      movable = moveCars(g, red, nextLocRight, buffer_loc_next, buffer_movable);
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

bool moveCars(IntegerMatrix& g, IntegerVector& loc, std::function<int(int,int,int)> nextLoc, IntegerVector& buffer_loc_next, std::vector<bool>& buffer_movable)
{
  int r = g.nrow();
  int c = g.ncol();
  bool movable_any = false;

  IntegerVector::iterator itr_loc, itr_loc_next;
  std::vector<bool>::iterator itr_movable;
  
  // The first loop: compute the next locations and identify the movable cars
  itr_loc_next = buffer_loc_next.begin();
  itr_movable = buffer_movable.begin();
  for (itr_loc = loc.begin(); itr_loc != loc.end(); itr_loc++, itr_loc_next++, itr_movable++)
  {
    *itr_loc_next = nextLoc(*itr_loc, r, c);
    if (g[*itr_loc_next] == 0) // The next location is not occupied, move the car
    {
      *itr_movable = true;
      movable_any = true;
    }
    else
    {
      *itr_movable = false;
    }
  }
  
  // The second loop: move cars according to the result from the first loop
  itr_loc_next = buffer_loc_next.begin();
  itr_movable = buffer_movable.begin();
  for (itr_loc = loc.begin(); itr_loc != loc.end(); itr_loc++, itr_loc_next++, itr_movable++)
  {
    if (*itr_movable) // The next location is not occupied, move the car
    {
      g[*itr_loc_next] = g[*itr_loc];
      g[*itr_loc] = 0;
      *itr_loc = *itr_loc_next;
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
