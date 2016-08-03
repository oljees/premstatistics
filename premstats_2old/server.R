#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(curl)
library(RCurl)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(sqldf)

setwd("D:\\Jorgen\\Documents\\Coursera\\courses-master\\09_DevelopingDataProducts\\assignment_je")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
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
  
  mh<-sqldf("select * 
      from alldata
      where HomeTeam='Chelsea' and AwayTeam='Arsenal' ")
  
  output$matchHistory<- renderPrint(table(mh$FTR))
  output$teams<-renderPrint(unique(alldata$HomeTeam))
  #-----
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
#-----------  
})
