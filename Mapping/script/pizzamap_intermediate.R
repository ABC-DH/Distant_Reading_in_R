###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install leaflet, the package used to create interactive maps.
# This command only needs to be run once and is therefore commented out.
# install.packages("leaflet")

# Install sf, the package used to read and manage geographical vector data.
# This command only needs to be run once and is therefore commented out.
# install.packages("sf")

# Install leaflet.extras, which adds controls such as the reset button
# and the minimap.
# This command only needs to be run once and is therefore commented out.
# install.packages("leaflet.extras")

# Install leafem, which adds tools such as the coordinate display.
# This command only needs to be run once and is therefore commented out.
# install.packages("leafem")


###############################################################################
# LOAD THE REQUIRED LIBRARIES
###############################################################################

library(leaflet)         # Creates interactive maps and map layers.
library(sf)              # Reads and manages geographical vector data.
library(leaflet.extras)  # Adds extra controls such as reset and minimap tools.
library(leafem)          # Adds extra map elements such as mouse coordinates.


###############################################################################
# PART 1 — IMPORT AND PREPARE THE DATA
###############################################################################

# Read the shapefile containing country polygons.
countries <- st_read(
  "data/shp/countries/countries-polygon.shp"  # Define the shapefile path.
)

# Convert the country polygons to the coordinate system used by Leaflet.
countries <- st_transform(
  countries,  # Use the imported country polygons.
  crs = 4326  # Convert the data to the standard GPS coordinate system.
)

# Read the CSV file containing the pizzeria data.
data <- read.csv(
  "data/csv/pizzamap.csv",  # Define the CSV file path.
  stringsAsFactors = FALSE  # Keep text columns as character strings.
)

# Display the column names to verify the structure of the datasets.
names(countries)  # Show the country dataset columns.
names(data)       # Show the pizzeria dataset columns.


###############################################################################
# CREATE THE COLOUR PALETTES
###############################################################################

# Create a colour scale based on the number of pizzerias in each country.
palette_countries <- colorNumeric(
  palette = "YlOrRd",         # Use a yellow-to-red colour scale.
  domain = countries$number,  # Associate colours with pizzeria counts.
  na.color = "transparent"    # Make countries without data transparent.
)

# Create a colour scale based on the average pizza price.
palette_data <- colorNumeric(
  palette = "YlGn",                  # Use a yellow-to-green colour scale.
  domain = data$price_euro_average,  # Associate colours with average prices.
  na.color = "transparent"           # Make missing values transparent.
)


###############################################################################
# CREATE THE PIZZERIA POPUPS
###############################################################################

# Create the HTML text displayed when a pizzeria marker is selected.
data$popup <- paste0(
  "<div class='leaflet-popup-scrolled' style='max-width:250px; max-height:250px;'>",
  "<b>", data$name, "</b>",                                           # Display the pizzeria name.
  " in ", data$city, " (", data$country, ")<br><br>",                # Display the city and country.
  "Number of pizzas: <b>", data$pizzas, "</b><br>",                   # Display the number of pizzas.
  "Approximate number of seats: <b>", data$places_circa, "</b><br>", # Display the approximate number of seats.
  data$image, "<br>",                                                 # Display the image stored in the dataset.
  "<small>Takeaway: <b>", data$take_away, "</b></small>",             # Display takeaway information.
  "</div>"
)


###############################################################################
# CREATE THE PIZZA ICON
###############################################################################

# Define the web address of the image used as a pizzeria marker.
pizza_icon_url <- "http://miam-images.m.i.pic.centerblog.net/o/b0cb1d85.png"

# Create a Leaflet icon using the image.
pizza_icon <- makeIcon(
  iconUrl = pizza_icon_url,  # Use the image as the marker icon.
  iconWidth = 40,            # Set the icon width.
  iconHeight = 40            # Set the icon height.
)


###############################################################################
# PART 2 — CREATE THE INTERACTIVE MAP
###############################################################################

