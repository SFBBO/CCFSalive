##CCFSlive
##Data wrangling

##load libraries
library(stringr) ##required for string manipulation

##load weather data
skip<-which(str_detect(string = read.csv("data/daily_weather_data_1983-2019.csv")[,1], pattern = "END.HEADER"))+1 ##skip all info in header section
weather<-read.csv("data/daily_weather_data_1983-2019.csv", skip = skip)
