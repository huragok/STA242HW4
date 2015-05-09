#include "BMLGrid.h"
using namespace Rcpp;

IntegerMatrix crunBMLGrid(IntegerMatrix g, int numSteps)
{
  int r = g.nrow();
  int c = g.ncol();

  IntegerVector red = locateColor(g, 1);
  IntegerVector blue = locateColor(g, 2);
  IntegerVector buffer_loc_next_red(red.size());
  IntegerVector buffer_loc_next_blue(blue.size());
  std::vector<bool> buffer_movable_red(red.size());
  std::vector<bool> buffer_movable_blue(blue.size());
  
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
      movable = moveCars(g, blue, nextLocUp, buffer_loc_next_blue, buffer_movable_blue);
    }
    else
    {
      movable = moveCars(g, red, nextLocRight, buffer_loc_next_red, buffer_movable_red);
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
  for (itr_loc = loc.begin(); itr_loc != loc.end(); itr_loc++)
  {
    *itr_loc_next = nextLoc(*itr_loc, r, c);
    if (g[*itr_loc_next] == 0) // The next location is not occupied, move the car
    {
      *itr_movable = true;
      movable_any = true;
      //Rcout << "FUCK" << std::endl;
    }
    else
    {
      *itr_movable = false;
    }
    itr_loc_next++;
    itr_movable++;
  }
  
  // The second loop: move cars according to the result from the first loop
  itr_loc_next = buffer_loc_next.begin();
  itr_movable = buffer_movable.begin();
  for (itr_loc = loc.begin(); itr_loc != loc.end(); itr_loc++)
  {
    if (*itr_movable) // The next location is not occupied, move the car
    {
      g[*itr_loc_next] = g[*itr_loc];
      g[*itr_loc] = 0;
      *itr_loc = *itr_loc_next;
      //Rcout << "yooo~" << std::endl;
    }
    itr_loc_next++;
    itr_movable++;
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
