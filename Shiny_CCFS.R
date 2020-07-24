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

sfbbo_intro_text <- p("For more than 35 years, the San Francisco Bay Bird Observatory has conducted bird banding research on passerines at the Coyote Creek Field Station (CCFS) in Milpitas. Bird banding provides valuable information that helps us study bird dispersal, migration, behavior, social structure, life span, survival rate, reproductive success, and population growth. It also allows us to understand seasonal and long term population patterns of migratory, wintering and year-round resident birds; and track individual birds, which is important in factoring survival, migratory turnover rates, and longevity. Additionally, it allows us to examine bird response to the riparian restoration at CCFS.")

app_intro_text <- p("Two important metrics that we look at are the number of birds caught at the banding station (abundance) and how the number of birds changes throughout the year (phenology. We group birds into three categories based on their migration strategy: summer residents, winter residents, and migrants. Our banding data give us a picture of how the bird populations are changing over time, but what it doesn't do is explain why. To further explore the trends over time, we bring in other datasets and look for correlations in the data. The interactive graphs below show abundance and phenology for three species with each migration strategy, along with options to bring in data from other external factors. (For more information about why these factors might influence bird populations, scroll down.)")

educational_text <- h4("**Coming soon - some great educational text about factors that impact phenology and abundance!**")

page_heading <-fixedRow(
  div(
    column(width = 2, tags$img(src = "sfbbo_logo.jpg", 
                               height = 144, width = 144)),
    column(width = 10, br(), h1("San Francisco Bay Bird Observatory")), ))

in1 <- checkboxGroupInput(
  inputId = 'selected_species', 
  label = 'Select bird species', 
  choices = unique(bird.cap$Species), 
  selected = "BUSH")

in2 <- selectInput(
  inputId = 'selected_parameter',
  label = 'Compare against another factor',
  choices = c("None", unique(bird.weather$param.descr)))

out1 <- textOutput('species_label')
out2 <- textOutput('parameter_label')
out3 <- plotOutput('phenology_plot')
out4 <- plotOutput('weather_plot')
out5 <- plotOutput('weather_correlation_plot')
side <- sidebarPanel(in1, in2)
main <- mainPanel(out1, out2, out3, out4, out5)


ui <- fluidPage(
  title = 'CCFS Alive',
  page_heading,
  sfbbo_intro_text,
  app_intro_text,
  sidebarLayout(side, main),
  educational_text)

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
      labs(title="Average Captures Per Month") +
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
              axis.text.x = element_text(angle=45, vjust=1, hjust=1, color="black", face="bold")
        ) +
        labs(color="Species") +
        labs(title="Captures Per Year") +
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
      if (input[['selected_parameter']] != "None") {
        df <- bird.weather %>% 
          dplyr::filter(param.descr == input[['selected_parameter']] & Species %in% input[['selected_species']])
        ggplot(df, aes(x=value, y = Rate, color=as.factor(Species))) +
          geom_point(size=3) +
          geom_smooth(method = "lm", se = F, size=1.25) +
          ylab("Birds captured/10,000 net hours") +
          xlab(input[['selected_parameter']]) +
          theme_classic(base_size=18, base_line_size = 1.25) +
          labs(color="Species") +
          labs(title="Correlation of Annual Captures and Other Factors") +
          scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
          scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
          theme(axis.text = element_text(color="black", face="bold"))
      } else {
        df <- bird.weather %>% 
          dplyr::filter(Species %in% input[['selected_species']])
        ggplot(df, aes(x=value, y = Rate)) +
          annotate(geom = "text", x = mean(df$value), y = mean(df$Rate), label="Select a weather parameter to plot \nannual capture rates against weather data at CCFS", size=8) +
          ylab("Birds captured/10,000 net hours") +
          xlab("Weather parameter") +
          theme(axis.ticks.x=element_blank(), axis.ticks.y = element_blank(), axis.text = element_blank())
      }
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)