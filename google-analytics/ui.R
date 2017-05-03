#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
  titlePanel("Google Analytics"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(inputId = 'dateRange', label = "Date range",
                     start = "2013-05-01"),
      checkboxGroupInput(inputId = "domainShow",
                         label = "Show NHS and other domain
                         (defaults to all)?",
                         choices = list("NHS users" = "nhs.uk", "Other" = "Other"),
                         selected = c("nhs.uk", "Other")),
      hr(),
      radioButtons(inputId = "outputRequired",
                   label = "Output required",
                   choices = list("Average session" = "meanSession",
                                  "Users" = "users",
                                  "Sessions" = "sessions")),
      checkboxInput("smooth", label = "Add smoother?",
                    value = FALSE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", textOutput("textDisplay")),
        tabPanel("Trend", plotOutput("trend")),
        tabPanel("Map", plotOutput("ggplotMap"))
      )
    )
  )
))