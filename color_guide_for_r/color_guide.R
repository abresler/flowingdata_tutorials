#### Build color grid for intro
xcoords <- c()
ycoords <- c()
rownum <- 1
for (i in 1:length(colors())) {
	colnum <- i %% 40
	if (colnum == 0) {
		rownum <- rownum + 1
	}
	xcoords <- c(xcoords, colnum)
	ycoords <- c(ycoords, rownum)
}
symbols(xcoords, ycoords, squares=rep(1, length(colors())), inches=FALSE, bg=colors(), fg="#ffffff", lwd=0.5)


### Color by data

par(mfrow=c(1,5))

# Playing with the col argument
fakedata <- c(5, 4, 3, 2, 1)
pie(fakedata, clockwise=TRUE, labels=fakedata)
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white")
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col="black")
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=c("blue", "black"))
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=c("black", "dark gray", "gray", "light gray", "white"))


### Color Schemes

# Available colors
colors()
hsv()
rgb()

colorRampPalette()
palette()


# Number of data points
numdata <- length(fakedata)

par(mfrow=c(1,4))

# Gray color scheme
grays <- gray(0:numdata / numdata)
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=grays)

# Heat scheme from yellow to red
heatcols <- heat.colors(length(fakedata))
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=heatcols)

# All the colors of the rainbow
rainbowcols <- rainbow(numdata)
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=rainbowcols)

# Topographic color scheme
topocols <- topo.colors(numdata)
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=topocols)


## Introducing ColorBrewer

# Load RColorBrewer package
library(RColorBrewer)

# Blue color scheme from ColorBrewer
blues <- brewer.pal(numdata, "Blues")
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=blues)

# Reverse the previous blue color scheme
blues.rev <- rev(blues)
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=blues.rev)


### Picking Your Own Colors

# Use a color ramp
pal <- colorRampPalette(c("light gray", "red"))
colors <- pal(numdata)
pie(fakedata, clockwise=TRUE, labels=fakedata, border="white", col=colors)

# Some more fake data and default colors
morefakedata <- c(5, 3, 2, 6, 8, 1, 3)
pie(morefakedata, clockwise=TRUE, labels=morefakedata)

# Build color ramp and palette
fakemax <- max(morefakedata)
pal2 <- colorRampPalette(c("#f2f2f2", "#821122"))
numshades <- 20
colors2 <- pal2(numshades)

# Make chart with color ramp
morecolors <- c()
for (i in 1:length(morefakedata)) {
	colindex <- round((morefakedata[i] / fakemax) * numshades)
	morecolors <- c(morecolors, colors2[colindex])
}
pie(morefakedata, clockwise=TRUE, labels=morefakedata, border="white", col=morecolors)





