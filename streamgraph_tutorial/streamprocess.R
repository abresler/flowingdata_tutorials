# Frake data frame
numCols <- 20
numLayers <- 5
fakeData <- data.frame(matrix(ncol=numCols, nrow=numLayers))
for (i in 1:numLayers) {
	heights <- 1 / runif(numCols, 0, 1)
	newRow <- heights * exp(-heights * heights)
	fakeData[i,] <- newRow
}


# Color palette
nColors <- 10
pal <- colorRampPalette(c("#0f7fb4", "white"))
colors <- pal(nColors)


# Regular area chart, zero offset, one layer
plot(1:length(fakeData[1,]), 1:length(fakeData[1,]), ylim=c(0, max(fakeData[1,])), xlab=NA, ylab=NA, type="n")
polygon(c(1:length(fakeData[1,]), length(fakeData[1,]):1), c(fakeData[1,], rep(0, length(fakeData[1,]))), col="#cccccc", border="white")


# Stacked area, zero offset
totals <- colSums(fakeData)
plot(1:length(fakeData[1,]), 1:length(fakeData[1,]), type="n", ylim=c(0, max(totals)), xlab=NA, ylab=NA)
yOffset <- rep(0, length(fakeData[1,]))
for (i in 1:length(fakeData[,1])) {
	
	# Wireframe debugging	
	# lines(1:length(fakeData[i,]), fakeData[i,] + yOffset)
	
	polygon(c(1:length(fakeData[i,]), length(fakeData[i,]):1), c(fakeData[i,] + yOffset, rev(yOffset)), col="#cccccc", border="white")
	
	yOffset <- yOffset + fakeData[i,]

}


# Stacked area, centered offset (ThemeRiver)
totals <- colSums(fakeData)
yOffset <- -totals / 2
maxSum <- max(totals)
plot(1:length(fakeData[1,]), 1:length(fakeData[1,]), type="n", ylim=c(-maxSum/2, maxSum/2), xlab=NA, ylab=NA)
for (i in 1:length(fakeData[,1])) {
	polygon(c(1:length(fakeData[1,]), length(fakeData[1,]):1), c(fakeData[i,] + yOffset, rev(yOffset)), col="#cccccc", border="white")
	yOffset <- yOffset + fakeData[i,]
}



# Reduced wiggle, no sorting.
n <- length(fakeData[,1])
i <- 1:length(fakeData[,1])
parts <- (n - i + 1) * fakeData
theSums <- colSums(parts)
totals <- colSums(fakeData)
maxSum <- max(totals)

yOffset <- -theSums / (n + 1)
yLower <- min(yOffset)
yUpper <- max(yOffset + totals)

plot(1:length(fakeData[1,]), 1:length(fakeData[1,]), type="n", ylim=c(yLower, yUpper), xlab=NA, ylab=NA)
for (i in 1:length(fakeData[,1])) {
	polygon(c(1:length(fakeData[1,]), length(fakeData[1,]):1), c(fakeData[i,] + yOffset, rev(yOffset)), col="#cccccc", border="white")
	yOffset <- yOffset + fakeData[i,]

}



# Reduced wiggle, sorted by layer weight.
sortedData <- fakeData[1,]
weights <- rowSums(fakeData)
topWeight <- weights[1]
bottomWeight <- weights[1]

for (i in 2:length(fakeData[,1])) {
	
	if (topWeight > bottomWeight) {
		sortedData <- rbind(sortedData, fakeData[i,])
		topWeight <- topWeight + weights[i]
	} else {
		sortedData <- rbind(fakeData[i,], sortedData)
		bottomWeight <- bottomWeight + weights[i]
	}
}

n <- length(sortedData[,1])
i <- 1:length(sortedData[,1])
parts <- (n - i + 1) * sortedData
theSums <- colSums(parts)
totals <- colSums(sortedData)
yOffset <- -theSums / (n + 1)
yLower <- min(yOffset)
yUpper <- max(yOffset + totals)

maxRow <- max(rowSums(sortedData))
minRow <- min(rowSums(sortedData))
rowSpan <- maxRow - minRow

# Make the graph.
plot(1:10, 1:10, type="n", xlim=c(1, numcols), ylim=c(yLower, yUpper), xlab=NA, ylab=NA)
for (i in 1:length(sortedData[,1])) {
	
	colindex <- floor( (nColors-2) * ( (maxRow - sum(sortedData[i,])) / rowSpan ) ) + 1
	
	# Wireframe debugging
	# lines(1:length(sortedData[i,]), sortedData[i,] + yOffset)
	
	polygon(c(1:length(sortedData[i,]), length(sortedData[i,]):1), c(sortedData[i,] + yOffset, rev(yOffset)), col=colors[colindex], border="white", lwd=0.2)
	yOffset <- yOffset + sortedData[i,]

}




# Reduced wiggle, sorted, smoothed.


# Sort
sortedData <- fakeData[1,]
weights <- rowSums(fakeData)
topWeight <- weights[1]
bottomWeight <- weights[1]

if (length(fakeData[,1]) > 1) {
	for (i in 2:length(fakeData[,1])) {
	
		if (topWeight > bottomWeight) {
			sortedData <- rbind(sortedData, fakeData[i,])
			topWeight <- topWeight + weights[i]
		} else {
			sortedData <- rbind(fakeData[i,], sortedData)
			bottomWeight <- bottomWeight + weights[i]
		}
	}
}



# Convert sorted data to splines.

# Helper function to change negative valus to zero
zeroNegatives <- function(x) { 
	if (x < 0) { return(0) }
	else { return(x) }
}

# Initialize smoothed data
firstRow <- spline(1:length(sortedData[1,]), sortedData[1,], 200)$y
firstRow <- sapply(firstRow, zeroNegatives)

smoothData <- data.frame( rbind(firstRow, rep(0, length(firstRow))) )
smoothData <- smoothData[1,]

if (length(sortedData[,1]) > 1) {
	for (i in 2:length(sortedData[,1])) {
	
		splinerow <- spline(1:length(sortedData[i,]), sortedData[i,], 200)$y
		splinerow <- sapply(splinerow, zeroNegatives)
		smoothData <- rbind(smoothData, splinerow)
	}
}

# Optimize vertical offset
n <- length(smoothData[,1])
i <- 1:length(smoothData[,1])
parts <- (n - i + 1) * smoothData
theSums <- colSums(parts)
yOffset <- -theSums / (n + 1)

# Totals at each index for axis upper and lower bounds
totals <- colSums(smoothData)
yLower <- min(yOffset)
yUpper <- max(yOffset + totals)

# Max, min, and span of weights for each layer
maxRow <- max(rowSums(smoothData))
minRow <- min(rowSums(smoothData))
rowSpan <- if ( (maxRow - minRow) > 0 ) { maxRow - minRow } else { 1 }

# Make the graph.
plot(1:10, 1:10, type="n", xlim=c(1, length(smoothData[1,])), ylim=c(yLower, yUpper), xlab=NA, ylab=NA)
for (i in 1:length(smoothData[,1])) {
	colindex <- floor( (nColors-2) * ( (maxRow - sum(smoothData[i,])) / rowSpan ) ) + 1
	
	# Wireframe debugging	
	# points(1:length(smoothData[i,]), smoothData[i,] + yOffset, col=i)
	# lines(1:length(smoothData[i,]), smoothData[i,] + yOffset, col=i)
	
	polygon(c(1:length(smoothData[i,]), length(smoothData[i,]):1), c(smoothData[i,] + yOffset, rev(yOffset)), col=colors[colindex], border="#ffffff", lwd=0.2)
	
	yOffset <- yOffset + smoothData[i,]
}





