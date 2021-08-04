##install.packages("leaflet")
##install.packages("sp")
##install.packages("rgdal")
##install.packages("RColorBrewer")
##install.packages("leaflet.extras")
##install.packages("leaflet.minicharts")
##install.packages("htmlwidgets")
##install.packages("raster")
##install.packages("mapview")
##install.packages("leafem")

## Call the libraries
library(leaflet)
library(sp)
library(rgdal)
library(RColorBrewer)
library(leaflet.extras)
library(leaflet.minicharts)
library(htmlwidgets)
library(raster)
library(mapview)
library(leafem)
library(leafpop)
library(sf)
library(htmltools)

## PART 1 - IN THIS PART THE CODE READS THE FILES AND ATTRIBUTES COLORS AND ICONS TO ELEMENTS

## Read the shapefile
countries <- readOGR('data/shp/countries/countries.shp')
## Create the palette of colors for the shapefiles
palette_countries <- colorNumeric(palette = "YlOrRd", domain = countries$number)

## Read the csv
data <- read.csv("data/csv/pizzamap.csv")
## Create a html popup
content <- paste(sep = "<br/>",
                        paste0("<div class='leaflet-popup-scrolled' style='max-width:200px;max-height:200px'>"),
                        paste0("<b>", data$name, "</b>", " in ", data$city, " (", data$country, ")"),
                        paste0("<b>", "They have ", data$pizzas, " pizzas", " and ", data$places_circa, " places", "</b>"),
                        paste0(data$url_img),
                        paste0("<small>", "Takeaway: ", data$take_away,"</small>"),
                        paste0("</div>"))
## Create the palette of colors
palette_data <- colorNumeric("YlGn", data$price_euro_average)

## Create an image through the use of a link
url <- "http://miam-images.m.i.pic.centerblog.net/o/b0cb1d85.png"
## url <- data$url
pizza_icon <-  makeIcon(url, url, 40, 40)


## PART 2 - IN THIS PART THE CODE ADDS ELEMENT ON THE MAP LIKE POLYGONS, POINTS AND IMAGES.

map <- leaflet() %>%
  ## Basemap
  ##addTiles()        %>%
  addProviderTiles(providers$CartoDB.Positron)  %>%
  
  ## Add a zoom reset button
  #addResetMapButton() %>%
  ## Add a Minimap to better navigate the map
  #addMiniMap() %>%
  ## Add a coordinates reader
  #leafem::addMouseCoordinates() %>%
  ## define the view
  setView(lng = 3.721387, 
          lat = 45.546099, 
          zoom = 3 ) %>%
  
  ## Add the polygons of the shapefiles
  addPolygons(data = countries, 
              stroke = FALSE, 
               smoothFactor = 0.2, 
               fillOpacity = 1,
               color = ~palette_countries(number),
               group = "Countries",
               label = ~paste("In", titles, "there are", number, " pizzerias", sep = " ")) %>%
  
  ## Add a legend with the occurrences of the toponyms according to the macro areas
  
  #addLegend("bottomleft", 
  #pal = palette_countries,
  #values = countries$number,
  #title = "Pizzerias by country:",
  #labFormat = labelFormat(suffix = " pizzerias"),
  #opacity = 1,
  #group = "Countries") %>%
  
  ## Add Markers with clustering options
 #addAwesomeMarkers(data = data, 
#                   lng = ~lng,
#                   lat = ~lat, 
#                   popup = c(content), 
#                   group = "Pizzerias", 
#                   options = popupOptions(maxWidth = 100, maxHeight = 150), 
#                   clusterOptions = markerClusterOptions())%>%
  
  ## Add Circles with quatitative options
  #addCircleMarkers(data = data, 
   #                lng = data$lng, 
    #               lat = data$lat,
     #              fillColor = ~palette_data(price_euro_average),
      #             color = "black",
       #            weight = 1,
        #           radius = ~sqrt(data$price_euro_average) * 3,
         #          stroke = TRUE,
          #         fillOpacity = 0.5,
           #        group = "By price",
            #       label = ~paste("In the pizzeria ", data$name, 
             #                     " pizza costs approximately ",
              #                    data$price_euro_average, 
               #                   " euros")) %>%
  
  ## Add a legend with the occurrences of the toponyms according to the macro areas
  #addLegend("bottomleft", 
   #         pal = palette_data, 
    #        values = data$price_euro_average,
     #       title = "Pizzerias ordered by prices:",
      #      labFormat = labelFormat(suffix = " euros"),
       #     opacity = 1,
        #    group = "By price") %>%
  
## Add Markers with special icons
  #addMarkers(data = data,
   #          lng = ~lng, 
    #         lat = ~lat, 
     #        icon = pizza_icon,
      #       group = "Pizza Marker",
       #      popup = ~paste0(name)) %>%
  
  ## Add a legend with the credits
  addLegend("topright", 
            
            colors = c("trasparent"),
            labels=c("Giovanni Pietro Vitali - giovannipietrovitali@gmail.com"),
            
            title="Pizza Map: ") %>%
  
 
  ## PART 3 - IN THIS PART THE CODE MANAGE THE LAYERS' SELECTOR
  
  ## Add the layer selector which allows you to navigate the possibilities offered by this map
  
  addLayersControl(baseGroups = c("Pizzerias",
                                  "Empty layer"),
                   
                   overlayGroups = c("Countries",
                                     "By price",
                                     "Pizza Marker"),
                   
                   options = layersControlOptions(collapsed = TRUE)) %>%
  
  ## Hide the layers that the users can choose as they like
  hideGroup(c("Empty",
              "Countries",
              "By price",
              "Pizza Marker"))

## Show the map  
map

