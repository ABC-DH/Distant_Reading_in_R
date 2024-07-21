## Install necessary packages for the project
##install.packages("leaflet")
##install.packages("sp")
##install.packages("sf")
##install.packages("RColorBrewer")
##install.packages("leaflet.extras")
##install.packages("leaflet.minicharts")
##install.packages("htmlwidgets")
##install.packages("raster")
##install.packages("mapview")
##install.packages("leafem")
##install.packages("leafpop")
##install.packages("htmltools")

## Call the libraries needed for the project
library(leaflet)
library(sp)
library(sf)
library(RColorBrewer)
library(leaflet.extras)
library(leaflet.minicharts)
library(htmlwidgets)
library(raster)
library(mapview)
library(leafem)
library(leafpop)
library(htmltools)

## PART 1 - IN THIS PART THE CODE READS THE FILES AND ATTRIBUTES COLORS AND ICONS TO ELEMENTS

## Read the shapefile containing country polygons
countries <- st_read('data/shp/countries/countries-polygon.shp')

## Create a color palette for the shapefile data based on the number of pizzerias
palette_countries <- colorNumeric(palette = "YlOrRd", domain = countries$number)

## Read the CSV file containing pizzeria data
data <- read.csv("data/csv/pizzamap.csv")

## Create HTML popup content for the pizzeria markers
content <- paste(sep = "<br/>",
                 paste0("<div class='leaflet-popup-scrolled' style='max-width:200px;max-height:200px'>"),
                 paste0("<b>", data$name, "</b>", " in ", data$city, " (", data$country, ")"),
                 paste0("They have ","<b>", data$pizzas, "</b>", " pizzas", " and ", "<b>", data$places_circa, "</b>", " places"),
                 paste0(data$image),
                 paste0("<small>", "Takeaway: ", "<b>", data$take_away, "</b>", "</small>"),
                 paste0("</div>"))

## Create a color palette for the pizzeria data based on the average price of pizzas
palette_data <- colorNumeric("YlGn", data$price_euro_average)

## Create an icon for pizzerias using an image link
url <- "http://miam-images.m.i.pic.centerblog.net/o/b0cb1d85.png"
pizza_icon <- makeIcon(url, url, 40, 40)

## PART 2 - IN THIS PART THE CODE ADDS ELEMENTS ON THE MAP LIKE POLYGONS, POINTS AND IMAGES.

