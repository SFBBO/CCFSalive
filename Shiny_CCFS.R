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
bird.cap$Month<-as.Date(x = paste(bird.cap$Month, "01, 2020"), format= "%b %d, %Y")

# User Interface

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
out5 <- plotOutput('weather_correlation_plot')
side <- sidebarPanel('Options', in1, in2)
main <- mainPanel(out1, out2, out3, out4, out5)
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
      scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
      labs(color="Species") +
      theme_classic(base_size=18, base_line_size = 1.25) +
      theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1, color="black", face="bold")) +
      theme(axis.text.y = element_text(color="black", face="bold"))
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
      fig <- ggplot(df, aes(x = Year, y = Rate, color=as.factor(Species))) +
        geom_line(size=1.25) +
        ylab("Birds captured/10,000 net hours") +
        theme_classic(base_size=18, base_line_size = 1.25) +
        theme(axis.line.y.left = element_line(color = "black"), 
              axis.ticks.y.left = element_line(color = "black"),
              axis.text.y.left = element_text(color = "black", face="bold"), 
              axis.title.y.left = element_text(color = "black"),
              axis.text.x = element_text(color="black", face="bold")
        ) +
        labs(color="Species") +
        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
        scale_x_continuous(breaks = scales::pretty_breaks(n = 10))
      
      ##add weather data to the plot if a weather parameter is selected
        if (input[['selected_parameter']] != "None") {
          fig <- fig + geom_line(aes(x = Year, y = value * scaleFactor), size=1.25, color="black", linetype="dashed") +
            scale_y_continuous(breaks = scales::pretty_breaks(n = 10), sec.axis = sec_axis(~ . /scaleFactor, name = input[['selected_parameter']], breaks = scales::pretty_breaks(n = 10))) +
            theme(axis.text.y.right = element_text(color="black", face="bold"))
        }
      fig
  })
  
  output[['weather_correlation_plot']] <- renderPlot({
    df <- bird.weather %>% 
      dplyr::filter(param.descr == input[['selected_parameter']] & Species %in% input[['selected_species']])
    fig <- ggplot(df, aes(x=value, y = Rate))
      if (input[['selected_parameter']] != "None") {
        fig <- fig + geom_point()
      } else {
        fig <- fig #+ geom_text(position = )
      }
    fig
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)