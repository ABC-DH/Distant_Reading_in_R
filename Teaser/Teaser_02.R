# Libraries
install.packages("ggplot2")
install.packages("igraph")
install.packages("ggridges")
install.packages("visNetwork")
install.packages("tidyverse")
install.packages("leaflet")
install.packages("sp")
install.packages("sf")
install.packages("igraph")

################################################################################
##################### GRAPHS ###################################################
################################################################################

# library
library(ggridges)
library(ggplot2)

cronologia <- read.csv("Graphs/data/eneko.csv")

# basic example
ggplot(cronologia, aes(x = anno, y = tematica, fill = tematica)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")


################################################################################
##################### NETWORK ##################################################
################################################################################

################
## visNetwork ##
################

library(visNetwork)
library(tidyverse)

# Load data
nodes <- read_csv("Network/data/nodes.csv")
edges <- read_csv("Network/data/edges.csv")

# Simple interactive plot
visNetwork(nodes, edges, width = "100%") %>%
  visGroups(groupname = "A", color = "red") %>%
  visGroups(groupname = "B", color = "lightblue") %>%
  visLegend(width = 0.1, position = "right", main = "Group")


# visNetwork edge width plot
visNetwork(nodes,
           edges,
           width = "100%") %>%

  visIgraphLayout(layout = "layout_with_fr") %>%

  visEdges(arrows = "middle")

################################################################################
##################### MAPS #####################################################
################################################################################

# Load the required libraries for mapping and spatial data manipulation
library(leaflet)
library(sp)
library(sf)

# Load the shapefile and name it 'countries'
countries <- st_read('Mapping/data/shp/countries/countries-polygon.shp')

# Read the CSV file containing pizzeria data
data <- read.csv("Mapping/data/csv/pizzamap.csv")

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