## Initialize the leaflet map
map <- leaflet() %>%
  ## Add the base map layer using CartoDB Positron tiles
  ##addTiles(tile)        %>%
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  ## Add a zoom reset button
  addResetMapButton() %>%
  ## Add a minimap to better navigate the map
  addMiniMap() %>%
  ## Add coordinates reader
  leafem::addMouseCoordinates() %>%
  ## Set the initial view of the map (center and zoom level)
  setView(lng = 60.27444399596726, 
          lat = 27.808314896631217, 
          zoom = 2 ) %>%
  
  ## Add country polygons with specified colors and options
  addPolygons(data = countries,
              fillColor = ~palette_countries(countries$number),
              weight = 0.1,
              color = "brown",
              dashArray = "3",
              opacity = 0.7,
              stroke = TRUE,
              fillOpacity = 0.5,
              smoothFactor = 0.5,
              group = "Countries",
              label = ~paste("In", COUNTRY, "there are", number, " pizzerias", sep = " "),
              highlightOptions = highlightOptions(
                weight = 0.6,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE)) %>%
  
  ## Add a legend for the country polygons
  addLegend("bottomleft", 
            pal = palette_countries, 
            values = countries$number,
            title = "Pizzerias by country:",
            labFormat = labelFormat(suffix = " pizzerias"),
            opacity = 1,
            group = "Countries") %>%
  
  ## Add markers for pizzerias with clustering options
  addAwesomeMarkers(data = data, 
                    lng = ~lng,
                    lat = ~lat, 
                    popup = c(content), 
                    group = "Pizzerias",
                    options = popupOptions(maxWidth = 100, maxHeight = 150), 
                    clusterOptions = markerClusterOptions()) %>%
  
  ## Add circle markers for pizzerias based on price with quantitative options
  addCircleMarkers(data = data, 
                   lng = data$lng,
                   lat = data$lat,
                   fillColor = ~palette_data(price_euro_average),
                   color = "black",
                   weight = 1,
                   radius = ~sqrt(data$price_euro_average) * 3,
                   stroke = TRUE,
                   fillOpacity = 0.5,
                   group = "By price",
                   label = ~paste("In the pizzeria ", data$name, 
                                  " pizza costs approximately ",
                                  data$price_euro_average, 
                                  " euros")) %>%
  
  ## Add a legend for the price-based circle markers
  addLegend("bottomleft", 
            pal = palette_data, 
            values = data$price_euro_average,
            title = "Pizzerias ordered by prices:",
            labFormat = labelFormat(suffix = " euros"),
            opacity = 1,
            group = "By price") %>%
  
  ## Add markers with special pizza icons
  addMarkers(data = data,
             lng = ~lng, 
             lat = ~lat, 
             icon = pizza_icon,
             group = "Pizza Marker",
             popup = ~paste0(name)) %>%
  
  ## Add a legend with the credits
  addLegend("topright", 
            colors = c("transparent"),
            labels=c("Giovanni Pietro Vitali - giovannipietrovitali@gmail.com"),
            title="Pizza Map (Learn R to make maps): ") %>%
  
  ## PART 3 - IN THIS PART THE CODE MANAGES THE LAYERS' SELECTOR
  
  ## Add the layer selector for navigating map options
  addLayersControl(baseGroups = c("Pizzerias",
                                  "Empty layer"),
                   overlayGroups = c("Countries",
                                     "By price",
                                     "Pizza Marker"),
                   options = layersControlOptions(collapsed = TRUE)) %>%
  
  ## Hide the layers that users can choose to display
  hideGroup(c("Empty",
              "Countries",
              "By price",
              "Pizza Marker"))

## Show the map  
map

                                                ##################
                                                ## Explanation: ##
                                                ##################

## Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries.

## Load libraries: The library commands load these packages into the R session.

## Load the shapefile: The st_read function reads a shapefile containing country polygons and stores it in the variable countries.

## Create color palette for shapefile data: colorNumeric creates a color palette for the country data based on the number of pizzerias.

## Read the CSV file: The read.csv function reads data from a CSV file containing pizzeria information and stores it in the data variable.

## Create HTML popup content: The paste function creates HTML content for the pizzeria markers' popups.

## Create color palette for pizzeria data: colorNumeric creates a color palette for the pizzeria data based on the average price of pizzas.

## Create pizza icon: The makeIcon function creates an icon for the pizzerias using an image link.

## Initialize the map: The leaflet function initializes a leaflet map.

## Add base map layer: addProviderTiles adds a base map layer from CartoDB Positron.

## Add zoom reset button: addResetMapButton adds a button to reset the zoom level of the map.

## Add minimap: addMiniMap adds a smaller overview map to the main map.

## Add coordinates reader: leafem::addMouseCoordinates adds a coordinates reader to the map.

## Set initial view: setView sets the initial center (longitude and latitude) and zoom level of the map.

## Add country polygons: addPolygons adds country polygons with specified colors, weights, and options.

## Add legend for country polygons: addLegend adds a legend to the bottom left corner for the country polygons.

## Add pizzeria markers: addAwesomeMarkers adds markers for each pizzeria with clustering options.

## Add circle markers based on price: addCircleMarkers adds circle markers for pizzerias based on price with quantitative options.

## Add legend for price-based circle markers: addLegend adds a legend to the bottom left corner for the price-based circle markers.

## Add markers with pizza icons: addMarkers adds markers with special pizza icons.

## Add legend with credits: addLegend adds a custom legend with credits to the top right corner of the map.

## Manage layers' selector: addLayersControl adds a layer selector for navigating map options.

## Hide selectable layers: hideGroup hides certain layers that users can choose to display.

## Render the map: map renders the map with all the specified layers and controls.

