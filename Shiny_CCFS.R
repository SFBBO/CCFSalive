##shiny app
library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)

#runExample('01_hello')
#Data (can also source the data wrangling code when that's available)
bird.weather<-read.csv("data/bird.weather.csv")
##format date
bird.weather$Monthyear.date<-as.Date(as.character(bird.weather$Monthyear.date))

# User Interface
in1 <- selectInput(
  inputId = 'selected_parameter',
  label = 'Select a weather parameter',
  choices = unique(bird.weather$param.descr))

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
    df <- bird.weather %>% 
      dplyr::filter(param.descr == input[['selected_parameter']] & YEAR==2005 & Species == "BUSH")
    ggplot(df, aes(x = Monthyear.date, y = value)) +
      geom_point() +
      geom_point(aes(x = Monthyear.date, y = Rate), pch=2) +
      scale_x_date(date_labels="%B %Y")
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)