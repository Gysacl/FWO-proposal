library(here)

readLines("fc_VIS_link_obs.txt", n = 1)
VMMlink = read.table(here("fc_VIS_link_obs.txt"), sep = " \", header = TRUE)

