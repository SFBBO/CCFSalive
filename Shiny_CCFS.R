##shiny app
library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)

#runExample('01_hello')
#Data (can also source the data wrangling code when that's available)
bird.weather<-read.csv("data/bird.weather.csv")
##format date
#bird.weather$Monthyear.date<-as.Date(as.character(bird.weather$Monthyear.date))

# User Interface
in1 <- selectInput(
  inputId = 'selected_parameter',
  label = 'Select a weather parameter',
  choices = unique(bird.weather$param.descr))

in2 <- selectInput(
  inputId = 'selected_species',
  label = 'Select a bird species',
  choices = unique(bird.weather$Species))

out1 <- textOutput('parameter_label')
out2 <- textOutput('species_label')
out3 <- plotOutput('weather_plot')
side <- sidebarPanel('Options', in1, in2)
main <- mainPanel(out1, out2, out3)
tab1 <- tabPanel(
  title = 'CCFS Species Capture Rates and Local Weather',
  sidebarLayout(side, main))

ui <- navbarPage(
  title = 'CCFS Alive',
  tab1)

# Server
server <- function(input, output) {
  output[['parameter_label']] <- renderText({ ##curly bracket indicates that there is an input object that may change based on user inputs
    input[['select_parameter']]
  })
  output[['species_label']] <- renderText({
    input[['select_species']]
  })
  output[['weather_plot']] <- renderPlot({
    df <- bird.weather %>% 
      dplyr::filter(param.descr == input[['selected_parameter']] & Species %in% input[['selected_species']])
    scaleFactor <- max(df$value) / max(df$Rate)
    ggplot(df, aes(x = YEAR, y = value)) +
      geom_line() +
      geom_line(aes(x = YEAR, y = Rate * scaleFactor), color="blue") +
      scale_y_continuous(name=input[['selected_parameter']], sec.axis = sec_axis(~ . /scaleFactor, name = "Birds captured/1000 net hours")) +
      theme(axis.line.y.right = element_line(color = "blue"), 
            axis.ticks.y.right = element_line(color = "blue"),
            axis.text.y.right = element_text(color = "blue"), 
            axis.title.y.right = element_text(color = "blue")
      )
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)