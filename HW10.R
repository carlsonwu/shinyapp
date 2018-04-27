library(shiny)
library(choroplethr)
library(tidyverse)
library(tidycensus)
library(ggplot2)

census_api_key("2cb62d6a72a7aba26465acbabf244c2cddf04b20")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("State", "State",  choices = state.abb),
      radioButtons("Plot", "Plot",
                   choices = list("MedianHouseholdIncome", "MedianGrossRent", "Ratio"))),
    mainPanel(
      plotOutput("Plot")
    )
  ),
  titlePanel("American Community Survey")
  # title
)
server <- function(input, output){
 
  reduced_df <- reactive({
    get_acs(
      geography = "tract",
      variables = c(MedianHouseholdIncome = "B19013_001", MedianGrossRent = "B25064_001"),
      state = input$State,
      geometry = TRUE
    ) %>%
      .[,-5] %>%
      data.frame() %>%
      spread(key = variable, value = estimate) %>%
      mutate(ratio = MedianGrossRent / MedianHouseholdIncome)
  })
  
  output$Plot <- renderPlot({
    reduced_df() %>%
      ggplot(aes_string(fill = input$Plot)) + scale_fill_gradientn(colours = rainbow(7))
  })
}
shinyApp(ui = ui, server = server)
