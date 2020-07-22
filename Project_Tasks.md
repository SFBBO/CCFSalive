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

## Create visualizations
Write code for the following figures:
1. Annual capture rate (y) by year (x) by species (group)
2. Phenology: captures (y) per month (x) by species (group)
3. Time series with capture rate (y1) and weather (y2) by year (x) by species (group)
4. Bonus: Map of net locations and animations of capture locations over time
5. Bonus: Map of land use change categories with graph panel of bird abundance; can manipulate year to change both figures

DW will add existing figure code to a R file for figs 1 and 2

## Create Shinyapp to bring visualizations online