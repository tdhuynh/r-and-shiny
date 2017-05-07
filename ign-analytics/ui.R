
library(shiny)

a <- read.csv("~/Documents/r-practice/ign-analytics/ign.csv")

for (x in unique(a["platform"])) {
  print(x)
}

platformList <- vector(mode = "character",
                       length = nrow(unique(a["platform"]))
                       )
uList <- unique(a["platform"])

i <- 1
for(x in uList){
  for (y in x){
    platformList[[i]] <- y
    i <- i + 1
    print(y)
  }
}

platformList = sort(platformList)

shinyUI(fluidPage(
  titlePanel("Ratings of Video Games"),
  sidebarLayout(
    
    sidebarPanel(
      dateInput(inputId = "theDate",
                label = "Date Released",
                format = "yyyy-mm-dd",
                startview = "year"),
      selectInput(inputId = "platform",
                   label = "Choose Platform:",
                   choices = platformList
      )
    ),
    mainPanel(
      plotOutput("plotDisplay")
    )
  )

))
