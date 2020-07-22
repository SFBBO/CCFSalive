#check where you are
getwd()

##add packages needed to get the data and make the graph
library (data.table)
library(ggplot2)

##figure 1
##read the data into environment
year <- fread('data/rate_year.csv')

##make plot with simple linear regression line
qplot(year, COYErate, data = year, geom = c("point", "smooth"),method = "lm")

##in shiny app have species (in the above case COYErate) be a variable

##figure 2
month <- fread('data/AvgRate_month.csv')

qplot(Month, COYE, data = month) + 
  geom_bar(stat = "identity", fill = "white", color = "black") +
  labs(x = "Month", y = "Avg capture rate")


