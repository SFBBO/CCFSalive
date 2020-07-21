# CCFSalive
# Steps for updating external datasets


- Import data from other sources
  - demographic data (such as https://www.bea.gov/resources/for-developers)
  - manual method start here: https://www.bea.gov/data
      -select Data by Place
      -County, Metro, and Other Local Areas
      -GDP by County
      -scroll down to Interactive Data and select the only option (GDP by County and Metro Area)
      -Now among the 10 choices only two are by County and Metro area and both have potentially usable data:
      -GDP by County and Metro Area
      -Personal Income and Employment
  
  - For both of the above the process is similar:
      -Select a category of data, for example Farm Income and Expenses
      -County/Next Step
      -California/Next Step
      -select one or more counties (I used Santa Clara and Alameda)
      -select data (I used all data in table)/Next Step
      -Select years (I used all years)
      -Then download data in csv (or other format)
  
  -Repeat for other variables (GDP, Employment)
  
  -This site also has an R interface which I haven't tried yet
  install.packages('bea.R')
    library(bea.R)
  I registered for an access Key
  beaKey <- 37F8C33E-8FE7-4A33-86CC-E5C2065B0E65
  
  - weather data (such as https://power.larc.nasa.gov/data-access-viewer/)
  - environmental data (such as https://www.epa.gov/enviroatlas/enviroatlas-data)
  
Place all csv files in "data" folder in repository