##CCFSlive
##Data wrangling

##load libraries
library(stringr) ##required for string manipulation
library(DBI)
library(dplyr)
library(tidyr)
library(RPostgres) ##required to connect to online bird banding database

# # Extract CCFS data from the banding database ----
# 
# # Read in DB connection details
# db_details <- read.csv("database_config.csv", stringsAsFactors = FALSE)
# 
# # Connect to the database
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = db_details$Database, 
#                  host = db_details$Host,
#                  port = db_details$Port,
#                  user = db_details$User,
#                  password = db_details$Password)
# 
# # Read in species code and capture date
# annual_birds <- dbGetQuery(con, statement = "SELECT species_code, EXTRACT(year from capture_date) AS capture_year, COUNT(species_code) FROM banding.banding_records GROUP BY species_code, capture_year")
# net_hours <- dbGetQuery(con, statement = "SELECT trap_hours, EXTRACT(year from banding_date) AS banding_year FROM banding.net_hours WHERE location = 'CC01' AND trap_type = 'N'")
# valid_nets <- dbGetQuery(con, statement = "SELECT DISTINCT trap_site from banding.valid_trap_location WHERE annual_report = true")
# dbDisconnect(con)
# 
# # Construct list of annual rates for our target species and years
# annual_birds <- annual_birds %>% filter(species_code %in% c("BEWR", "BUSH", "CALT", "COYE", "FOSP", "HETH", "RCKI", "WEFL", "WIWA"))
# annual_birds <- annual_birds %>% filter(capture_year > 1995, capture_year < 2018 )
# 
# # Filter out nets that are not currently in operation
# 
# # Pivot and sort the data
# annual_birds <- annual_birds %>% pivot_wider(names_from = species_code, values_from = count, values_fill=0)
# annual_birds <- annual_birds[order(annual_birds$capture_year),]

# Standardize on number of net_hours
# net_hours <- net_hours %>% group_by(banding_year) %>% summarise(sum(trap_hours))

##load weather data from API
##https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?&request=execute&identifier=SinglePoint&parameters=PRECTOT,RH2M,T2M,T2M_MAX,T2M_MIN,PS,WS2M_MIN,WS2M_MAX,WS10M_MAX,WS10M_MIN,WS2M,WS10M&startDate=1981&endDate=2019&userCommunity=AG&tempAverage=INTERANNUAL&outputList=CSV&lat=37.4364&lon=-121.9272

##load weather data from downloaded csv
skip<-which(str_detect(string = read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv")[,1], pattern = "END.HEADER"))+1 ##skip all info in header section
weather<-read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv", skip = skip)
