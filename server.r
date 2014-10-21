## server.R
library(rworldmap)
library(plyr)
library(reshape)
library(ggplot2)

# Source my file with data
wvs_c <- read.csv("./wvs_c")
wvs_table <- read.csv("./wvs_table")

wvs_c <- wvs_c[, -1]
wvs_table <- wvs_table[, -1]

# Define server logic to plot membership data for various #continents/countries
shinyServer(function(input,output,session) {
  
  # Plot a world map visualizing membership incidence. 
  
  "region1"<- wvs_c[(wvs_c$region == "region1"),]
  "region2"<- wvs_c[(wvs_c$region == "region2"),]
  "region3"<- wvs_c[(wvs_c$region == "region3"),]
  "region4"<- wvs_c[(wvs_c$region == "region4"),]
  "region5"<- wvs_c[(wvs_c$region == "region5"),]
  "region6"<- wvs_c[(wvs_c$region == "region6"),]
  "region7"<- wvs_c[(wvs_c$region == "region7"),]
  
  gender <- wvs_c[,c(2, 4:6)]
  highested <- wvs_c[,c(2, 4, 12:17)]
  
  colnames(highested) <- c("region", "country", "Primary", "Secondary.incomplete", "Secondary.vocational",
                           "Secondary.preparatory", "Tertiary.incomplete", "Tertiary")
  
  #for table outputs in percentages
  
  gender_table <- wvs_table[,c(2, 4:6)]
  highested_table <- wvs_table[,c(2, 4, 12:17)]
  
  colnames(highested_table) <- c("region", "country", "Primary", "Secondary.incomplete", "Secondary.vocational",
                                 "Secondary.preparatory", "Tertiary.incomplete", "Tertiary")
  
  #for regional aggregate plot
  highested_data <- highested[complete.cases(highested),]
  
  # Create table for gender breakdown
  selectedData <- reactive({
    if (input$region == "the world") {
      gender_table[,-1]
    } else {
      region = input$region
      gender_table[(gender_table$region == region), -1]
    }
  })
  
  output$mytable = renderDataTable({
    selectedData()
  }, options = list(lengthMenu = c(5,10), pageLength = 5, searching = FALSE)
  )
  
  # Create table for education attainment breakdown breakdown
  
  selectedData1 <- reactive({
    if (input$region == "the world") {
      highested_table[,-1]
    } else {
      region = input$region
      highested_table[(highested_table$region == region), -1]
    }
  })
  
  output$mytable1 = renderDataTable({
    selectedData1()
  }, options = list(lengthMenu = c(5,10), pageLength = 5, 
                    searching = FALSE)
  )
  
  
  # Create a second field of input "Select a country" based on the first input field "Select a region"
  
  observe({
    region = input$region
    updateSelectInput(session, "country",
                      choices = levels(as.factor(as.character(wvs_c$country[wvs_c$region==region]))), selected = levels(as.factor(as.character(wvs_c$country[wvs_c$region==region])))[1]
    )
  })
  
  observe({
    region = input$region
    updateSelectInput(session, "country2",
                      choices = levels(as.factor(as.character(wvs_c$country[wvs_c$region==region]))), selected = levels(as.factor(as.character(wvs_c$country[wvs_c$region==region])))[1]
    )
  })
  
  # Create charts for each country's gender breakdown
  
  selectedPlot <- reactive({
    if (input$region == "the world") {
      
      #for regional average of gender
      test<- aggregate(gender[, c("male", "female")],  by = list(as.character(gender$region)), function(x) c(mean=mean(x)))
      colnames(test)[1] <- "region"
      test2 <- melt(test[,c('region','male','female')],id.vars = 1)
      
      test2$region[test2$region=="region1"] <- "North America & Western Europe" 
      test2$region[test2$region=="region2"] <- "Central Europe" 
      test2$region[test2$region=="region3"] <- "Asia" 
      test2$region[test2$region=="region4"] <- "Latin American & Caribbean"
      test2$region[test2$region=="region5"] <- "Sub-Saharan Africa" 
      test2$region[test2$region=="region6"] <- "Middle East & North Africa" 
      test2$region[test2$region=="region7"] <- "Oceania" 
      
      cbbPalette <- c("#01DFD7", "#F78181")
      
      d <- ggplot(data=test2, aes(x=region, y=value)) 
      d <- d + geom_bar(aes(fill = variable), position="dodge", stat="identity") + scale_fill_manual(values=cbbPalette)
      d <- d + theme(axis.text.x=element_text(angle=-90)) + labs(y = 'Percent', x = '') + ylim(0, 1)
      d <- d + theme(axis.text.x = element_text(colour = "#424242"),
                     axis.text.y = element_text(colour = "#424242")) + theme(text = element_text(size=15)) +
        theme(legend.title=element_blank()) + ggtitle("Average rate of being a member")
      d
      
    } else {
      region = input$region
      country = input$country
      
      cbbPalette <- c("#01DFD7", "#F78181")
      
      x <- gender[(gender$country== country),]
      x <- melt(x[,c('country','male','female')], id.vars = 1)
      x1 <- ggplot(data=x, aes(x=variable, y=value)) 
      x1 <- x1 + geom_bar(aes(fill = variable), position="dodge", stat="identity") + scale_fill_manual(values=cbbPalette)
      x1 <- x1 + labs(y = 'Percent', x = '') + theme(axis.text.x = element_blank()) + ylim(0, 1) +
        theme(legend.title=element_blank()) + ggtitle("Average rate of being a member")
      x1
      
    }
  })
  
  output$myplot = renderPlot({
    selectedPlot()
  }
  )
  
  # Create charts for each country's educational level breakdown
  
  selectedPlot1 <- reactive({
    if (input$region == "the world") {
      
      #for regional average of highest education levels
      test3 <- aggregate(highested_data[, c('Primary','Secondary.incomplete','Secondary.vocational'
                                            ,'Secondary.preparatory','Tertiary.incomplete','Tertiary')],  
                         by = list(as.character(highested_data$region)), function(x) c(mean=mean(x)))
      
      colnames(test3)[1] <- "region"
      
      test3 <- melt(test3[, c('region','Primary','Secondary.incomplete','Secondary.vocational'
                              ,'Secondary.preparatory','Tertiary.incomplete','Tertiary')], id.vars = 1)
      
      test3$region[test3$region=="region1"] <- "North America & Western Europe" 
      test3$region[test3$region=="region2"] <- "Central Europe"
      test3$region[test3$region=="region3"] <- "Asia" 
      test3$region[test3$region=="region4"] <- "Latin American & Caribbean"
      test3$region[test3$region=="region5"] <- "Sub-Saharan Africa" 
      test3$region[test3$region=="region6"] <- "Middle East & North Africa" 
      test3$region[test3$region=="region7"] <- "Oceania" 
      
      d1 <- ggplot(data=test3, aes(x=variable, y=value)) 
      d1 <- d1 + geom_line(aes(group=region, color=region)) 
      d1 <- d1 + geom_point(aes(color=region, shape=region)) 
      d1 <- d1 + labs(y = 'Percent', x = 'Highest education level') + ylim(0, 1) + theme(axis.text.x=element_text(angle=-90))
      d1 <- d1 + theme(axis.text.x = element_text(colour = "#424242"),
                       axis.text.y = element_text(colour = "#424242")) + theme(text = element_text(size=15)) +
        theme(legend.title=element_blank()) + ggtitle("Average rate of being a member")
      d1
      
    } else {
      region = input$region
      country = input$country2
      
      cbbPalette1 <- c("#F7BE81", "#F79F81", "#82FA58", "#04B486", "#00BFFF", "#01A9DB")
      
      y <- highested[(highested$country == country),]
      y <-melt(y[, c('country','Primary','Secondary.incomplete','Secondary.vocational'
                     ,'Secondary.preparatory','Tertiary.incomplete','Tertiary')], id.vars = 1)
      y1 <- ggplot(data=y, aes(x=variable, y=value)) 
      y1 <- y1 + geom_bar(aes(fill = variable), position="dodge", stat="identity") + scale_fill_manual(values=cbbPalette1)
      y1 <- y1 + labs(y = 'Percent', x = '') + theme(axis.text.x = element_blank()) + ylim(0, 1) + 
        theme(legend.title=element_blank()) + ggtitle("Average rate of being a member")
      y1
      
    } 
  })
  
  output$myplot1 = renderPlot({
    selectedPlot1()
  }
  )
  
  
  # Create maps of "Percent of respondents belonging to an association"
  
  colourPalette1 <-c("#F5A9A9", "#F6D8CE", "#F8ECE0", "#EFFBFB", "#E0F2F7", "#CEE3F6", "#A9BCF5")
  
  output$map<- renderPlot({
    
    if (input$region =="the world"){
      world <- joinCountryData2Map(wvs_c
                                   ,joinCode = "ISO3"
                                   ,nameJoinColumn = "iso3")
      mapCountryData(world, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'       
                     ,nameColumnToPlot='participation')
      
    } 
    
    else if (input$region=="region1") {
      region1 <- joinCountryData2Map(region1
                                     ,joinCode = "ISO3"
                                     ,nameJoinColumn = "iso3")
      mapCountryData(region1, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'       
                     ,nameColumnToPlot='participation')
      
    }
    else if (input$region=="region2") {
      region2 <- joinCountryData2Map(region2
                                     ,joinCode = "ISO3"
                                     ,nameJoinColumn = "iso3")
      mapCountryData(region2, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'
                     ,nameColumnToPlot='participation')
      
    }
    
    else if (input$region=="region3") {
      region3 <- joinCountryData2Map(region3
                                     ,joinCode = "ISO3"
                                     ,nameJoinColumn = "iso3")
      mapCountryData(region3, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'
                     ,nameColumnToPlot='participation')
      
    }
    
    else if (input$region=="region4") {
      region4 <- joinCountryData2Map(region4
                                     ,joinCode = "ISO3"
                                     ,nameJoinColumn = "iso3")
      mapCountryData(region4, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'
                     ,nameColumnToPlot='participation')
      
    }
    
    else if (input$region=="region5") {
      region5 <- joinCountryData2Map(region5
                                     ,joinCode = "ISO3"
                                     ,nameJoinColumn = "iso3")
      mapCountryData(region5, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'
                     ,nameColumnToPlot='participation')
      
    }
    
    else if (input$region=="region6") {
      region6 <- joinCountryData2Map(region6
                                     ,joinCode = "ISO3"
                                     ,nameJoinColumn = "iso3")
      mapCountryData(region6, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'
                     ,nameColumnToPlot='participation')
      
    }
    
    else  {
      region7 <- joinCountryData2Map(region7
                                     ,joinCode = "ISO3"
                                     ,nameJoinColumn = "iso3")
      mapCountryData(region7, colourPalette=colourPalette1
                     ,mapTitle='Percent of respondents belonging to an association'
                     ,nameColumnToPlot='participation')
      
    }
    
  })
})

