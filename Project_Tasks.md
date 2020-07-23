# CCFSalive
# Project Tasks

## Import data
- Import data from online CCFS database: set up remote connection with log-in credentials saved in gitignore file (GB)
- Import data from other sources (DW will document process in "external data update steps doc" and add csv files to "data" folder)
  - demographic data (such as https://www.bea.gov/resources/for-developers)
  - weather data (such as https://power.larc.nasa.gov/data-access-viewer/) (MT got query info for automating download in the data wrangling doc)
  - environmental data (such as https://www.epa.gov/enviroatlas/enviroatlas-data)
  
## Wrangle data for visualizations
- wrangle CCFS data from online database to format in csv files (GB)
- wrangle weather csv data for plotting fig 3 (MT)
- wrangle social data (DW)

## Create visualizations
Write code for the following figures:
1. Phenology: captures (y) per month (x) by species (group)
2. Time series with capture rate (y1) and weather (y2) by year (x) by species (group)
3. Time series with capture rate (y1) and social data (y2) by year (x) by species (group)
4. Correlation of capture rate and social data (population density) by species (group)
5. Bonus: Map of net locations and animations of capture locations over time
6. Bonus: Map of land use change categories with graph panel of bird abundance; can manipulate year to change both figures
7. side by side land use maps of early and recent year with bar graph of species capture rates in early versus recent year (2001 first usgs land use survey and then every 5 years- 4 surveys in relevant timeframe)

## Create Shinyapp to bring visualizations online
1. create graphs in shiny
  a. weather graph - add option to plot no weather data
2. draft text for shiny
3. research and decide on layout for shiny (GB)