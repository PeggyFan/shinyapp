## ui.R

library(shiny)
wvs_c <- read.csv("./wvs_c")

shinyUI(fluidPage(
  
  titlePanel("Membership in Associations in 85 countries using the World Values Survey, 1981-2007"),
  
  pageWithSidebar(
    
    # my Application title
    headerPanel(""),
    
    # a sidebar with controls to select the continent for which I want to see the distribution
    sidebarPanel(
      selectInput("region", "Select a region:",
                  list("All World"= "the world",
                       "North America & Western Europe"="region1",
                       "Central Europe"="region2",
                       "Asia"="region3",
                       "Latina America & Caribbean"="region4",
                       "Sub-Saharan Africa"="region5",
                       "Middle East & Northern Africa"="region6",
                       "Oceania"="region7"),
                  selected= "the World" )
    ),
    
    
    mainPanel(
      p("Associational membership is a common measure for civic participation. Research has shown that being
        in an association is indicative of the extent of a person's social capital, social network, and 
        activeness in public and civic life."),
      
      p("The app presents some data on the probability of being a member of an association across the 
        world using the World Values Survey data. Associational membership is defined as whether the respondent is a member of the following 
        types of association: sports, arts, labor, politics, environment, women's rights, human rights, 
        charity, and other. The analyses are divided into regional and country levels
        and focus on membership rate by two factors: gender and highest education attained."),
      
      tabsetPanel(
        id = 'dataset',
        tabPanel('Map', plotOutput("map")),
        
        tabPanel('Gender', dataTableOutput('mytable'),
                 selectInput('country', 'Select a Country:', 
                             names(wvs_c$country), selected=names(wvs_c$country)[1]),
                 plotOutput("myplot")
        ),
        
        tabPanel('Education attainment', dataTableOutput('mytable1'),
                 selectInput('country2', 'Select a Country:', 
                             names(wvs_c$country), selected=names(wvs_c$country)[1]),
                 plotOutput("myplot1")
        ),
        
        tabPanel('Documentation', 
                 p("Data came from the World Values Survey. At the time of the analyis,
                   only wave 1 to the first half of wave 5 (1981-2007) were available. 
                   The data and questionnaire can be found below:"),
                 
                 p("",a("World Values Survey",href="hwww.worldvaluessurvey.org/WVSContents.jsp")),
                 
                 p("Numbers represented are averages across all 5 waves of the data depending on the
                   chosen unit of analyses, such as region versus country."),
                 
                 p("Users can choose to look at the whole dataset, 'the world', or data on each world region.
                   Depending on the choice, the map and table on each tab show the corresponding data.
                   The tables can be sorted by variables. Below the table, users can explore the
                   data of each country under the selected region. The default is the plot of regional 
                   averages of each tab.")
                 ),
        
        p("Check out my work at https://github.com/PeggyFan")
        
        
                 )
                 )
    
        )))