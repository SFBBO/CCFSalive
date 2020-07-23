# CCFSalive
Interactive visualization of bird banding data 

The San Francisco Bay Bird Observatory (SFBBO) is a small non-profit based out of Milpitas, California. We are dedicated to the conservation of birds and their habitats through science and outreach. The San Francisco Bay Area is a particularly interesting area for studying socio-environmental issues because of the tension between the area’s explosive population growth and biological importance. One of SFBBO’s greatest strengths is that we have built extensive datasets about local avian populations that span nearly four decades. Datasets of this size are difficult to find and extremely valuable for studying the long-term impacts of human interactions with the environment.

Our goal for the SESYNC Summer Institute is to produce an interactive web interface where people can work with visualizations to explore our long-term data in conjunction with social environmental data that are publicly available (e.g., human population growth, land area use). Visitors would be able to engage with dynamic and continuously updated graphs and maps, with some options to filter and search the data. Not only would this interface be a powerful outreach and education tool, but it would also give people a taste of what analyses are possible and inspire new research and partnership ideas.

## Collaborators
- Gabbie Burns, Waterbird Biologist
- Max Tarjan, Science Director
- Dan Wenny, Landbird Biologist
- Josh Scullen, Science Director

<img src="sfbbo logo.jpg" height="25%" width="40%" />

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