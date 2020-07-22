##CCFSlive
##Data wrangling

##load libraries
library(stringr) ##required for string manipulation
library(DBI)
library(RPostgres) ##required to connect to online bird banding database

# Extract CCFS data from the banding database ----
# Read in DB connection details
db_details <- read.csv("database_config.csv", stringsAsFactors = FALSE)

# Connect to a specific postgres database
con <- dbConnect(RPostgres::Postgres(),
                 dbname = db_details$Database, 
                 host = db_details$Host,
                 port = db_details$Port,
                 user = db_details$User,
                 password = db_details$Password)

birds_test <- dbGetQuery(con, statement = paste("SELECT * FROM banding.banding_records LIMIT 10"));
dbDisconnect(con)

##load weather data from API
##https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?&request=execute&identifier=SinglePoint&parameters=PRECTOT,RH2M,T2M,T2M_MAX,T2M_MIN,PS,WS2M_MIN,WS2M_MAX,WS10M_MAX,WS10M_MIN,WS2M,WS10M&startDate=1981&endDate=2019&userCommunity=AG&tempAverage=INTERANNUAL&outputList=CSV&lat=37.4364&lon=-121.9272

##load weather data from downloaded csv
skip<-which(str_detect(string = read.csv("data/daily_weather_data_1983-2019.csv")[,1], pattern = "END.HEADER"))+1 ##skip all info in header section
weather<-read.csv("data/daily_weather_data_1983-2019.csv", skip = skip)
