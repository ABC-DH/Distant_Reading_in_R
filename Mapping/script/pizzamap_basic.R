## Install necessary packages for the project
##install.packages("leaflet")
##install.packages("sp")
##install.packages("sf")

# Load the required libraries for mapping and spatial data manipulation
library(leaflet)
library(sp)
library(sf)

# Load the shapefile and name it 'countries'
countries <- st_read('data/shp/countries/countries-polygon.shp')

# Read the CSV file containing pizzeria data
data <- read.csv("data/csv/pizzamap.csv")

# Initialize the leaflet map with the shapefile data
map <- leaflet(countries) %>% 
  ## Add the base map layer
  ##addTiles() %>%
  ## Example of a base map using OpenStreetMap tiles
  addProviderTiles(providers$OpenStreetMap)  %>% 
  
  ## Another example of a base map using Stamen Toner tiles (commented out)
  ##addProviderTiles(providers$Stamen.Toner)  %>% 
  
  ## Set the initial view of the map (center and zoom level)
  setView(lng = 60.27444399596726, 
          lat = 27.808314896631217, 
          zoom = 2 ) %>%
  
  ## Add markers for each pizzeria using the latitude and longitude columns from the CSV
  addMarkers(data = data,
             lng = ~lng, 
             lat = ~lat,
             group = "Pizzerias",
             popup = ~paste("<b>", name, "</b>" ,"<br>", "<br>",
                            "City:", "<b>", city,"</b>", " in" , "<b>", country, "</b>", "<br>",
                            "Open on:", "<b>", date, "</b>", "</b>","<br>",
                            "You can find here ", "<b>", pizzas, "</b>", " pizzas","<br>",
                            "The special pizza is the:", "<b>", pizza_special, "</b>", "<br>",
                            "Take away:", "<b>", take_away, "</b>", "<br>",
                            "They sell other things?", "<b>", other_stuff, "</b>",
                            sep = " ")) %>%
  
  ## Add a polygon layer representing countries with a label
  addPolygons(data = countries, 
              color = "#008000", 
              weight = 1, 
              smoothFactor = 0,
              group = "Countries",
              label = ~paste(countries$COUNTRY, ": ", countries$number, " pizzerias")) %>%
  
  ## Add a legend to the top right of the map with custom colors and labels
  addLegend("topright", 
            colors = c("transparent"), 
            labels = c("Giovanni Pietro Vitali - giovannipietrovitali@gmail.com"),
            title = "Pizza Map (Learn R to make maps):") %>%
  
  ## Add a mini map to the bottom left corner of the main map
  addMiniMap("bottomleft") %>%
  
  ## Add layer control allowing users to toggle between overlay groups
  addLayersControl(overlayGroups = c("Pizzerias", "Countries"),
                   options = layersControlOptions(collapsed = TRUE))

## Render the map
map


                                                ##################
                                                ## Explanation: ##
                                                ##################

##  Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries leaflet, sp, and sf.

## Load libraries: The library commands load these packages into the R session, enabling their functionalities.

## Load the shapefile: The st_read function from the sf package reads a shapefile containing country polygons and stores it in the variable countries.

## Read the CSV file: The read.csv function reads data from a CSV file containing pizzeria information and stores it in the data variable.

## Initialize the map: The leaflet function initializes a leaflet map using the countries data.

## Add base map layer: addProviderTiles adds a base map layer from OpenStreetMap. The other commented out options show alternative base map providers.

## Set initial view: setView sets the initial center (longitude and latitude) and zoom level of the map.

## Add pizzeria markers: addMarkers adds markers for each pizzeria with popups containing details from the CSV file.

## Add country polygons: addPolygons adds country polygons with a specified color, weight, and labels indicating the number of pizzerias.

## Add a legend: addLegend adds a custom legend to the top right corner of the map.

## Add a mini map: addMiniMap adds a smaller overview map to the bottom left corner.

## Add layer control: addLayersControl adds controls to toggle visibility of different map layers.

## Render the map: Finally, map renders the map with all the specified layers and controls.
