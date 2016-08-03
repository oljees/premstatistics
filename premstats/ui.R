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
                              'Wigan',	'Wimbledon',	'Wolves'))
      
    ),
    
    
    # Show the caption, a summary of the dataset and an HTML 
    # table with the requested number of observations
    mainPanel(
      verbatimTextOutput("summary"), 
      
      tableOutput("view")
    )
  )
)