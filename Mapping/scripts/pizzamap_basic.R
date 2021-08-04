##install.packages("leaflet")
##install.packages("sp")
##install.packages("rgal")

library(leaflet)
library(sp)
library(rgdal)

## Load the shapefile and name it 
countries <- readOGR('data/shp/countries/countries.shp')

## Read the csv
data <- read.csv("data/csv/pizzamap.csv")

## Loading the base map
map <- leaflet(countries) %>% 
  ## Basemap
  ##addTiles() %>%
  ## Example of basemap
  addProviderTiles(providers$OpenStreetMap)  %>% 
  
  ## Second example of basemap
  ##addProviderTiles(providers$Stamen.Toner)  %>% 
  
  ## Selecting the map focus and zoom for users
  ##setView(lng = -36.80, 
  ##      lat = 22.98, 
  ##    zoom = 1 ) %>%
  
  ## Add the markers on the locations indicated by the lat & Lng columns with the popups
  addMarkers(data = data,
             lng = ~lng, 
             lat = ~lat,
             group = "Pizzerias",
             popup = ~paste("<b>", name, "</b>" ,"<br>", "<br>",
                            "City:", "<b>", city,"</b>", " in" , "<b>", country, "</b>", "<br>",
                            "Open on:", "<b>", date_viz, "</b>", "</b>","<br>",
                            "You can find here ", "<b>", pizzas, "</b>", " pizzas","<br>",
                            "The special pizza is the:", "<b>", pizza_special, "</b>", "<br>",
                            "Take away:", "<b>", take_away, "</b>", "<br>",
                            "They sell other thins?", "<b>", other_stuff, "</b>",
                            sep = " ")) %>%
  
  ## Add a polygon layer with label  
  addPolygons(data = countries, 
              color =	"#008000", 
              weight = 1, 
              smoothFactor = 0,
              group = "Countries",
              label = ~paste(countries$titles, ": ", countries$annotation, " pizzerias"))%>%
  
addLegend("topright", 
          colors = c("trasparent"), 
          labels=c("Giovanni Pietro Vitali - giovannipietrovitali@gmail.com"),
          title="Pizza Map (Learn R to make maps):") %>%
  
addMiniMap("bottomleft") %>%
  
  addLayersControl(overlayGroups = c("Pizzerias", "Countries"))
options = layersControlOptions(collapsed = TRUE)


## closing the map
map
