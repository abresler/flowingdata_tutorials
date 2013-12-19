#
# Getting Started with Charts in R
# http://flowingdata.com
#


## Loading and handling data ##

# Vector
c(1,2,3,4,5)
fakedata <- c(1,2,3,4,5)	# Assign to variable
fakedata[1]

# Data frame
morefake <- c("a", "a", "a", "a", "a")
cbind(fakedata, morefake)		# Matrix, values converted to characters
fake.df <- data.frame(cbind(fakedata, morefake))
fake.df$morefake <- as.character(fake.df$morefake)
colnames(fake.df)

# Loading data into data frame
education <- read.csv("2009education.csv", header=TRUE, sep=",", as.is=TRUE)
education[1,]		# First row
education[1:10,]	# First ten rows
education$state		# First columnn
education[,1]		# Also first column
education[1,1]		# First cell

# Sort least to greatest
high.order <- order(education$high)			
education.high <- education[high.order,]

# Sort greatest to least
high.order <- order(education$high, decreasing=TRUE)
education.high <- education[high.order,]


## Basic plotting

plot(fakedata)
plot(education)		# You get an error.
plot(education.high$high)
plot(education$high, education$bs)
plot(education[,2:4])

# Plot types
plot(education.high$high, type="l")	# Line
plot(education.high$high, type="h")	# High-density
plot(education.high$high, type="s")	# Step

# Changing parameters
plot(education.high$high, las=1)
plot(education.high$high, las=1, xlab="States", ylab="Percent", main="At least high school degree or equivalent by state")
plot(education.high$high, las=1, xlab="States", ylab="Percent", main="At least high school degree or equivalent", bty="n", cex=0.5, cex.axis=0.6, pch=19)
plot(education.high$state, education.high$high)


# Additional charts
barplot(education$high)
barplot(education$high, names.arg=education$state, horiz=TRUE, las=1, cex.names=0.5, border=NA)
?barplot

boxplot(education$high)
boxplot(education[,2:4])

plot(1:length(education$high), education$high, type="n")
points(1:length(education$high), education$high)

plot(1:length(education$high), education$high, type="n")
lines(1:length(education$high), education$high)


# Multiple charts
par(mfrow=c(3,3), mar=c(2,5,2,1), las=1, bty="n")
plot(education.high$high)
plot(education$high, education$bs)
plot(education.high$high, type="l")	# Line
plot(education.high$high, type="h")	# High-density
plot(education.high$high, type="s")	# Step
barplot(education$high)
barplot(education$high, names.arg=education$state, horiz=TRUE, las=1, cex.names=0.5, border=NA)
boxplot(education$high)
boxplot(education[,2:4])


