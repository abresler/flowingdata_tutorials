source("areagraph.R")

# Juvenile arrests for drug possession
arrests <- read.table("data/juvenile-arrests-drugs.txt", header=TRUE, row.names=1, sep=",")
areaGraph(arrests, type=0)

# Internet access via broadband and dial-up 
broadband <- read.table("data/broadband.txt", header=TRUE, row.names=1, sep=",")
areaGraph(broadband, type=2)

# Twitter data via search
par(mfrow=c(3,1), mar=c(5,5,2,2))
tweets <- read.table("data/tweets.txt", header=TRUE, row.names=1, sep=",")
areaGraph(tweets, type=0, smooth=FALSE)
areaGraph(tweets, type=0)
areaGraph(tweets, type=2)