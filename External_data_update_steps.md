# CCFSalive
# Steps for updating external datasets


- Import data from other sources
  - demographic data (such as https://www.bea.gov/resources/for-developers)
  - manual steps starting here: https://www.bea.gov/data
      - select Data by Place
      - County, Metro, and Other Local Areas
      - GDP by County
      - scroll down to Interactive Data and select the only option (GDP by County and Metro Area)
      - Now among the 10 choices only two are by County and Metro area and both have potentially usable data:
      - GDP by County and Metro Area
      - Personal Income and Employment
  
  - For both of the above the process is similar:
      - Select a category of data, for example Farm Income and Expenses
      - County/Next Step
      - California/Next Step
      - select one or more counties (I used Santa Clara and Alameda)
      - select data (I used all data in table)/Next Step
      - Select years (I used all years)
      - Then download data in csv (or other format)
  
  - Repeat for other variables (GDP, Employment)
  
  - This site also has an R interface which I haven't tried yet
  install.packages('bea.R')
    library(bea.R)
  - I registered for an access Key
  beaKey <- 37F8C33E-8FE7-4A33-86CC-E5C2065B0E65
  
  - weather data (such as https://power.larc.nasa.gov/data-access-viewer/)
    - first click Access Data
    - In box on left select:
    - 1. Agroclimatology
    - 2. Daily
    - 3. lat 37.4364
    - 3b. long -121.9272
    - 4. data range 01/01/1981 to 12/31/2019
    - 5. file format = csv (can select more than one format)
    - 6. select parameters ( I selected all the Meteorology paramters except wind speed at 50 meters)
    - 7. Sumbit
    - after a few seconds you get a download button and get a massive excel file where each row is a day
    
        
  - environmental data (such as https://www.epa.gov/enviroatlas/enviroatlas-data)
  
Place all csv files in "data" folder in repository