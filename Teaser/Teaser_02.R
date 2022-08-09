# Libraries
install.packages("ggplot2")
install.packages("dplyr")
install.packages("plotly")
install.packages("hrbrthemes")
install.packages("visNetwork")
install.packages("tidyverse")
install.packages("leaflet")
install.packages("sp")
install.packages("rgal")

################################################################################
##################### GRAPHS ###################################################
################################################################################

library(ggplot2)
library(dplyr)
library(plotly)
library(hrbrthemes)

# Load dataset
data <- read.csv("Graphs/data/music.csv")

f <- list(
  family = "Arial, monospace",
  size = 14,
  color = "#7f7f7f"
)
x <- list(
  title = "Anni",
  titlefont = f
)
y <- list(
  title = "Numero di ricerche",
  titlefont = f
)

# annotations
a <- list(
  text = "Giovanni Pietro  Vitali - UVSQ-Paris-Saclay (giovanni.vitali@uvsq.fr)",

  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.8,
  y = 0.985,
  showarrow = FALSE
)

b <- list(
  text = "",
  font = f,
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.5,
  y = 0.95,
  showarrow = FALSE
)


# Area chart with 2 groups
p <- plot_ly(x = data$months,
             y = data$folk,
             type="scatter",
             mode="markers",
             fill = "tozeroy",
             name = "folk")

p <- p %>% add_trace(y = data$trap,
                     name = "trap")

p <- p %>% layout(xaxis = x,
                  yaxis = y,
                  title= "Ricerche su Google di Folk e Trap (2004-2020)",
                  annotations = list(a, b))

p

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

library(leaflet)
library(sp)
library(rgdal)

## Load the shapefile and name it
countries <- readOGR('Mapping/data/shp/countries/countries.shp')

## Read the csv
data <- read.csv("Mapping/data/csv/pizzamap.csv")

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
