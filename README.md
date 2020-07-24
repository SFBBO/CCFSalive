---
output:
  html_document: default
  pdf_document: default
---
# CCFSalive
Interactive visualization of bird banding data 

The San Francisco Bay Bird Observatory (SFBBO) is a small non-profit based out of Milpitas, California. We are dedicated to the conservation of birds and their habitats through science and outreach. The San Francisco Bay Area is a particularly interesting area for studying socio-environmental issues because of the tension between the area’s explosive population growth and biological importance. One of SFBBO’s greatest strengths is that we have built extensive datasets about local avian populations that span nearly four decades. Datasets of this size are difficult to find and extremely valuable for studying the long-term impacts of human interactions with the environment.

Our goal for the SESYNC Summer Institute is to produce an interactive web interface where people can work with visualizations to explore our long-term data in conjunction with social environmental data that are publicly available (e.g., human population growth, land area use). Visitors would be able to engage with dynamic and continuously updated graphs and maps, with some options to filter and search the data. Not only would this interface be a powerful outreach and education tool, but it would also give people a taste of what analyses are possible and inspire new research and partnership ideas.

## Collaborators
- Gabbie Burns, Waterbird Biologist
- Max Tarjan, Science Director
- Dan Wenny, Landbird Biologist
- Josh Scullen, Science Director

<img src="www/sfbbo_logo.jpg" height="25%" width="40%" />

# Files
- data folder
  - AEJ11.csv: Data query from CCFS microsoft access database. actively used in data wrangling code
  - Regional_econ_demog_....: Econ data that are downloaded from external website and actively used in data wrangling code
  - POWER_SinglePoint_Interannual....: monthly weather data downloaded from external site. actively used in data wrangling code
  - bird.socioenviron.csv: table of annual bird and socioenviron data. output of running data wrangling code
  - bird.cap.csv: table of bird captures by month-year. output of running data wrangling code
  - POWER_SinglePoint_Daily...: daily weather data downloaded from external site. not currently used in any code
  - Regional_farm_econ...: econ data downloaded from external site. not currently used in any code
  - RegionalGDP_2001-2018.csv: econ data downloaded from external site. not currently used in any code
- Data_wrangling.R: code to take in bird and socioenviro data to wrangle data and output simplified csv files for use in shiny app
- Shiny_CCFS.R: cody for shiny app. relies on files in data folder that are derived through data wrangling code
- database_config.csv: file shared with contributors only with connection info for online CCFS database. will not update in Github due to presence in .gitignore file. need to request this file from G Burns to be able to connect to online CCFS database.
- External_data_update_steps.md: description of how to acquire external datasets using the external websites. process should be followed to obtain most recent versions of data periodically. eventually would like to automate this process in data wrangling code

# Project Tasks
## Import data
- Import data from online CCFS database: set up remote connection with log-in credentials saved in gitignore file (Completed by GB)
- Import data from other sources (DW documented process in "external data update steps doc" and added csv files to "data" folder)
  - demographic data (such as https://www.bea.gov/resources/for-developers)
  - weather data (such as https://power.larc.nasa.gov/data-access-viewer/) (MT got query info for automating download in the data wrangling doc)
  - environmental data (such as https://www.epa.gov/enviroatlas/enviroatlas-data)
  
## Wrangle data for visualizations
- wrangle CCFS data from online database to format for plotting, similar to query AEJ11 (in progress by GB)
- wrangle social data for plotting in capture rate versus external data figures (completed by DW and MT)
- process spatial data to look at land use changes versus capture rates (future task for MT)

## Create visualizations
Write code for the following figures:
1. Phenology: captures (y) per month (x) by species (group)
   a. updates needed: add full species name
2. Time series with capture rate (y1) and weather/social data (y2) by year (x) by species (group)
   a. updates needed: add full species name and landscape changes
3. Correlation of capture rate and enviro-social data (population density) by species (group)
   a. Potential update: add linear model stats to graph (R2 and p-value)
5. Bonus: Map of net locations and animations of capture locations over time (future goal)
6. Bonus: Map of land use change categories with graph panel of bird abundance; can manipulate year to change both figures (maybe just side by side early and current years) (future goal)

## Create Shinyapp to bring visualizations online
1. create graphs in shiny (completed by MT)
2. draft text for shiny (completed by GB)
3. create layout for shiny (completed by GB)

# Project Status (7/24/20)
- Shiny_CCFS.R contains a functioning Shiny app that allows viewers to select one or more bird species and on socio-environmental variable. 
  - Graphs include average captures per month, total captures per year (optionally graphed with socio-enviro factor), and a correlation between captures per year and the chosen socio-enviro factor.
  - Page includes some placeholder text above and below the graphs to provide more context/education
  - Future ideas include having the sidebar scroll with graphs (probably doable, but not while we're using the sidebarpanel layout) and building grouping/filtering tools to make it usable when we expand from 9 species to ~200

- Data_wrangling.R contains code for processing CCFS and external weather+economic data from CSV files (which are in the data folder). There are some stubs for where the wrangling could be connected directly to data sources.

- postgres_import branch in git has WIP code for extracting CCFS data from the banding database

- External_data_update_steps.md outlines process for getting our external data from the respective sources. Goal is to eventually have that process as automated as possible