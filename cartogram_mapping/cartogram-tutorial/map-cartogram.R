# Load data.
themat <- read.csv("cnt_matrix.txt")
numcols <- length(themat[1,])
numrows <- length(themat[,1])
meandensity <- sum(themat) / (numcols*numrows)

# Replace zeros with mean density.
nonzero <- function(x) { if (x == 0) { return(meandensity); } else { return(x); } }
themat2 <- apply(themat, FUN="nonzero", MARGIN=c(1,2))

# Save new matrix.
write.table(themat2, file="./cart/ufo-sea.txt", quote=FALSE, sep=" ", row.names=FALSE, col.names=FALSE)

# In terminal, run the following:
# ./cart 256 104 ufo-sea.txt ufo_out.dat

# Sanity check to see if cart worked.
ufo.cart <- read.table("./cart/ufo_out.dat", sep=" ", header=FALSE)
plot(0, 0, xlim=c(0,256), ylim=c(0, 104), type="n")
points(ufo.cart$V1, 104-ufo.cart$V2, col="gray", cex=0.2, pch=20)


# Start and end latitude/longitude coordinates from previous tutorial.
lat_NW <- 54.162434
lng_NW <- -135.351563
lat_SE <- 23.725012
lng_SE <- -61.347656


# Get state boundary lines in latitude and longitude.
library(maps)
m <- map("state")
x <- (m$x - lng_NW) / (lng_SE - lng_NW) * numcols
y <- (m$y - lat_NW) / (lat_SE - lat_NW) * numrows
xy.df <- data.frame(x, y)
write.table(xy.df, "./cart/boundaries.dat", quote=FALSE, sep=" ", row.names=FALSE, col.names=FALSE)

# Map regular boundary lines.
plot(x, numrows-y, type="n", xlim=c(0,256), ylim=c(0, 104))
lines(x, numrows-y, lwd=0.2)


# In terminal, run the following:
# gcc -O -o interp interp.c
# cat boundaries.dat | ./interp 256 104 ufo_out.dat > boundaries_cart.dat

# Map cartogrammed boundary lines.
xy.cart <- read.csv("./cart/boundaries_cart.dat", header=FALSE, sep=" ")
plot(0, 0, xlim=c(0,256), ylim=c(0, 104), type="n")
lines(xy.cart$V1, numrows-xy.cart$V2)

# Add some color
plot(0, 0, xlim=c(0,256), ylim=c(0, 104), type="n", xaxt="n", yaxt="n", xlab=NA, ylab=NA)
rect(-20, -20, 300, 130, col="#cccccc")
lines(xy.cart$V1, numrows-xy.cart$V2, col="purple", lwd=2)
