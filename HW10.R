library(shiny)
library(tidyverse)
library(tidycensus)
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("State Input", "State(abbr.)"),
      radioButtons("PlotSelected", "Plot to Show",
                   choices = c("Median Household Income", "Median Gross Rent", "Ratio"))),
    mainPanel(
      plotOutput("Plot")
    )
  ),
  titlePanel("American Community Survey")
)
server <- function(input, output, session){
}
shinyApp(ui = ui, server = server)
