pkgname <- "BMLGrid"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('BMLGrid')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("createBMLGrid")
### * createBMLGrid

flush(stderr()); flush(stdout())

### Name: createBMLGrid
### Title: Constructor for S3 class BMLGrid
### Aliases: createBMLGrid

### ** Examples

library(BMLGrid)
g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))



cleanEx()
nameEx("crunBMLGrid")
### * crunBMLGrid

flush(stderr()); flush(stdout())

### Name: crunBMLGrid
### Title: Simulator for Biham-Middleton-Levine Traffic Model written in
###   c++.
### Aliases: crunBMLGrid

### ** Examples

library(BMLGrid)
g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))
g.out = crunBMLGrid(g, 10000)
plot(g.out)



cleanEx()
nameEx("plot.BMLGrid")
### * plot.BMLGrid

flush(stderr()); flush(stdout())

### Name: plot.BMLGrid
### Title: plot method for BMLGrid class object
### Aliases: plot.BMLGrid

### ** Examples

library(BMLGrid)
g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))
plot(g)



cleanEx()
nameEx("runBMLGrid")
### * runBMLGrid

flush(stderr()); flush(stdout())

### Name: runBMLGrid
### Title: Simulator for Biham-Middleton-Levine Traffic Model.
### Aliases: runBMLGrid

### ** Examples

library(BMLGrid)
g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))
g.out = runBMLGrid(g, numSteps = 10000)
plot(g.out)
g.out = runBMLGrid(g, numSteps = 50, movieName = 'movieBMLGrid', recordSpeed = TRUE)
plot(g.out$g)
summary(g.out$v.blue)
summary(g.out$v.red)



cleanEx()
nameEx("summary.BMLGrid")
### * summary.BMLGrid

flush(stderr()); flush(stdout())

### Name: summary.BMLGrid
### Title: summary method for BMLGrid class object
### Aliases: summary.BMLGrid

### ** Examples

library(BMLGrid)
g = createBMLGrid(r = 100, c = 99, ncars = c(red = 100, blue = 100))
summary(g)



### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
