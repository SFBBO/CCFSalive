##CCFSlive
##Data wrangling

##load libraries
library(stringr) ##required for string manipulation
library(DBI)
library(RPostgreSQL)
library(dplyr)
library(tidyr)

# Extract CCFS data from the banding database ----

# Read in DB connection details
db_details <- read.csv("database_config.csv")

# Connect to the database
con <- dbConnect(dbDriver("PostgreSQL"),dbname = db_details$Database, 
                 host = db_details$Host,
                 port = db_details$Port,
                 user = db_details$User,
                 password = db_details$Password)

# Read in species code and capture date
annual_birds <- dbGetQuery(con, statement = "SELECT species_code, EXTRACT(year from capture_date) AS capture_year, COUNT(species_code) FROM banding.banding_records GROUP BY species_code, capture_year")

# Filter to our curated list of species and years ----
annual_birds <- annual_birds %>% filter(species_code %in% c("BEWR", "BUSH", "CALT", "COYE", "FOSP", "HETH", "RCKI", "WEFL", "WIWA"))
annual_birds <- annual_birds %>% filter(capture_year > 1995, capture_year < 2019 )

annual_birds <- annual_birds %>% pivot_wider(names_from = species_code, values_from = count, values_fill=0)
annual_birds <- annual_birds[order(annual_birds$capture_year),]

# Read in the net hours per year
net_hours <- dbGetQuery(con, statement = "SELECT trap_hours, EXTRACT(year from banding_date) AS banding_year FROM banding.net_hours WHERE location = 'CC01' AND trap_type = 'N'")

net_hours <- net_hours %>% group_by(banding_year) %>% summarise(sum(trap_hours))

dbDisconnect(con)


##load weather data ----
skip<-which(str_detect(string = read.csv("data/daily_weather_data_1983-2019.csv")[,1], pattern = "END.HEADER"))+1 ##skip all info in header section
weather<-read.csv("data/daily_weather_data_1983-2019.csv", skip = skip)
