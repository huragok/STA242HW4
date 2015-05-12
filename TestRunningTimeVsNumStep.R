library(BMLGrid)
library(ggplot2)
library(Rmisc)

len_edge <- 256 # Edge length of the grid
rho <- 0.5 # different rho
numSteps_range <- seq(from = 1000, to = 10000, by = 1000)
nrep <- 20
p_red <- 0.5

running_time <- list()
running_time_c1 <- list()
running_time_c2 <- list()

ncars <- c(red = round(len_edge * len_edge * rho * p_red), blue = round(len_edge * len_edge * rho * (1 - p_red)))
g_list = replicate(nrep, createBMLGrid(len_edge, len_edge, ncars), simplify = FALSE)
for (numSteps in numSteps_range) {
  for (irep in seq_len(nrep)) {
    g <- g_list[[irep]]
    running_time[[idx]] <- system.time(g.out <- runBMLGrid(g, numSteps))
    running_time_c1[[idx]] <- system.time(g.out.c1 <- crunBMLGrid1(g, numSteps))
    running_time_c2[[idx]] <- system.time(g.out.c2 <- crunBMLGrid2(g, numSteps))
    if (any(g.out != g.out.c1) || any(g.out != g.out.c2)) {
      stop("Something is wrong! crunBMLGrid() has different results with runBMLGrid()!")
    }
    print(paste('numSteps =', toString(numSteps), ', repetition', toString(irep), 'completed.'))
    idx <- idx + 1
  }
}

user.time <- do.call(rbind, running_time)[, 1]
user.time.c1 <- do.call(rbind, running_time_c1)[, 1]
user.time.c2 <- do.call(rbind, running_time_c2)[, 1]

n_numSteps <- length(numSteps_range)
user.time <- c(user.time, user.time.c1, user.time.c2)
Routines <- c(rep_len('runBMLGrid()', n_numSteps * nrep), rep_len('crunBMLGrid1()', n_numSteps * nrep), rep_len('crunBMLGrid2()', n_numSteps * nrep))
numSteps <- rep(numSteps_range, 3, each = nrep)

user.time.data <- data.frame(user.time, Routines, numSteps)
user.time.data.summary <- summarySE(user.time.data, measurevar="user.time", groupvars=c("Routines", "numSteps"))

fig.name <- paste('TestRunningTimeVsNumStep_', toString(rho), '.pdf', sep ='')
pdf(fig.name)
theme_set(theme_gray(base_size = 18))
ggplot(user.time.data.summary, aes(x=numSteps, y=user.time, colour=Routines)) + 
    geom_errorbar(aes(ymin=user.time-se, ymax=user.time+se), width=300) +
    geom_line() +
    geom_point() +
    xlab('N') +
    ylab("User time (s)") +
    scale_colour_hue(l=40) +
    #expand_limits(y=2.5) +
    theme(legend.justification=c(0,1),
          legend.position=c(0,1))               # Position legend in bottom right
dev.off()

tab.name <- paste('./Data/TestRunningTimeVsNumStepRaw_', toString(rho), '.csv', sep ='')
write.csv(user.time.data, file = tab.name)

tab.name <- paste('./Data/TestRunningTimeVsNumStepSummary_', toString(rho), '.csv', sep ='')
write.csv(user.time.data.summary, file = tab.name)





