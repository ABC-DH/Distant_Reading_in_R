###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install leaflet, the package used to create interactive maps.
# This command only needs to be run once and is therefore commented out.
# install.packages("leaflet")

# Install leaflet.extras, which adds additional tools
# such as the minimap.
# This command only needs to be run once and is therefore commented out.
# install.packages("leaflet.extras")

# Install sf, the package used to read and manage spatial data.
# This command only needs to be run once and is therefore commented out.
# install.packages("sf")


###############################################################################
# LOAD THE REQUIRED LIBRARIES
###############################################################################

library(leaflet)         # Creates interactive maps.
library(leaflet.extras)  # Adds extra tools such as the minimap.
library(sf)              # Reads and manages geographical vector data.


###############################################################################
# IMPORT THE SPATIAL DATA
###############################################################################

# Read the shapefile containing the country polygons.
countries <- st_read(
  "data/shp/countries/countries-polygon.shp"
)

# Read the CSV file containing the pizzeria information.
data <- read.csv(
  "data/csv/pizzamap.csv",
  stringsAsFactors = FALSE
)


###############################################################################
# INSPECT THE IMPORTED DATA
###############################################################################

# Display the column names of the pizzeria dataset.
# This helps verify that the names used below are correct.
names(data)

# Display the column names of the country shapefile.
names(countries)


###############################################################################
# CREATE THE POPUP TEXT
###############################################################################

# Create the HTML text displayed when a pizzeria marker is selected.
data$popup <- paste0(
  "<b>", data$name, "</b><br><br>",
  "City: <b>", data$city, "</b> in <b>", data$country, "</b><br>",
  "Open on: <b>", data$date, "</b><br>",
  "Number of pizzas: <b>", data$pizzas, "</b><br>",
  "Special pizza: <b>", data$pizza_special, "</b><br>",
  "Take away: <b>", data$take_away, "</b><br>",
  "Other products: <b>", data$other_stuff, "</b>"
)


###############################################################################
# CREATE THE INTERACTIVE MAP
###############################################################################

# Create the Leaflet map.
map <- leaflet() %>%
  
  # Add the OpenStreetMap background layer.
  addProviderTiles(
    providers$OpenStreetMap
  ) %>%
  
  # Set the initial centre and zoom level of the map.
  setView(
    lng = 60.27444399596726,   # Set the centre longitude.
    lat = 27.808314896631217,  # Set the centre latitude.
    zoom = 2                   # Set the initial zoom level.
  ) %>%
  
  # Add one marker for each pizzeria.
  addMarkers(
    data = data,               # Use the pizzeria dataset.
    lng = ~lng,                # Use lng as longitude.
    lat = ~lat,                # Use lat as latitude.
    group = "Pizzerias",       # Add markers to the Pizzerias group.
    popup = ~popup             # Display the previously created popup.
  ) %>%
  
  # Add the country polygons.
  addPolygons(
    data = countries,          # Use the country shapefile.
    color = "#008000",         # Set the polygon border colour.
    weight = 1,                # Set the border width.
    smoothFactor = 0,          # Preserve the original polygon geometry.
    fillOpacity = 0.1,         # Make the polygon fill mostly transparent.
    group = "Countries",       # Add polygons to the Countries group.
    label = ~paste0(
      COUNTRY,
      ": ",
      number,
      " pizzerias"
    )                          # Display the country name and pizzeria count.
  ) %>%
  
  # Add a custom information box.
  addLegend(
    position = "topright",     # Place the box in the top-right corner.
    colors = "transparent",    # Use a transparent legend symbol.
    labels = "Giovanni Pietro Vitali - giovannipietrovitali@gmail.com",
    title = "Pizza Map (Learn R to make maps)"
  ) %>%
  
  # Add a small overview map in the bottom-left corner.
  addMiniMap(
    position = "bottomleft"
  ) %>%
  
  # Add controls that allow users to show or hide map layers.
  addLayersControl(
    overlayGroups = c(
      "Pizzerias",
      "Countries"
    ),
    options = layersControlOptions(
      collapsed = TRUE        # Keep the layer menu closed by default.
    )
  )


###############################################################################
# DISPLAY THE MAP
###############################################################################

# Display the completed interactive map.
map