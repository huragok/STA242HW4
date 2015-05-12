library(ggplot2)

len.edge.range <-c(128, 256, 512, 1024) # Edge length of the grid
rho.range <- seq(0.1, 0.7, by=0.1) # different rho
numSteps <- 10000

speedup <- list()
idx <- 1
n.rho <- length(rho.range)
n.len <- length(len.edge.range)
for (len.edge in len.edge.range) {
  tab.name <- paste('./Data/TestRunningTimeSummary_', toString(len.edge), '.csv', sep ='')
  user.time <- read.csv(tab.name)
  speedup[[idx]] <- c(user.time$user.time[(2 * n.rho + 1) : (3 * n.rho)] / user.time$user.time[1 : n.rho], user.time$user.time[(2 * n.rho + 1) : (3 * n.rho)] / user.time$user.time[(n.rho + 1) : (2 * n.rho)])
  idx <- idx + 1
}

speedup <- unlist(speedup)
Routines <- rep(c(rep("crunBMLGrid1()", n.rho), rep("crunBMLGrid2()", n.rho)), n.len)
rho <- rep(rho.range, 2 * n.len)
len <- rep(len.edge.range, each = 2 * n.rho)
len <- sapply(len, toString)

speedup.average <- data.frame(len, rho, speedup, Routines)
pdf('SpeedUp.pdf')
theme_set(theme_gray(base_size = 18))
ggplot(speedup.average, aes(x=rho, y=speedup, colour=len, linetype=Routines)) + 
    geom_line() +
    geom_point() +
    xlab(expression(rho)) +
    ylab("Speedup over runBMLGrid()") +
    expand_limits(y=0) +
    scale_colour_hue(name="Edge Length",    # Legend label, use darker colors
                     l=40) + 
    theme(legend.justification=c(1,1),
          legend.position=c(1,1))               # Position legend in bottom right
dev.off()
