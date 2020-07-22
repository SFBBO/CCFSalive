##shiny app
library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)

#runExample('01_hello')
#Data (can also source the data wrangling code when that's available)
weather<-read.csv("data/weather.csv")

# User Interface
in1 <- selectInput(
  inputId = 'selected_parameter',
  label = 'Select a weather parameter',
  choices = unique(weather$param.descr))

out1 <- textOutput('parameter_label')
out2 <- plotOutput('weather_plot')
side <- sidebarPanel('Options', in1)
main <- mainPanel(out1, out2)
tab1 <- tabPanel(
  title = 'CCFS Local Weather',
  sidebarLayout(side, main))

ui <- navbarPage(
  title = 'CCFS Alive',
  tab1)

# Server
server <- function(input, output) {
  output[['parameter_label']] <- renderText({ ##curly bracket indicates that there is an input object that may change based on user inputs
    input[['select_parameter']]
  })
  output[['weather_plot']] <- renderPlot({
    df <- weather %>% 
      dplyr::filter(param.descr == input[['selected_parameter']] & Month == "ANN")
    ggplot(df, aes(x = YEAR, y = value)) +
      geom_line()
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)