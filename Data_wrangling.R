##CCFSlive
##Data wrangling

##load libraries
library(stringr) ##required for string manipulation
library(DBI)
library(RPostgreSQL)

# Extract CCFS data from the banding database ----
# Read in DB connection details
db_details <- read.csv("database_config.csv")

# Connect to a specific postgres database
con <- dbConnect(dbDriver("PostgreSQL"),dbname = db_details$Database, 
                 host = db_details$Host,
                 port = db_details$Port,
                 user = db_details$User,
                 password = db_details$Password)

birds_test <- dbGetQuery(con, statement = paste("SELECT * FROM banding.banding_records LIMIT 10"));
dbDisconnect(con)


##load weather data
skip<-which(str_detect(string = read.csv("data/daily_weather_data_1983-2019.csv")[,1], pattern = "END.HEADER"))+1 ##skip all info in header section
weather<-read.csv("data/daily_weather_data_1983-2019.csv", skip = skip)
