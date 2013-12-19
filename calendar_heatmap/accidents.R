#http://flowingdata.com/2012/03/15/calendar-heatmaps-to-visualize-time-series-data/
setwd("~/Desktop/Github/flowingdata_tutorials/calendar_heatmap")
# Sample usage for calendarFlow()
source("calendarCustom.R")

# Load data from .dbf file and aggregate by day
library(foreign)
accidents <- read.dbf("FARS2010/accident.dbf")
accidents.agg <- aggregate(VE_TOTAL ~ YEAR + MONTH + DAY, data=accidents, sum)

# Prepare for calendarFlow()
dates <- paste(accidents.agg$YEAR, accidents.agg$MONTH, accidents.agg$DAY, sep="-")
vehicles <- accidents.agg$VE_TOTAL

# Make calendar
calendarFlow(dates, vehicles, palette="bluegray",main='Accidents')

# Make multiple calendars
par(mfrow = c(5,2), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0))
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="bluegray")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="red")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="red")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="blue")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="green")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="bluegray")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="bluegray")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="red")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="red")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="blue")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="green")
calendarFlow(dates, rnorm(length(dates), mean = 10, sd = 1), palette="bluegray")

