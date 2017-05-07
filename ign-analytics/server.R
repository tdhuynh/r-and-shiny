

library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
  a <- read.csv("~/Documents/r-practice/ign-analytics/ign.csv")
  rxData <- reactive({
    newData <- filter(a, release_year %in% input$theYear)
    newData <- filter(newData, platform %in% input$thePlatform)
    return(newData)
  })
    
  output$plotDisplay <- renderPlot({
    groupData <- group_by(rxData(), release_year, platform)
    groupData$Year <- groupData$release_year
    groupData$Score <- groupData$score
    
    thePlot <- ggplot(groupData, aes_string(x = "Year",
                                            y = "Score")) + geom_bar(stat = "identity")
    
    print(thePlot)
  })
  
})
