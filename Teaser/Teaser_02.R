###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install the packages only once, then keep these commands commented out.
install.packages("ggplot2")
install.packages("ggridges")
install.packages("visNetwork")
install.packages("tidyverse")
install.packages("leaflet")
install.packages("leaflet.extras")
install.packages("sf")


###############################################################################
# GRAPHS — RIDGELINE PLOT
###############################################################################

library(ggridges)  # Creates ridgeline density plots.
library(ggplot2)   # Creates and customizes statistical graphs.

# Read the chronology dataset.
cronologia <- read.csv(
  "Graphs/data/eneko.csv",       # Define the path to the CSV file.
  stringsAsFactors = FALSE        # Keep textual columns as character strings.
)

# Create one density curve for each theme.
ggplot(
  data = cronologia,              # Use the chronology dataset.
  aes(
    x = anno,                     # Put the year on the x-axis.
    y = tematica,                 # Put the themes on the y-axis.
    fill = tematica               # Use a different fill colour for each theme.
  )
) +
  geom_density_ridges() +         # Draw one density ridge for each theme.
  theme_ridges() +                # Apply a theme designed for ridgeline plots.
  theme(
    legend.position = "none"      # Remove the redundant legend.
  )


###############################################################################
# NETWORKS — VISNETWORK
###############################################################################

library(visNetwork)  # Creates interactive network visualizations.
library(tidyverse)   # Imports and manipulates data; here it provides read_csv().

# Read the node and edge tables.
nodes <- read_csv("Network/data/nodes.csv")  # Import the node attributes.
edges <- read_csv("Network/data/edges.csv")  # Import the relationships.

# Create a simple interactive network with groups and a legend.
visNetwork(
  nodes,                            # Use the nodes dataset.
  edges,                            # Use the edges dataset.
  width = "100%"                   # Use all the available horizontal space.
) %>%
  visGroups(
    groupname = "A",               # Customize group A.
    color = "red"                  # Set the colour of group A.
  ) %>%
  visGroups(
    groupname = "B",               # Customize group B.
    color = "lightblue"            # Set the colour of group B.
  ) %>%
  visLegend(
    width = 0.1,                    # Set the legend width.
    position = "right",            # Place the legend on the right.
    main = "Group"                 # Add a title to the legend.
  )

# Create a second network using a force-directed layout and arrows.
visNetwork(
  nodes,                            # Use the nodes dataset.
  edges,                            # Use the edges dataset.
  width = "100%"                   # Use all the available horizontal space.
) %>%
  visIgraphLayout(
    layout = "layout_with_fr"      # Apply the Fruchterman-Reingold layout.
  ) %>%
  visEdges(
    arrows = "middle"              # Display arrows in the middle of the edges.
  )


###############################################################################
# MAPS — LEAFLET
###############################################################################

library(leaflet)         # Creates interactive maps and map layers.
library(leaflet.extras)  # Adds extra controls such as the minimap.
library(sf)              # Reads and manages geographical vector data.

# Read the shapefile containing country polygons.
countries <- st_read(
  "Mapping/data/shp/countries/countries-polygon.shp"
)

# Convert the polygons to the coordinate system used by Leaflet.
countries <- st_transform(
  countries,                       # Use the imported country polygons.
  crs = 4326                       # Use the standard longitude-latitude system.
)

# Read the CSV file containing the pizzeria information.
pizzerias <- read.csv(
  "Mapping/data/csv/pizzamap.csv", # Define the path to the CSV file.
  stringsAsFactors = FALSE          # Keep textual columns as character strings.
)

# Create the HTML text displayed when a marker is selected.
pizzerias$popup <- paste0(
  "<b>", pizzerias$name, "</b><br><br>",
  "City: <b>", pizzerias$city, "</b> in <b>", pizzerias$country, "</b><br>",
  "Opening date: <b>", pizzerias$data_viz, "</b><br>",
  "Number of pizzas: <b>", pizzerias$pizzas, "</b><br>",
  "Special pizza: <b>", pizzerias$pizza_special, "</b><br>",
  "Takeaway: <b>", pizzerias$take_away, "</b><br>",
  "Other products: <b>", pizzerias$other_stuff, "</b>"
)

# Create the interactive map.
map <- leaflet() %>%
  addProviderTiles(
    providers$OpenStreetMap        # Add the OpenStreetMap background layer.
  ) %>%
  setView(
    lng = 60.27444399596726,       # Set the initial centre longitude.
    lat = 27.808314896631217,      # Set the initial centre latitude.
    zoom = 2                       # Set the initial zoom level.
  ) %>%
  addMarkers(
    data = pizzerias,              # Use the pizzeria dataset.
    lng = ~lng,                    # Use lng as longitude.
    lat = ~lat,                    # Use lat as latitude.
    group = "Pizzerias",          # Add markers to the Pizzerias layer.
    popup = ~popup                 # Display the prepared popup.
  ) %>%
  addPolygons(
    data = countries,              # Use the country polygons.
    color = "#008000",            # Set the polygon border colour.
    weight = 1,                    # Set the polygon border width.
    smoothFactor = 0,              # Preserve the original polygon geometry.
    fillOpacity = 0.1,             # Make the polygon fill mostly transparent.
    group = "Countries",          # Add polygons to the Countries layer.
    label = ~paste0(
      COUNTRY,
      ": ",
      number,
      " pizzerias"
    )                              # Display the country and pizzeria count.
  ) %>%
  addControl(
    html = htmltools::HTML("
      <div style='
        background:rgba(255,255,255,.95);
        padding:10px 12px;
        border-radius:8px;
        font-family:Arial;
        font-size:12px;
        line-height:1.4;
        box-shadow:0 2px 8px rgba(0,0,0,.22);'>
        <b>🍕 Pizza Map</b><br>
        <span style='color:#666;'>Learn R with Leaflet</span><br>
        Giovanni Pietro Vitali — UVSQ Paris-Saclay
      </div>
    "),
    position = "topright"          # Place the information box at the top right.
  ) %>%
  addMiniMap(
    position = "bottomleft"        # Add an overview map at the bottom left.
  ) %>%
  addLayersControl(
    overlayGroups = c(
      "Pizzerias",                 # Add the pizzeria marker layer.
      "Countries"                  # Add the country polygon layer.
    ),
    options = layersControlOptions(
      collapsed = TRUE              # Keep the layer menu closed by default.
    )
  )

# Display the completed interactive map.
map
