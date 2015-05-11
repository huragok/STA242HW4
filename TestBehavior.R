library('BMLGrid')

r <- 100
c <- 99
p_red <- 0.5
numSteps <- 10000

for (rho in c(0.2, 0.33, 0.38, 0.43, 0.5)) {
  print(paste('rho =', toString(rho)))
  ncars <- c(red = round(r * c * rho * p_red), blue = round(r * c * rho * (1 - p_red)))
  g <- createBMLGrid(r, c, ncars)
  g.out <- crunBMLGrid(g, numSteps)

  filename_end <- paste('TestBehavior_', toString(r), '_', toString(c), '_', toString(numSteps), '_', toString(rho), '_end.pdf', sep="")
  pdf(filename_end)
  plot(g.out)
  dev.off()
}
