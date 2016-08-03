library(shiny)
library(datasets) #
library(curl)
library(RCurl)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(sqldf)


#download and prepare data
setwd("D:\\Jorgen\\Documents\\Coursera\\courses-master\\09_DevelopingDataProducts\\assignment_je")
seasons<-c("1516","1415","1314","1213","1112","1011","0910","0809","0708","0607","0506",
           "0405","0304","0203","0102","0001","9900","9899","9798","9697","9596","9495","9394")
alldata<-data.frame()
for(yr in seasons) {
  #d<-read.csv(paste("D:/Jorgen/Documents/Coursera/courses-master/09_DevelopingDataProducts/assignment_je/data/",yr,".csv",sep=""))
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
                points=round(hWins*3)+(hdraw)+(aWins*3)+adraw)%>%
  arrange(desc(points))

##--------------------------------------------------------------

# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
  
  # By declaring datasetInput as a reactive expression we ensure 
  # that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers 
  #	  (it only executes a single time)
  #
  HomeTeam <- reactive({
    switch(input$HomeTeam,
           'Arsenal'='Arsenal',
           'Aston Villa'='Aston Villa',
           'Barnsley'='Barnsley',
           'Birmingham'='Birmingham',
           'Blackburn'='Blackburn',
           'Blackpool'='Blackpool',
           'Bolton'='Bolton',
           'Bournemouth'='Bournemouth',
           'Bradford'='Bradford',
           'Burnley'='Burnley',
           'Cardiff'='Cardiff',
           'Charlton'='Charlton',
           'Chelsea'='Chelsea',
           'Coventry'='Coventry',
           'Crystal Palace'='Crystal Palace',
           'Derby'='Derby',
           'Everton'='Everton',
           'Fulham'='Fulham',
           'Hull'='Hull',
           'Ipswich'='Ipswich',
           'Leeds'='Leeds',
           'Leicester'='Leicester',
           'Liverpool'='Liverpool',
           'Man City'='Man City',
           'Man United'='Man United',
           'Middlesboro'='Middlesboro',
           'Middlesbrough'='Middlesbrough',
           'Newcastle'='Newcastle',
           'Norwich'='Norwich',
           'Nott\'m Forest'='Nott\'m Forest',
           'Oldham'='Oldham',
           'Portsmouth'='Portsmouth',
           'QPR'='QPR',
           'Reading'='Reading',
           'Sheffield United'='Sheffield United',
           'Sheffield Weds'='Sheffield Weds',
           'Southampton'='Southampton',
           'Stoke'='Stoke',
           'Sunderland'='Sunderland',
           'Swansea'='Swansea',
           'Swindon'='Swindon',
           'Tottenham'='Tottenham',
           'Watford'='Watford',
           'West Brom'='West Brom',
           'West Ham'='West Ham',
           'Wigan'='Wigan',
           'Wimbledon'='Wimbledon',
           'Wolves'='Wolves')
    })
  
  AwayTeam <- reactive({
    switch(input$AwayTeam,
           'Arsenal'='Arsenal',
           'Aston Villa'='Aston Villa',
           'Barnsley'='Barnsley',
           'Birmingham'='Birmingham',
           'Blackburn'='Blackburn',
           'Blackpool'='Blackpool',
           'Bolton'='Bolton',
           'Bournemouth'='Bournemouth',
           'Bradford'='Bradford',
           'Burnley'='Burnley',
           'Cardiff'='Cardiff',
           'Charlton'='Charlton',
           'Chelsea'='Chelsea',
           'Coventry'='Coventry',
           'Crystal Palace'='Crystal Palace',
           'Derby'='Derby',
           'Everton'='Everton',
           'Fulham'='Fulham',
           'Hull'='Hull',
           'Ipswich'='Ipswich',
           'Leeds'='Leeds',
           'Leicester'='Leicester',
           'Liverpool'='Liverpool',
           'Man City'='Man City',
           'Man United'='Man United',
           'Middlesboro'='Middlesboro',
           'Middlesbrough'='Middlesbrough',
           'Newcastle'='Newcastle',
           'Norwich'='Norwich',
           'Nott\'m Forest'='Nott\'m Forest',
           'Oldham'='Oldham',
           'Portsmouth'='Portsmouth',
           'QPR'='QPR',
           'Reading'='Reading',
           'Sheffield United'='Sheffield United',
           'Sheffield Weds'='Sheffield Weds',
           'Southampton'='Southampton',
           'Stoke'='Stoke',
           'Sunderland'='Sunderland',
           'Swansea'='Swansea',
           'Swindon'='Swindon',
           'Tottenham'='Tottenham',
           'Watford'='Watford',
           'West Brom'='West Brom',
           'West Ham'='West Ham',
           'Wigan'='Wigan',
           'Wimbledon'='Wimbledon',
           'Wolves'='Wolves')
    })
  
  
  # The output$summary depends on the datasetInput reactive
  # expression, so will be re-executed whenever datasetInput is
  # invalidated
  # (i.e. whenever the input$dataset changes)
  output$summary <- renderPrint({
    dataset <- filter(alldata,HomeTeam==HomeTeam() & AwayTeam==AwayTeam())
    table(dataset$FTR)
  })
  
  # The output$view depends on both the databaseInput reactive
  # expression and input$obs, so will be re-executed whenever
  # input$dataset or input$obs is changed. 
  output$view <- renderTable({
    cleague
  })
})