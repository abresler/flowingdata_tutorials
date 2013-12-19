library(reshape2)
library(XML)
base <- 'http://www.basketball-reference.com/players/g/georgpa01/gamelog/'
urls <- paste(base,2011:2014,sep = '')
library(plyr)
all_advanced_rs <- data.frame()
all_regular <- data.frame()

for(u in urls){
tables <- readHTMLTable(u,trim=T,as.data.frame=T)
regular <- data.frame(tables['pgl_basic'])
regular$player_gamelog_url <- u
regular$season_type <- 'RS'
all_regular <- rbind.fill(all_regular,regular)
advanced <- data.frame(tables['pgl_advanced'])
advanced$player_gamelog_url <- u
advanced$season_type <- 'RS'
all_advanced_rs <- rbind.fill(all_advanced_rs,advanced)
rm(advanced)
rm(regular)
rm(tables)
}

all_regular$id <- all_regular$player_gamelog_url
all_regular$id <- gsub('http://www.basketball-reference.com/players/g','',all_regular$id)
all_regular$id <-gsub('/gamelog','',all_regular$id)
all_regular <- cbind(all_regular,colsplit(all_regular$id,'\\/',c('a','player_id','season')))
all_regular$a <- NULL
names(all_regular) <- tolower(gsub('pgl_basic.','',names(all_regular)))
all_regular$id <- NULL
all_regular <- all_regular[!all_regular$rk %in% 'Rk',]
names(all_regular)[5] <- 'team_code' 
all_regular <- data.frame(all_regular)
names(all_regular)[c(6,30)] <- c('location','home_away')
all_regular$date <- as.Date(all_regular$date,'%Y-%m-%d')
names(all_regular)
all_regular[,c(20:28)] <- apply(all_regular[,c(20:28)],2,as.numeric)

data <- all_regular

data$year<- as.numeric(as.POSIXlt(data$date)$year+1900)
data$year <- data$season
# the month too 
data$month <- as.numeric(as.POSIXlt(data$date)$mon+1)
# but turn months into ordered facors to control the appearance/ordering in the presentation
data$monthf <- factor(data$month,levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=F)
# the day of week is again easily found
data$monthf <- factor(data$monthf,levels=c('Oct','Nov','Dec','Jan','Feb','Mar','Apr'))
data$weekday = as.POSIXlt(data$date)$wday
# again turn into factors to control appearance/abbreviation and ordering
# I use the reverse function rev here to order the week top down in the graph
# you can cut it out to reverse week order
data[data$weekday == 0,'weekday'] <- 7
data$weekdayf<- factor(data$weekday,levels=rev(1:7),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE)
# the monthweek part is a bit trickier 
# first a factor which cuts the dataa into month chunks
data$yearmonth<-as.yearmon(data$date)
data$yearmonthf<-factor(data$yearmonth)
# then find the "week of year" for each day
data$week <- as.numeric(format(data$date,"%W"))
# and now for each monthblock we normalize the week to start at 1 
data<-ddply(data,.(yearmonthf),transform,monthweek=1+week-min(week))
data[data$monthweek == 6,'monthweek'] <- 5
data[data$month == 10,'monthweek'] <- 4
data[data$month == 10&data$year == 2011,'monthweek'] <- 5
data[data$month == 10&data$year == 2012,'monthweek'] <- 5
names(data)
P <- ggplot(data, aes(monthweek, weekdayf, fill = pts)) + 
	geom_tile(colour = "white") + facet_grid(year~monthf) +
	opts(title = "The Rise of Paul George") +  xlab("Week of Month") + ylab("")
P
P <- 
	P + scale_fill_gradientn("Points",colours = c("grey","red","blue",'black'), 
	values = rescale(c(0,13,43)),
	guide = "colorbar", limits=c(0,43))
P <- P + theme(
	plot.title = element_text(
		size = 20,
		face = "bold", 
		vjust = 1.5),
	legend.title = element_text(
		size=rel(1), 
		face="bold"))
P

all_advanced_rs$id <- all_advanced_rs$player_gamelog_url
all_advanced_rs$id <- gsub('http://www.basketball-reference.com/players/g','',all_advanced_rs$id)
all_advanced_rs$id <-gsub('/gamelog','',all_advanced_rs$id)
all_advanced_rs <- cbind(all_advanced_rs,colsplit(all_advanced_rs$id,'\\/',c('a','player_id','season')))
all_advanced_rs$a <- NULL
names(all_advanced_rs) <- tolower(gsub('pgl_advanced.','',names(all_advanced_rs)))
all_advanced_rs$id <- NULL
all_advanced_rs <- all_advanced_rs[!all_advanced_rs$rk %in% 'Rk',]
names(all_advanced_rs)[5] <- 'team_code' 
names(all_advanced_rs)[6] <- 'location' 
all_advanced_rs <- data.frame(all_advanced_rs)

all_advanced_rs$date <- as.Date(all_advanced_rs$date,'%Y-%m-%d')
names(all_advanced_rs)
all_advanced_rs[,c(20:22)] <- apply(all_advanced_rs[,c(20:22)],2,as.numeric)
all_advanced_rs$net_rtg <- all_advanced_rs$ortg - all_advanced_rs$drtg
all_advanced_rs$true_shooting <- 100 * (as.numeric(gsub('\\.','',all_advanced_rs$ts.))/1000)
all <- merge(all_regular,all_advanced_rs)
all <- all[order(all$date,decreasing=F),]
write.csv(all,'paul_george_rs_data.csv')
