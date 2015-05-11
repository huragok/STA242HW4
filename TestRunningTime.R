library(BMLGrid)

len_edge_range <- c(128, 256, 512, 1024) # Edge length of the grid
rho_range <- seq(0.1, 0.7, by=0.1) # different rho
col_range <- c('blue', 'red', 'black', 'darkgreen')
numSteps <- 10000
nrep <- 10
p_red <- 0.5

running_time <- list()
running_time_c <- list()
idx <- 1
for (len_edge in len_edge_range) {
  for (rho in rho_range) {
    ncars <- c(red = round(len_edge * len_edge * rho * p_red), blue = round(len_edge * len_edge * rho * (1 - p_red)))
    g_list = replicate(nrep, createBMLGrid(len_edge, len_edge, ncars), simplify = FALSE)
    running_time[[idx]] <- system.time(g.out.list <- sapply(g_list , runBMLGrid, numSteps)) / nrep
    running_time_c[[idx]] <- system.time(g.out.list.c <- sapply(g_list , crunBMLGrid, numSteps)) / nrep
    idx <- idx + 1
    if (any(g.out.list != g.out.list.c)) {
      stop("Something is wrong! crunBMLGrid() has different results with runBMLGrid()!")
    }
    print(paste('Edge length =', toString(len_edge), 'rho =', toString(rho), 'completed.'))
  }
}

user_time <- do.call(rbind, running_time)[, 1]
user_time_c <- do.call(rbind, running_time_c)[, 1]
pdf('TestRunningTime.pdf')
plot(c(0, 0.8), c(0, 150), type = 'n',  xlab="rho", ylab="User Time (s)")

for (i_len_edge in seq_along(len_edge_range)) {
  lines(rho_range, user_time[((i_len_edge-1) * length(rho_range) + 1) : (i_len_edge * length(rho_range))], type="o",  col=col_range[i_len_edge], lwd=2.5, lty = 1, pch = 1, cex=1)
}
for (i_len_edge in seq_along(len_edge_range)) {
  lines(rho_range, user_time_c[((i_len_edge-1) * length(rho_range) + 1) : (i_len_edge * length(rho_range))], type="o",  col=col_range[i_len_edge], lwd=2.5, lty = 2, pch = 2, cex=1)
}
legend(0.55, 140, legend = c(paste(rep_len('R, l =', length(len_edge_range)), len_edge_range), paste(rep_len('C++, l =', length(len_edge_range)), len_edge_range)), lty=c(rep_len(1, length(len_edge_range)), rep_len(2, length(len_edge_range))), lwd=rep_len(2.5, 2 * length(len_edge_range)), col= c(col_range, col_range))
dev.off()

speedup <- user_time / user_time_c
pdf('SpeedUp.pdf')
plot(c(0, 0.8), c(0, 10), type = 'n',  xlab="rho", ylab="Speed Up")
for (i_len_edge in seq_along(len_edge_range)) {
  lines(rho_range, speedup[((i_len_edge-1) * length(rho_range) + 1) : (i_len_edge * length(rho_range))], type="o",  col=col_range[i_len_edge], lwd=2.5, lty = 1, pch = 1, cex=1)
}
legend(0.6, 2, legend = paste(rep_len('l =', length(len_edge_range)), len_edge_range), lty=rep_len(1, length(len_edge_range)), lwd=rep_len(2.5, length(len_edge_range)), col=col_range)
dev.off()
