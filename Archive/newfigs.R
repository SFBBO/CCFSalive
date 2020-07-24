getwd()
setwd("/home/dan/SFBBO/CCFS")

##add packages needed to get the data and make the graph
library (data.table)
library(ggplot2)
library(dplyr)

##figure 1 by month
##read the data into environment

capdata <- fread('data/AEJ11.csv')

##assign species code chosen in app to 'birdsp' 
birdsp <- "WIWA"

##summarize data for figure
bymo <- capdata %>% filter(SpeciesCode == birdsp) %>%
    mutate(Month = match(MonthName, month.abb)) %>%
    group_by(Month)  %>%
    summarise(avg = mean(Rate), sd = sd(Rate))
##could add std dev for error bars, sem would be better but tricky to get

##make graph
qplot(Month, avg, data = bymo) +
  geom_bar(stat = "identity", fill = "white", color = "black") +
  labs(x = "Month", y = "Avg capture rate", title = birdsp) +
  theme_classic()
##need to adjust x-axis but this is close


##figure 2 by year
capdata <- fread('data/AEJ11.csv')

##assign species code to 'birdsp' 
birdsp <- "WIWA"

##summarize data for graph
byyr <- capdata %>% filter(SpeciesCode == birdsp) %>%
    mutate(year = as.integer(substr(Month, nchar(Month)-3, 
                                    nchar(Month)))) %>%
    group_by(year)  %>%
    summarise(capture_rate = sum(CountOfCleanID)/sum(NH)*10000)

##make figure
qplot(year, capture_rate, data = byyr) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_classic() +
  labs(x = "Year", y = "annual capture rate", title = birdsp)
##would be nice to have full species name





##test2 <- as.Date(test$y1, format = "%d %b %Y")
##test <- mutate(capdata, y1 = paste('01', Month))  
##test3 <- mutate(capdata, y1 = as.Date(paste('01', Month)), format = "%d %b %Y")
##year <- as.integer(substr(capdata$Month, nchar(capdata$Month)-3, nchar(capdata$Month)))


