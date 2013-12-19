source('library/latlong2state.R')

library(maps)
library(mapproj)
library(geosphere)
library(ggmap)
library(plyr)


getLineColor <- function(val) {
	#pal <- colorRampPalette(c("#333333", "#ffffff", "#b5310c"))
	pal <- colorRampPalette(c("#ffffff", "red"))
	colors <- pal(80)
	val.log <- log(val)
	
	if (val > 50) {
		col <- colors[80]
	} else {
		colindex <- max( 1, round( 80 * val / 50 ) )
		col <- colors[colindex]
	}
	
	return(col)
}



grocery <- read.csv("nearest-grocery-full.csv", stringsAsFactors=FALSE)

# Omit locations not in US
map("state", proj="albers", param=c(39, 45), col="#cccccc", fill=FALSE, bg="#000000", lwd=0.8)
grocery$state <- latlong2state(data.frame(grocery$lng, grocery$lat))
grocery$nearstate <- latlong2state(data.frame(grocery$lngnear, grocery$latnear))
grocery <- na.omit(grocery)

# Calculate colors
pts0 <- mapproject(unlist(grocery[, 'lng']), unlist(grocery[, 'lat']))
pts1 <- mapproject(unlist(grocery[, 'lngnear']), unlist(grocery[, 'latnear']))
seg.colors <- sapply(grocery$dist_miles, FUN=getLineColor)

# Draw map and line segments
segments(pts0$x, pts0$y, pts1$x, pts1$y, col=seg.colors, lwd=0.8)




#
# Map more specific locations
#

stateMap <- function(bbox, thedata) {
	basemap <- get_map(location=bbox, zoom=7, source='google', maptype="terrain", color="bw")
	ggmap(basemap) + geom_segment(aes(x=lng, xend=lngnear, y=lat, yend=latnear, colour=dist_miles), size=0.6, data=thedata) + geom_point(aes(x=lngnear, y=latnear), size=1.5, color="#000000", border="black", data=thedata) + scale_colour_gradient(low="white", high="red", limits=c(0, 60))

}


# States (bottom left lng, bottom left lat, top right lng, top right lat)
montana <- c(-116.23363635500002, 44.11419853862171, -103.48949572999454, 49.349270649782994)
stateMap(montana, subset(grocery, state=='montana'))

wyoming <- c(-111.75121447999258, 40.74204063165886, -103.75316760499973, 45.17718362104956)
stateMap(wyoming, subset(grocery, state=='wyoming'))

newmexico <- c(-109.64183947999595, 31.084677841684226, -102.52269885499945, 37.329749810660786)
stateMap(newmexico, subset(grocery, state=='new mexico'))

texas <- c(-106.56566760499526, 25.833252518835444, -93.03051135499216, 37.539118065754764)
stateMap(texas, subset(grocery, state=='texas'))

nevada <- c(-120.36449572999453, 34.192478247299434, -113.33324572999679, 42.32097191215088)
stateMap(nevada, subset(grocery, state=='nevada'))

nevada.utah <- c(-119.83715197999314, 34.33775104863148, -108.2355894799982, 42.255953372489664)
stateMap(nevada.utah, subset(grocery, state=='nevada' | state == 'utah'))

california <- c(-124.23168322999285, 31.460280893111246, -113.06957385500058, 42.77422165803667)
stateMap(california, subset(grocery, state=='california'))

nv.ut.ca.az <- c(-124.23168322999285, 31.460280893111246, -108.14769885499943, 42.32097191215088)
stateMap(nv.ut.ca.az, subset(grocery, state=='nevada' | state == 'utah' | state == 'california' | state == 'arizona'))

maine <- c(-72.28832385499655, 42.64505758353257, -66.83910510499581, 47.48286018989006)
stateMap(maine, subset(grocery, state=='maine'))



#
# Map Chicago
#

chicago <- read.csv("nearest-grocery-chicago-full.csv", stringsAsFactors=FALSE)
chicago$state <- latlong2state(data.frame(chicago$lng, chicago$lat))
chicago$nearstate <- latlong2state(data.frame(chicago$lngnear, chicago$latnear))
chicago <- na.omit(chicago)

bbox <- c(-88.28716418703594, 41.49885709933241, -87.20226428469279, 42.361130469567755)
basemap <- get_map(location=bbox, zoom=10, source='google', maptype="road", color="bw")
ggmap(basemap) + geom_segment(aes(x=lng, xend=lngnear, y=lat, yend=latnear, colour=dist_miles), size=0.9, data=chicago) + scale_colour_gradient(low="white", high="red", limits=c(0, 1))

ggmap(basemap) + stat_density2d(aes(x=lngnear, y=latnear), data=chicago, bins=50, color="red", alpha=0.8)



getLineColor.chi <- function(val) {
	pal <- colorRampPalette(c("#ffffff", "red"))
	colors <- pal(80)
	val.log <- log(val)
	
	if (val > 1) {
		col <- colors[80]
	} else {
		colindex <- max( 1, round( 80 * val ) )
		col <- colors[colindex]
	}
	
	return(col)
}

map("state", regions="illinois", proj="albers", param=c(39, 45), col="#cccccc", fill=FALSE, bg="#ffffff", lwd=0.8)
chicago <- read.csv("nearest-grocery-chicago.csv", stringsAsFactors=FALSE)

chi.pts0 <- mapproject(unlist(chicago[, 'lng']), unlist(chicago[, 'lat']))
chi.pts1 <- mapproject(unlist(chicago[, 'lngnear']), unlist(chicago[, 'latnear']))
chi.seg.colors <- sapply(chicago$dist_miles, FUN=getLineColor.chi)

# Draw map and line segments
segments(chi.pts0$x, chi.pts0$y, chi.pts1$x, chi.pts1$y, col=seg.colors, lwd=0.8)



