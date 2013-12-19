## Contour and Filled Contour map for UFO sightings
setwd("~/Desktop/Github/flowingdata_tutorials/contour_maps")
# Counts matrix derived using Python/MySQL
cnts <- read.csv("cnt_matrix.txt", header=FALSE)
cnts_matrix <- as.matrix(cnts)
dimnames(cnts_matrix)[[2]] <- NULL

# Transform counts matrix
cnts_matrix <- t(cnts_matrix[105:1,])

# Make the contour map, different levels and colors
contour(cnts_matrix)
contour(log(cnts_matrix+1))
contour(log(cnts_matrix+1), xaxt="n", yaxt="n", nlevels=5, lwd=0.5)

# Color palettes for contours
bwpal <- colorRampPalette(c("white", "black"))
orangepal <- colorRampPalette(c("white", "#c75a00"))

# Contour with colors
contour(log(cnts_matrix+1), xaxt="n", yaxt="n", nlevels=5, col=bwpal(6))
contour(log(cnts_matrix+1), xaxt="n", yaxt="n", nlevels=10, col=orangepal(12))
contour(log(cnts_matrix+1), xaxt="n", yaxt="n", nlevels=10, col=rainbow(12))



# Palettes for filled contours
redpal <- colorRampPalette(c("black", "red", "white"))
cyanpal <- colorRampPalette(c("black", "cyan", "white"))
purppal <- colorRampPalette(c("black", "purple", "white"))
bluepal <- colorRampPalette(c("black", "blue", "white"))

# Make the filled contour plot
filled.contour(log(cnts_matrix+1), color.palette=redpal, nlevels=5)
filled.contour(log(cnts_matrix+1), color.palette=redpal, nlevels=30)

# Trying different palettes
filled.contour(log(cnts_matrix+1), color.palette=cyanpal, nlevels=30)
filled.contour(log(cnts_matrix+1), color.palette=purppal, nlevels=30)
filled.contour(log(cnts_matrix+1), color.palette=bluepal, nlevels=30)
filled.contour(log(cnts_matrix+1), color.palette=bwpal, nlevels=30)



#### DEPRECATED - SUPER SLOW IN RETRIEVING COUNTS - USE THE PYTHON SCRIPT INSTEAD

con <- dbConnect(MySQL(), user="root", password="", dbname="ufo", host="localhost")
sql_beg <- "SELECT id, lat, lng FROM sightings WHERE MBRContains(GeomFromText('LineString("
sql_end <- ")'), lat_lng)"

# 41.6 -91.6, 42 -91.5

lat_NW <- 50.523427
lng_NW <- -128.847656
lat_SE <- 23.725012
lng_SE <- -61.347656

lats <- seq(lat_NW, lat_SE, by=-.0725)
lngs <- seq(lng_NW, lng_SE, by=.0725)

ufo_matrix <- matrix(nrow=length(lats), ncol=length(lngs))

for (i in 2:length(lats)) {
	for (j in 2:length(lngs)) {
		
		sql_full <- paste(sql_beg, lats[i-1], " ", lngs[j-1], ", ", lats[i], " ", lngs[j], sql_end, sep="")
		sightings <- dbGetQuery(con, sql_full)
		cnt <- length(sightings$id)
		ufo_matrix[i, j] <- cnt
	}
}

