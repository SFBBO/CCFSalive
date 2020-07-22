##shiny app
library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)

#runExample('01_hello')
#Data (can also source the data wrangling code when that's available)
skip<-which(str_detect(string = read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv")[,1], pattern = "END.HEADER"))+1 ##skip all info in header section
weather<-read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv", skip = skip)

# User Interface
in1 <- selectInput(
  inputId = 'selected_parameter',
  label = 'Select a weather parameter',
  choices = unique(weather$PARAMETER))

out1 <- textOutput('parameter_label')
out2 <- plotOutput('weather_plot')
tab1 <- tabPanel(
  title = 'CCFS Local Weather',
  in1, out1, out2)

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
      dplyr::filter(PARAMETER == input[['selected_parameter']])
    ggplot(df, aes(x = YEAR, y = ANN)) +
      geom_line()
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)