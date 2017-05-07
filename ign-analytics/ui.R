
library(shiny)

a <- read.csv("~/Documents/r-practice/ign-analytics/ign.csv")
platformList <- vector(mode = "character",
                       length = nrow(unique(a["platform"]))
                       )
yearList <- vector(mode = "integer",
                   length = nrow(unique(a["release_year"]))
                   )
uList <- unique(a["platform"])
yList <- unique(a["release_year"])
i <- 1
for(x in uList){
  for (y in x){
    platformList[[i]] <- y
    i <- i + 1
  }
}
platformList = sort(platformList)

j <- 1
for(n in yList){
  for (m in n){
    yearList[[j]] <- m
    j <- j + 1
  }
}
yearList = sort(yearList)

shinyUI(fluidPage(
  titlePanel("Ratings of Video Games"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "theYear",
                label = "Year Released:",
                choices = yearList),
      selectInput(inputId = "theplatform",
                   label = "Choose Platform:",
                   choices = platformList
      )
    ),
    mainPanel(
      plotOutput("plotDisplay")
    )
  )

))
