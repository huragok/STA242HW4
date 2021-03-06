\name{BMLGrid-package}
\alias{BMLGrid-package}
\alias{BMLGrid}
\docType{package}
\title{
BMLGrid: a package to simulate the Biham-Middleton-Levine Traffic Model.
}
\description{
The BMLGrid provides a constructor function \code{\link{createBMLGrid}} for the S3 class BMLGrid, two S3 methods \code{\link{plot.BMLGrid}} and \code{\link{summary.BMLGrid}}. The workhorse function that simulate the moving process of BML model from a given initial step thoughout a given number of steps are \code{\link{runBMLGrid}}, \code{\link{crunBMLGrid1}} (with key routines replaced by C++ program) and \code{\link{crunBMLGrid2}} (completely rewritten in C++).
}
\details{
\tabular{ll}{
Package: \tab BMLGrid\cr
Type: \tab Package\cr
Version: \tab 1.1\cr
Date: \tab 2015-05-08\cr
License: \tab GPL (>=3)\cr
}

}
\author{
Wenhao Wu <wnhwu@ucdavis.edu>

Maintainer: Wenhao Wu <wnhwu@ucdavis.edu>
}

\references{
\url{http://eeyore.ucdavis.edu/stat242/Homeworks/BML_C.html}
}
\keyword{ package }

