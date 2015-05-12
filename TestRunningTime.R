library(BMLGrid)
library(ggplot2)
library(Rmisc)

len_edge <- 128 # Edge length of the grid
rho_range <- seq(0.1, 0.7, by=0.1) # different rho
numSteps <- 10000
nrep <- 20
p_red <- 0.5

running_time <- list()
running_time_c1 <- list()
running_time_c2 <- list()
idx <- 1

for (rho in rho_range) {
  ncars <- c(red = round(len_edge * len_edge * rho * p_red), blue = round(len_edge * len_edge * rho * (1 - p_red)))
  g_list = replicate(nrep, createBMLGrid(len_edge, len_edge, ncars), simplify = FALSE)
  for (irep in seq_len(nrep)) {
    g <- g_list[[irep]]
    running_time[[idx]] <- system.time(g.out <- runBMLGrid(g, numSteps))
    running_time_c1[[idx]] <- system.time(g.out.c1 <- crunBMLGrid1(g, numSteps))
    running_time_c2[[idx]] <- system.time(g.out.c2 <- crunBMLGrid2(g, numSteps))
    if (any(g.out != g.out.c1) || any(g.out != g.out.c2)) {
      stop("Something is wrong! crunBMLGrid() has different results with runBMLGrid()!")
    }
    print(paste('rho =', toString(rho), ', repetition', toString(irep), 'completed.'))
    idx <- idx + 1
  }
}

user.time <- do.call(rbind, running_time)[, 1]
user.time.c1 <- do.call(rbind, running_time_c1)[, 1]
user.time.c2 <- do.call(rbind, running_time_c2)[, 1]

n_rho <- length(rho_range)
tag <- c(rep_len('R', n_rho * nrep), rep_len('C++v1', n_rho * nrep), rep_len('C++v2', n_rho * nrep))
rho <- rep(rho_range, each = nrep)
user.time <- c(user.time, user.time.c1, user.time.c2)

user.time.data <- data.frame(tag, rho, user.time)
user.time.data.summary <- summarySE(user.time.data, measurevar="user.time", groupvars=c("tag","rho"))

fig.name <- paste('TestRunningTime_', toString(len_edge), '.pdf', sep ='')
pdf(fig.name)
theme_set(theme_gray(base_size = 18))
ggplot(user.time.data.summary, aes(x=rho, y=user.time, colour=tag)) + 
    geom_errorbar(aes(ymin=user.time-se, ymax=user.time+se), width=.03) +
    geom_line() +
    geom_point() +
    xlab(expression(rho)) +
    ylab("User time (s)") +
    scale_colour_hue(name="Routines",    # Legend label, use darker colors
                     breaks=c("R", "C++v1", "C++v2"),
                     labels=c("runBMLGrid()", "crunBMLGrid1()", "crunBMLGrid2()"),
                     l=40) +
    theme(legend.justification=c(1,1),
          legend.position=c(1,1))               # Position legend in bottom right
dev.off()

tab.name <- paste('./Data/TestRunningTimeRaw_', toString(len_edge), '.csv', sep ='')
write.csv(user.time.data, file = tab.name)

tab.name <- paste('./Data/TestRunningTimeSummary_', toString(len_edge), '.csv', sep ='')
write.csv(user.time.data.summary, file = tab.name)
