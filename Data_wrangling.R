##CCFSlive
##Data wrangling

##load libraries
library(stringr) ##required for string manipulation
library(DBI)
library(RPostgres) ##required to connect to online bird banding database
library(tidyr) ##required for gather
library(dplyr)

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
bird.cap<-read.csv("data/AEJ11.csv", stringsAsFactors = F); head(bird.cap)
colnames(bird.cap)<-c("Monthyear", "Species", "Cap", "Month", "NH", "Rate")
##extract year
bird.cap$Year<-as.numeric(str_split(bird.cap$Monthyear, pattern = " ", simplify = T)[,2])
##summarize to get capture rate by species and year
bird.cap.yr<-bird.cap %>% group_by(Species, Year) %>% summarise(Rate=sum(Cap)/sum(NH)*10000) %>% data.frame()

write.csv(bird.cap, "data/bird.cap.csv", row.names=F)

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
weather.yr<-subset(weather, Month=="ANN", select = -c(LAT, LON, Month))

##import economic data and trim off extra top rows
econ <- read.csv("data/Regional_econ_demog_1969-2018.csv", skip = 4, header = T)
##select specific rows with the variables and columns with the years we want
econ <- econ %>% filter(GeoName=="Santa Clara, CA", LineCode %in% c(100, 110, 220, 230, 270, 280)) %>% select(c("Description", starts_with("X")))
##attempt to select columsn with 4 sequential digits in the name
#econ <- econ %>% filter(GeoName=="Santa Clara, CA", LineCode %in% c(100, 110, 220, 230, 270, 280)) %>% select(contains("\\d{4}"))
names(econ)
##remove whitespace from description
econ$Description <- as.character(econ$Description) %>% str_replace_all(pattern = "[^[:alpha:]]", replacement = " ") %>% str_trim()
##remove X from date headers
colnames(econ)<-c("param.descr", str_sub(colnames(econ)[2:length(colnames(econ))], start=2))
##gather values
econ <- gather(data = econ, key = "YEAR", value = "value", 2:ncol(econ))
econ <- data.frame(PARAMETER=NA, subset(econ, select=c("YEAR", "param.descr", "value")))

##combine with weather data
socioenviro<-rbind(weather.yr, econ)
socioenviro$YEAR<-as.numeric(socioenviro$YEAR)

##combine socio-environ and bird data for figure 3
bird.socioenviro<-inner_join(bird.cap.yr, socioenviro, by = c("Year"= "YEAR"))
write.csv(bird.socioenviro, "data/bird.socioenviro.csv", row.names=F)
