library("twitteR")

# Search for visualization
visSearch <- searchTwitter("visualization", n=1000)
visCreated <- c()
for (i in 1:length(visSearch)) {
	visCreated <- c(visCreated, visSearch[[i]]$getCreated())
}
visCreated <- visCreated[order(visCreated, decreasing=FALSE)]

# Search for infographics
infoSearch <- searchTwitter("infographics", n=1000)
infoCreated <- c()
for (i in 1:length(infoSearch)) {
	infoCreated <- c(infoCreated, infoSearch[[i]]$getCreated())
}
infoCreated <- infoCreated[order(infoCreated, decreasing=FALSE)]

# Search for flowingdata
dataSearch <- searchTwitter("flowingdata", n=1000)
dataCreated <- c()
for (i in 1:length(dataSearch)) {
	dataCreated <- c(dataCreated, dataSearch[[i]]$getCreated())
}
dataCreated <- dataCreated[order(dataCreated, decreasing=FALSE)]


startTime <- min(min(visCreated), min(dataCreated), min(infoCreated))
endTime <- max(max(visCreated), max(dataCreated), max(infoCreated))
diff <- endTime - startTime


timeWindow <- 60 * 30
visPerWin <- rep(0, round(diff/timeWindow)+1)
for (i in 1:length(visCreated)) {
	index <- (endTime - visCreated[i]) / diff * length(visPerWin)
	visPerWin[index] <- visPerWin[index] + 1
}

infoPerWin <- rep(0, round(diff/timeWindow)+1)
for (i in 1:length(infoCreated)) {
	index <- (endTime - infoCreated[i]) / diff * length(infoPerWin)
	infoPerWin[index] <- infoPerWin[index] + 1
}

dataPerWin <- rep(0, round(diff/timeWindow)+1)
for (i in 1:length(dataCreated)) {
	index <- (endTime - dataCreated[i]) / diff * length(dataPerWin) + 1
	dataPerWin[index] <- dataPerWin[index] + 1
}

tweetsPerWin <- data.frame(rbind(visPerWin[1:50], dataPerWin[1:50], infoPerWin[1:50]), row.names=c("visualization", "flowingdata", "infographics"))