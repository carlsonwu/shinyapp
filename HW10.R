library(shiny)
library(choroplethr)
library(tidyverse)
library(tidycensus)

census_api_key("2cb62d6a72a7aba26465acbabf244c2cddf04b20")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("StateInput", "State(abbr.)"),
      radioButtons("PlotSelected", "Plot to Show",
                   choices = c("Median Household Income", "Median Gross Rent", "Ratio"))),
    mainPanel(
      plotOutput("main_plot")
    )
  ),
  titlePanel("American Community Survey")
)
server <- function(input, output, session){
  output$main_plot <- renderPlot({
    selecteddata <- get_acs(geography = "county",
                            variables = c(medincome = "B19013_001", medrent = "B25064_001"),
                            state = input$StateInput)
    selecteddata <- selecteddata %>%
      mutate(ratio = medrent / medincome)
    
    plotselected <- switch(input$PlotSelected,
                           'Median Household Income' = "medincome",
                           'Median Gross Rent' = "medrent",
                           'Ratio' = "ratio")
    
    selecteddata %>%
      select(input$PlotSelected)%>%
      dplyr::rename(value = estimate) %>%
      mutate(region = as.integer(GEOID)) %>%
      choroplethr::country_choropleth(title = input$PlotSelected, num_colors = 1, state_zoom = input$StateInput)
  }
  )
}
shinyApp(ui = ui, server = server)
