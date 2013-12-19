####
# Map Grid Tutorial
# URL TBD
####

# Load packages
library(foreign)	# To read .dbf file
library(maps)		# To draw map
library(plyr)		# Data formatting


# Map for 2001
file_loc <- "data/accident2001.dbf"
acc <- read.dbf(file_loc)
map("state", lwd=1, col="#cccccc")		# Default projection is rectangular
points(acc$longitud, acc$latitude, col=NA, bg="#000000", pch=21, cex=0.20)

# Albers projection
map("state", proj="albers", param=c(39,45), lwd=1, col="#cccccc")
points(mapproject(acc$longitud, acc$latitude), col=NA, bg="#00000030", pch=21, cex=0.20)

# Elliptic projection
map("state", proj="elliptic", par=100, lwd=1, col="#cccccc")
points(mapproject(acc$longitud, acc$latitude), col=NA, bg="#00007030", pch=21, cex=0.20)



#
# Show two maps in one view
#

# One row, two columns, with no margin around each
par(mfrow=c(1,2), mar=c(0,0,0,0))
map("state", proj="albers", param=c(39,45), lwd=1, col="#cccccc") 	# First the Albers
points(mapproject(acc$longitud, acc$latitude), col=NA, bg="#00000030", pch=21, cex=0.20)
map("state", proj="elliptic", par=100, lwd=1, col="#cccccc")		# Then the Elliptic
points(mapproject(acc$longitud, acc$latitude), col=NA, bg="#00007030", pch=21, cex=0.20)


# Accidents at 1am
acc.1 <- acc[acc$HOUR == 1,]		# Subset the midnight accidents
map("state", proj="albers", param=c(39,45), lwd=1, col="#cccccc")
points(mapproject(acc.1$longitud, acc.1$latitude), col=NA, bg="#000000", pch=21, cex=0.20)

# Map for every hour
hrs <- unique(acc$HOUR)
length(hrs)
par(mfrow=c(5,6), mar=c(0,0,0,0))
for (i in 1:length(hrs)) {
	
	acc.hr <- acc[acc$HOUR == hrs[i],]
	map("state", proj="albers", param=c(39,45), lwd=1, col="#cccccc")
	points(mapproject(acc.hr$longitud, acc.hr$latitude), col=NA, bg="#000000", pch=21, cex=0.20)
	
	# Label the map
	text(mapproject(-99.843750, 52.130116), paste("Hour:", hrs[i]), cex=1.2)
}


# Map for every hour, sorted
par(mfrow=c(6,4), mar=c(0,0,0,0))
for (hr in 0:24) {
	
	if (hr == 0) {
		acc.hr <- acc[acc$HOUR == hr | acc$HOUR == 24,]
	} else if (hr == 24) {
		next
	} else {
		acc.hr <- acc[acc$HOUR == hr,]
	}
	
	map("state", proj="albers", param=c(39,45), lwd=0.3, col="#cccccc")
	points(mapproject(acc.hr$longitud, acc.hr$latitude), col=NA, bg="#000070", pch=21, cex=0.15)
	
	# Label the map
	text(mapproject(-99, 52), paste("Hour:", hr), cex=1)
}


# Map for every road function
fncs <- unique(acc$ROAD_FNC)
fnc_names <- read.table("data/road-fnc-vals.csv", as.is=TRUE, header=TRUE, sep=",")
length(fncs)
par(mfrow=c(4,4), mar=c(0,0,0,0))
for (i in 1:length(fncs)) {
	
	acc.fnc <- acc[acc$ROAD_FNC == fncs[i],]
	map("state", proj="albers", param=c(39,45), lwd=1, col="#f0f0f0")
	points(mapproject(acc.fnc$longitud, acc.fnc$latitude), col=NA, bg="#9c6910", pch=21, cex=0.15)
	
	# Label
	fnc_name <- fnc_names[fnc_names$code == fncs[i],]
	text(mapproject(-99, 55), fnc_name$name, cex=1)
}


#
# Choropleth state map
#

statepop <- read.csv("data/states.csv")
statecnts <- count(acc$STATE)
states <- merge(statepop, statecnts, by.x="code", by.y="x")
states$accrate <- states$freq / (states$pop2012/1000000)

# Helper function to get color (annual), based on actions per million population
getColor <- function(x) {
	
	if (x > 200) {
		col <- "#13373e"
		
	} else if (x > 150) {
		col <- "#246571"
	} else if (x > 100) {
		col <- "#308898"
	} else {
		col <- "#7bc7d5"
	}
	
	return(col)
}
statecols <- sapply(states$accrate, FUN=getColor)
map("state", regions=states$name, proj="albers", param=c(39,45), fill=TRUE, col=statecols, border=NA, resolution=0)

#
# Map for each month
#

# Helper function to get color, based on accidents per million population in month
getColor.m <- function(x) {
	
	if (x > 20) {
		col <- "#13373e"
	} else if (x > 15) {
		col <- "#246571"
	} else if (x > 10) {
		col <- "#308898"
	} else {
		col <- "#7bc7d5"
	}
	
	return(col)
}

# Draw the maps
par(mfrow=c(4,4), mar=c(0,0,0,0))
months <- 1:12
monthnames <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
for (m in months) {
	 
	acc.m <- acc[acc$MONTH == m,]
	statecnts.m <- count(acc.m$STATE)
	states.m <- merge(statepop, statecnts.m, by.x="code", by.y="x")
	states.m$accrate <- states.m$freq / (states.m$pop2012/1000000)
	
	statecols.m <- sapply(states.m$accrate, FUN=getColor.m)
	map("state", regions=states.m$name, proj="albers", param=c(39,45), fill=TRUE, col=statecols.m, border=NA, resolution=0)
	
	text(mapproject(-99, 55), monthnames[m], cex=1)
}

# Make-shift legend
plot(0, 0, type="n", axes=FALSE, xlim=c(0,30), ylim=c(0,2))
rect(c(5,10,15,20), c(1,1,1,1), c(10,15,20,25), c(1.25,1.25,1.25,1.25), col=sapply(c(6,11,16,21), getColor.m), border="white", lwd=0.4)
text(15, 1.35, "Accidents per mil. pop.")
text(c(10,15,20), c(0.9,0.9,0.9), c(10,15,20), cex=0.8)	# Tick labels