# Initialize the Leaflet map.
map <- leaflet() %>%
  
  # Add the OpenStreetMap base map.
  addProviderTiles(
    providers$OpenStreetMap,  # Use OpenStreetMap tiles.
    group = "OpenStreetMap"   # Add the tiles to this base group.
  ) %>%
  
  # Add the CartoDB Positron base map.
  addProviderTiles(
    providers$CartoDB.Positron,  # Use a light CartoDB background.
    group = "CartoDB"            # Add the tiles to this base group.
  ) %>%
  
  # Add the Esri satellite base map.
  addProviderTiles(
    providers$Esri.WorldImagery,  # Use satellite imagery.
    group = "Satellite"           # Add the tiles to this base group.
  ) %>%
  
  # Add a button that restores the initial map view.
  addResetMapButton() %>%
  
  # Add a small overview map.
  addMiniMap(
    position = "bottomleft"  # Place the minimap in the bottom-left corner.
  ) %>%
  
  # Display geographical coordinates under the mouse pointer.
  leafem::addMouseCoordinates() %>%
  
  # Set the initial centre and zoom level of the map.
  setView(
    lng = 60.27444399596726,   # Set the centre longitude.
    lat = 27.808314896631217,  # Set the centre latitude.
    zoom = 2                   # Set the initial zoom level.
  ) %>%
  
  ###########################################################################
# ADD THE COUNTRY POLYGONS
###########################################################################

# Represent countries using colours based on the number of pizzerias.
addPolygons(
  data = countries,                       # Use the country polygons.
  fillColor = ~palette_countries(number), # Colour polygons according to pizzeria counts.
  weight = 0.5,                           # Set the polygon border width.
  color = "brown",                        # Set the polygon border colour.
  dashArray = "3",                        # Draw dashed polygon borders.
  opacity = 0.7,                          # Set the border opacity.
  stroke = TRUE,                          # Draw the polygon borders.
  fillOpacity = 0.5,                      # Set the polygon fill transparency.
  smoothFactor = 0.5,                     # Simplify polygon geometry while zooming.
  group = "Countries",                    # Add polygons to the Countries layer.
  label = ~paste(
    "In", COUNTRY,                        # Display the country name.
    "there are", number,                  # Display the number of pizzerias.
    "pizzerias"
  ),
  highlightOptions = highlightOptions(
    weight = 2,                           # Increase the border width on hover.
    color = "#666",                       # Change the border colour on hover.
    dashArray = "",                       # Remove the dashed border on hover.
    fillOpacity = 0.7,                    # Increase fill opacity on hover.
    bringToFront = TRUE                   # Bring the selected polygon to the front.
  )
) %>%
  
  # Add a legend for the number of pizzerias by country.
  addLegend(
    position = "bottomleft",         # Place the legend in the bottom-left corner.
    pal = palette_countries,         # Use the country colour palette.
    values = countries$number,       # Use pizzeria counts as legend values.
    title = "Pizzerias by country",  # Add a legend title.
    labFormat = labelFormat(
      suffix = " pizzerias"          # Add the unit after each legend value.
    ),
    opacity = 1,                     # Make the legend fully opaque.
    group = "Countries"              # Associate the legend with the Countries layer.
  ) %>%
  
  ###########################################################################
# ADD THE PIZZERIA MARKERS
###########################################################################

# Add clustered markers for each pizzeria.
addAwesomeMarkers(
  data = data,                            # Use the pizzeria dataset.
  lng = ~lng,                             # Use lng as longitude.
  lat = ~lat,                             # Use lat as latitude.
  popup = ~popup,                         # Display the prepared HTML popup.
  group = "Pizzerias",                    # Add markers to the Pizzerias layer.
  options = popupOptions(
    maxWidth = 300,                       # Set the maximum popup width.
    maxHeight = 250                       # Set the maximum popup height.
  ),
  clusterOptions = markerClusterOptions() # Group nearby markers automatically.
) %>%
  
  ###########################################################################
# ADD PRICE-BASED CIRCLE MARKERS
###########################################################################

