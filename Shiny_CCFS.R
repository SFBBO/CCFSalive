##shiny app
library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)

#runExample('01_hello')
bird.cap<-read.csv("data/bird.cap.csv")
bird.weather<-read.csv("data/bird.weather.csv")
##format date
bird.cap$Monthyear.date<-as.Date(as.character(bird.cap$Monthyear.date))

# User Interface

#in1 <- selectInput(
#  inputId = 'selected_species',
#  label = 'Select bird species',
#  choices = unique(bird.weather$Species))

in1 <- checkboxGroupInput(
  inputId = 'selected_species', 
  label = 'Select bird species', 
  choices = unique(bird.cap$Species), 
  selected = "BUSH")

in2 <- selectInput(
  inputId = 'selected_parameter',
  label = 'Select a weather parameter',
  choices = unique(bird.weather$param.descr))

out1 <- textOutput('species_label')
out2 <- textOutput('parameter_label')
out3 <- plotOutput('phenology_plot')
out4 <- plotOutput('weather_plot')
side <- sidebarPanel('Options', in1, in2)
main <- mainPanel(out1, out2, out3, out4)
tab1 <- tabPanel(
  title = 'CCFS Species Capture Rates and Local Weather',
  sidebarLayout(side, main))

ui <- navbarPage(
  title = 'CCFS Alive',
  tab1)

# Server
server <- function(input, output) {
  output[['species_label']] <- renderText({
    input[['select_species']]
  })
  
  output[['parameter_label']] <- renderText({ ##curly bracket indicates that there is an input object that may change based on user inputs
    input[['select_parameter']]
  })
  
  output[['phenology_plot']] <- renderPlot({
    df <- bird.cap %>% 
      dplyr::filter(Species %in% input[['selected_species']]) %>%
      group_by(Species, Month, Month.num) %>%
      summarise(Rate=sum(Cap)/sum(NH)*1000) %>% data.frame()
    ggplot(df, aes(x = Month.num, y = Rate, color=as.factor(Species))) +
      geom_line(size=1.25) +
      ylab("Birds captured/1000 net hours") +
      xlab("Month") +
      labs(color="Species")
  })
  
  output[['weather_plot']] <- renderPlot({
    df <- bird.weather %>% 
      dplyr::filter(param.descr == input[['selected_parameter']] & Species %in% input[['selected_species']])
    scaleFactor <- max(df$value) / max(df$Rate)
    ggplot(df, aes(x = YEAR, y = value)) +
      geom_line(size=1.25, linetype="dashed") +
      geom_line(aes(x = YEAR, y = Rate * scaleFactor, color=as.factor(Species)), size=1.25) +
      scale_y_continuous(name=input[['selected_parameter']], sec.axis = sec_axis(~ . /scaleFactor, name = "Birds captured/1000 net hours")) +
      theme(axis.line.y.right = element_line(color = "coral3"), 
            axis.ticks.y.right = element_line(color = "coral3"),
            axis.text.y.right = element_text(color = "coral3"), 
            axis.title.y.right = element_text(color = "coral3")
      ) +
      labs(color="Species")
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)