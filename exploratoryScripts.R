

library(curl)
library(RCurl)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(sqldf)


setwd("D:\\Jorgen\\Documents\\Coursera\\courses-master\\09_DevelopingDataProducts\\assignment_je")
list.files()

#download data
if (!file.exists("data")){
  dir.create("data")
}

seasons<-c("1516","1415","1314","1213","1112","1011","0910","0809","0708","0607","0506",
           "0405","0304","0203","0102","0001","9900","9899","9798","9697","9596","9495","9394")

#download all seasons - "http://www.football-data.co.uk/mmz4281/1516/E0.csv" is 1516
for (yr in seasons) {
download.file(paste("http://www.football-data.co.uk/mmz4281/",yr,"/E0.csv",sep=""),
              destfile=paste("./data/",yr,".csv",sep=""))
}

dateDownloaded <- today()
dateDownloaded
#import data

alldata<-data.frame()
for(yr in seasons) {
  d<-read.csv(paste("./data/",yr,".csv",sep=""))
  d$season<-yr
  d<-d[,c("season","Div", "Date", "HomeTeam", "AwayTeam", "FTHG","FTAG", "FTR")]
  alldata<-rbind(alldata,d)
}


#process
alldata$Date <- as.Date( 
  alldata$Date, 
  format = ifelse( 
    nchar(as.character(alldata$Date))>8, 
    "%d/%m/%Y", 
    "%d/%m/%y" 
  ) 
)

alldata<-sqldf("select * from alldata where date is not null")
alldata$FTR<-factor(alldata$FTR, levels=c("H","D","A"))
#make long so can select team

#alldatalong<-gather(alldata,team,stat,HomeTeam:FTR)
allteams<-unique(alldata$HomeTeam)
write.csv(as.data.frame(allteams), file="allteams.csv")
#exploratory graphs
g1<-qplot(Date,FTHG,data=alldata[which(alldata$HomeTeam=="Chelsea" & year(alldata$Date)==2016),],geom = "line")
plot(g1)

#homegoals
g1<-qplot(Date,FTHG,data=alldata[which((alldata$HomeTeam=="Chelsea" | alldata$HomeTeam=="Arsenal") & year(alldata$Date)==2016),],
          geom = "line",colour=HomeTeam)
g1+facet_grid(.~FTR)
plot(g1)

#compare stats for two teams over set period
tablecomp<-alldata%>%
  filter((HomeTeam=="Chelsea" & AwayTeam=="Arsenal") | (HomeTeam=="Arsenal" & AwayTeam=="Chelsea") )%>%
  filter((season=="1516" | season=="1415"))

#compare number of goals scored for same teams over same period
tc2<-alldata%>%
  filter((HomeTeam=="Chelsea" & AwayTeam=="Arsenal") | (HomeTeam=="Arsenal" & AwayTeam=="Chelsea"))%>%
  arrange(Date)

#complete league table
homewin<-sqldf("select hometeam as team, count(FTR) as hWins
               from alldata
               where FTR='H' 
               group by hometeam")

homeloss<-sqldf("select hometeam as team, count(FTR) as hloss
               from alldata
               where FTR='A' 
               group by hometeam")

homedraw<-sqldf("select hometeam as team, count(FTR) as hdraw
               from alldata
                where FTR='D' 
                group by hometeam")

awaywin<-sqldf("select awayteam as team, count(FTR) as aWins
               from alldata
               where FTR='A' 
               group by awayteam")

awayloss<-sqldf("select awayteam as team, count(FTR) as aloss
               from alldata
               where FTR='H' 
               group by awayteam")


awaydraw<-sqldf("select awayteam as team, count(FTR) as adraw
                from alldata
                where FTR='D' 
                group by awayteam")

cleague<-left_join(homewin,homedraw,by="team")
cleague<-left_join(cleague,homeloss,by="team")
cleague<-left_join(cleague,awaywin,by="team")
cleague<-left_join(cleague,awaydraw,by="team")
cleague<-left_join(cleague,awayloss,by="team")

cleague<-mutate(cleague,
                points=(hWins*3)+(hdraw)+(aWins*3)+adraw)%>%
  arrange(desc(points))


#match history by season

mh<-sqldf("select * 
      from alldata
      where HomeTeam='Chelsea' and AwayTeam='Arsenal' ")

matchHistory<-table(mh$FTR)
matchHistory

mh
#matchHistory<-as.data.frame(table(mh$FTR))

#homegoals vs away goals
mh%>%
  summarise(TotalHomeGoals=sum(FTHG),
            TotalAwayGoals=sum(FTAG))
