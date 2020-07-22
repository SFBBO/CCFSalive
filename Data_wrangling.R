##CCFSlive
##Data wrangling

##load libraries
library(stringr) ##required for string manipulation
library(DBI)
library(RPostgres) ##required to connect to online bird banding database
library(tidyr) ##required for gather

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

##load bird banding data from access query
bird.cap<-read.csv("data/AEJ11.csv"); head(bird.cap)

##load weather data from API
##https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?&request=execute&identifier=SinglePoint&parameters=PRECTOT,RH2M,T2M,T2M_MAX,T2M_MIN,PS,WS2M_MIN,WS2M_MAX,WS10M_MAX,WS10M_MIN,WS2M,WS10M&startDate=1981&endDate=2019&userCommunity=AG&tempAverage=INTERANNUAL&outputList=CSV&lat=37.4364&lon=-121.9272

##load weather data from downloaded csv
skip<-which(str_detect(string = read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv")[,1], pattern = "END.HEADER"))+1 ##skip all info in header section
weather<-read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv", skip = skip)
##get parameter descriptions
param.start<-which(str_detect(string = read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv")[,1], pattern = "Parameter"))+1 ##find where description of parameters start
param.names<-as.character(read.csv("data/POWER_SinglePoint_Interannual_198101_201912_037d44N_121d93W_ae85921f.csv")[param.start:(skip-2),1]) ##get character string of parameter abbreviation and description
##split abbreviation and parameter description into two character strings
param.names<-data.frame(str_split(param.names, pattern = " MERRA2 1/2x1/2 ", simplify = T))
colnames(param.names)<-c("PARAMETER", "param.descr")
##add parameter descriptions to weather data
weather<-inner_join(weather, data.frame(param.names))
##tidy weather data
weather<-weather %>% gather(key = "Month", value = "value", c(JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC, ANN))
write.csv(weather, "data/weather.csv", row.names=F)

##combine weather and bird data for figure 3
