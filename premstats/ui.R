library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Premiership Statistics"),
  
  # Sidebar with controls to provide a caption, select a dataset,
  # and specify the number of observations to view. Note that
  # changes made to the caption in the textInput control are
  # updated in the output area immediately as you type
  sidebarLayout(
    sidebarPanel(
      h5("Select a Home team and and Away team from the drop down menu below to display a summary and details of match history"),
      selectInput("HomeTeam", "Home Team:", 
                  choices = c('Arsenal',	'Aston Villa',	'Barnsley',	'Birmingham',	'Blackburn',	
                              'Blackpool',	'Bolton',	'Bournemouth',	'Bradford',	'Burnley',	'Cardiff',	
                              'Charlton',	'Chelsea',	'Coventry',	'Crystal Palace',	'Derby',	'Everton',	
                              'Fulham',	'Hull',	'Ipswich',	'Leeds',	'Leicester',	'Liverpool',	'Man City',	
                              'Man United',	'Middlesboro',	'Middlesbrough',	'Newcastle',	'Norwich',	'Nott\'m Forest',	
                              'Oldham',	'Portsmouth',	'QPR',	'Reading',	'Sheffield United',	'Sheffield Weds',	'Southampton',	
                              'Stoke',	'Sunderland',	'Swansea',	'Swindon',	'Tottenham',	'Watford',	'West Brom',	'West Ham',	
                              'Wigan',	'Wimbledon',	'Wolves')),
      selectInput("AwayTeam", "Away Team:", 
                  choices = c('Arsenal',	'Aston Villa',	'Barnsley',	'Birmingham',	'Blackburn',	
                              'Blackpool',	'Bolton',	'Bournemouth',	'Bradford',	'Burnley',	'Cardiff',	
                              'Charlton',	'Chelsea',	'Coventry',	'Crystal Palace',	'Derby',	'Everton',	
                              'Fulham',	'Hull',	'Ipswich',	'Leeds',	'Leicester',	'Liverpool',	'Man City',	
                              'Man United',	'Middlesboro',	'Middlesbrough',	'Newcastle',	'Norwich',	'Nott\'m Forest',	
                              'Oldham',	'Portsmouth',	'QPR',	'Reading',	'Sheffield United',	'Sheffield Weds',	'Southampton',	
                              'Stoke',	'Sunderland',	'Swansea',	'Swindon',	'Tottenham',	'Watford',	'West Brom',	'West Ham',	
                              'Wigan',	'Wimbledon',	'Wolves')),
      
      h6('Data for this app is credited to http://www.football-data.co.uk')
      
    ),
    
    # Show the caption, a summary of the dataset and an HTML 
    # table with the requested number of observations
    mainPanel(
      h3('Summary of match history'),
      h5('This is a summary of match history, the total Home team wins (H) Draws (D) and Away team win(A) for this particular match since 1993/94'),
      verbatimTextOutput("summary"), 
      
      h3('Match History'),
      h5('These are details of the match history.  You can see what the scorelines were'),
      
      tableOutput("mh"),
      
      h3('Cummulative Premier league match statistics 1993/94 to 2015/16'),
      h5('This is bonus content showing the ranking of teams based on points accumulated since 1993/94'),
      tableOutput("view")
    )
  )
))