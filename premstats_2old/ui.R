#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Premier League Statistics"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("HomeTeam", "Home Team", 
                    choices=list("Arsenal", "Chelsea", "Man United"), 
                  selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL, size = NULL),
      selectInput("AwayTeam", "Away Team", 
                  choices=list("Arsenal", "Chelsea", "Man United"), 
                  selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL, size = NULL)

    ),
    
    # Show a plot of the generated distribution
  mainPanel(
    textOutput("matchHistory") #add other tables and put code in server.R
  )
)))