# Represent pizzerias using circles based on the average pizza price.
addCircleMarkers(
  data = data,                                    # Use the pizzeria dataset.
  lng = ~lng,                                     # Use lng as longitude.
  lat = ~lat,                                     # Use lat as latitude.
  fillColor = ~palette_data(price_euro_average),  # Colour circles according to price.
  color = "black",                                # Set the circle border colour.
  weight = 1,                                     # Set the circle border width.
  radius = ~sqrt(price_euro_average) * 3,         # Size circles according to price.
  stroke = TRUE,                                  # Draw the circle borders.
  fillOpacity = 0.5,                              # Set the circle transparency.
  group = "By price",                             # Add circles to the By price layer.
  label = ~paste(
    "At", name,                                   # Display the pizzeria name.
    "a pizza costs approximately",
    price_euro_average,                           # Display the average price.
    "euros"
  )
) %>%
  
  # Add a legend for the average pizza price.
  addLegend(
    position = "bottomleft",           # Place the legend in the bottom-left corner.
    pal = palette_data,                # Use the price colour palette.
    values = data$price_euro_average,  # Use average prices as legend values.
    title = "Average pizza price",     # Add a legend title.
    labFormat = labelFormat(
      suffix = " euros"                # Add the currency after each value.
    ),
    opacity = 1,                       # Make the legend fully opaque.
    group = "By price"                 # Associate the legend with the By price layer.
  ) %>%
  
  ###########################################################################
# ADD CUSTOM PIZZA ICONS
###########################################################################

# Add a second representation using custom pizza icons.
addMarkers(
  data = data,                          # Use the pizzeria dataset.
  lng = ~lng,                           # Use lng as longitude.
  lat = ~lat,                           # Use lat as latitude.
  icon = pizza_icon,                    # Use the custom pizza icon.
  group = "Pizza markers",              # Add icons to the Pizza markers layer.
  popup = ~paste0("<b>", name, "</b>")  # Display the pizzeria name in bold.
) %>%
  
  ###########################################################################
# ADD THE MAP INFORMATION BOX
###########################################################################

# Add a custom information box containing the map title and author.
addControl(
  html = HTML("
      <div style='
        background: rgba(255,255,255,.95);
        padding: 12px;
        border-radius: 10px;
        font-family: Arial;
        font-size: 13px;
        line-height: 1.4;
        box-shadow: 0 2px 10px rgba(0,0,0,.25);
      '>
        <h4 style='margin:0;'>🍕 Pizza Map</h4>
        <div style='font-size:11px; color:#666;'>
          Learn R with Leaflet
        </div>
        <hr style='margin:8px 0;'>
        <b>Author</b><br>
        Giovanni Pietro Vitali<br>
        UVSQ – Paris-Saclay
      </div>
    "),                            # Define the HTML content and style.
  position = "topright"          # Place the information box at the top right.
) %>%
  
  ###########################################################################
# PART 3 — MANAGE THE MAP LAYERS
###########################################################################

# Add controls allowing users to select one base map
# and activate or deactivate overlay layers.
addLayersControl(
  baseGroups = c(
    "OpenStreetMap",  # Add the OpenStreetMap base map.
    "CartoDB",        # Add the CartoDB base map.
    "Satellite"       # Add the satellite base map.
  ),
  overlayGroups = c(
    "Pizzerias",      # Add the pizzeria marker layer.
    "Countries",      # Add the country polygon layer.
    "By price",       # Add the price circle layer.
    "Pizza markers"   # Add the custom icon layer.
  ),
  options = layersControlOptions(
    collapsed = TRUE  # Keep the layer menu closed initially.
  )
) %>%
  
  # Hide optional overlay layers when the map first opens.
  hideGroup(
    c(
      "Countries",      # Hide the country polygon layer.
      "By price",       # Hide the price circle layer.
      "Pizza markers"   # Hide the custom icon layer.
    )
  )


###############################################################################
# DISPLAY THE MAP
###############################################################################

# Display the completed interactive map.
map