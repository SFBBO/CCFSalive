##shiny app
library(shiny)
library(stringr)
library(ggplot2)
library(dplyr)
library(lubridate) ##required for dealing with dates

#runExample('01_hello')
bird.cap<-read.csv("data/bird.cap.csv", stringsAsFactors = F)
bird.weather<-read.csv("data/bird.weather.csv", stringsAsFactors = F)
##format date
#bird.cap$Monthyear.date<-as.Date(bird.cap$Monthyear.date)
bird.cap$Month<-as.Date(x = paste(bird.cap$Month, "01, 2020"), format= "%b %d, %Y")

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
  choices = c("None", unique(bird.weather$param.descr)))

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
      group_by(Species, Month) %>%
      summarise(Rate=sum(Cap)/sum(NH)*1000) %>% data.frame()
    ggplot(df, aes(x = Month, y = Rate, color=as.factor(Species))) +
      geom_line(size=1.25) +
      ylab("Birds captured/1000 net hours") +
      scale_x_date(date_labels = "%B", date_breaks="1 month") +
      labs(color="Species")
  })
  
  output[['weather_plot']] <- renderPlot({
    ##subset data based on whether or not weather will be included on plot
    if (input[['selected_parameter']] != "None") {
      df <- bird.weather %>% 
        dplyr::filter(param.descr == input[['selected_parameter']] & Species %in% input[['selected_species']])
      scaleFactor <-max(df$Rate)/max(df$value) } else {
        df <- bird.weather %>% 
          dplyr::filter(Species %in% input[['selected_species']])
      }
    ##create the plot
      fig <- ggplot(df, aes(x = YEAR, y = Rate, color=as.factor(Species))) +
        geom_line(size=1.25) +
        ylab("Birds captured/10,000 net hours") +
        theme(axis.line.y.left = element_line(color = "coral3"), 
              axis.ticks.y.left = element_line(color = "coral3"),
              axis.text.y.left = element_text(color = "coral3"), 
              axis.title.y.left = element_text(color = "coral3")
        ) +
        labs(color="Species")
      
      ##add weather data to the plot if a weather parameter is selected
        if (input[['selected_parameter']] != "None") {
          fig <- fig + geom_line(aes(x = YEAR, y = value * scaleFactor), size=1.25, color="black", linetype="dashed") +
            scale_y_continuous(sec.axis = sec_axis(~ . /scaleFactor, name = input[['selected_parameter']]))
        }
      fig
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)