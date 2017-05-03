#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(rgdal)

shinyServer(function(input, output){
  load("gadf.Rdata") #carried out each time app is launched, where data is prepped 
  
  #reactive data
  passData <- reactive({
    firstData <- filter(gadf, date >= input$dateRange[1] & date <= input$dateRange[2])
    
    if(!is.null(input$domainShow)){
      firstData <- filter(firstData, networkDomain %in% input$domainShow)
    }
    return(firstData)
  })
  
  output$textDisplay <- renderText({
    paste(
      length(seq.Date(input$dateRange[1], input$dateRange[2], by = "days")),
      " days are summarised. There were", sum(passData()$users),
      "users in this time period."
    )
  })
  
  output$trend <- renderPlot({
    groupByDate = group_by(passData(), YearMonth, networkDomain) %>% #YearMonth and networkDomain are BOTH used to group passData()
      summarise(meanSession = mean(sessionDuration, na.rm = TRUE),
                users = sum(users),
                newUsers = sum(newUsers),
                sessions = sum(sessions)
      )
    
    groupByDate$Date <- as.Date(paste0(groupByDate$YearMonth, "01"),
                                format = "%Y%m%d")
    
    thePlot <- ggplot(groupByDate,
                      aes_string(x = "Date", #use aes_string() instead of aes() because it allows us to pass the input$outputRequired into the ggplot. aes() does not accept strings THIS way
                                 y = input$outputRequired,
                                 group = "networkDomain",
                                 colour = "networkDomain"
                      ) 
                ) + geom_line()
    
    if(input$smooth){
      thePlot <- thePlot + geom_smooth()
    }
    print(thePlot) #when using ggplot() normally not needed to print() plot
  })
  
  output$ggplotMap = renderPlot({
    groupCountry <- group_by(passData(), country)
    groupByCountry <- summarise(groupCountry, meanSession = mean(sessionDuration),
                                users = log(sum(users)),
                                sessions = log(sum(sessions))
                                )
    
    world <- readOGR(dsn = ".", layer = "world_country_admin_boundary_shapefile_with_fips_codes")
    countries <- world@data
    countries <- cbind(id = rownames(countries), countries)
    countries <- merge(countries, groupByCountry, by.x = "CNTRY_NAME",
                       by.y = "country", all.x = TRUE)
    map.df <- fortify(world)
    map.df <- merge(map.df, countries, by = "id")
    
    ggplot(map.df, aes(x = long, y = lat, group = group)) + 
    geom_polygon(aes_string(fill = input$outputRequired)) +
    geom_path(colour = "grey50") +
    scale_fill_gradientn(colours = rev(brewer.pal(9, "Spectral")), na.value = "white") +
    coord_fixed() + labs(x = "", y = "")
  })
})
