source("sankey.R")

budget <- read.table("budget2013.csv", header=TRUE, sep=",", as.is=TRUE)
sankey(budget)