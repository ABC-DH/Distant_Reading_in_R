###############################################################################
# INSTALL THE REQUIRED PACKAGE
###############################################################################

# Install plotly, the package used to create interactive graphs.
# This command only needs to be run once and is therefore commented out.
# install.packages("plotly")


###############################################################################
# LOAD THE REQUIRED LIBRARY
###############################################################################

# Load plotly into the current R session.
library(plotly)


###############################################################################
# IMPORT THE DATASET
###############################################################################

# Read the music.csv file located in the data folder.
# Store the imported data in an object called data.
data <- read.csv("data/music.csv")


###############################################################################
# DEFINE THE FONT STYLE
###############################################################################

# Create a list containing the font properties used in the graph.
f <- list(
  
  # Set the font family.
  family = "Arial, monospace",
  
  # Set the font size.
  size = 14,
  
  # Set the font colour.
  color = "#7f7f7f"
)


###############################################################################
# CUSTOMIZE THE X-AXIS
###############################################################################

# Create a list containing the properties of the x-axis.
x <- list(
  
  # Add a title to the x-axis.
  title = "Years",
  
  # Apply the previously defined font style to the axis title.
  titlefont = f
)


###############################################################################
# CUSTOMIZE THE Y-AXIS
###############################################################################

# Create a list containing the properties of the y-axis.
y <- list(
  
  # Add a title to the y-axis.
  # Google Trends values are normalized indices, not absolute search counts.
  title = "Google Trends Index",
  
  # Apply the previously defined font style to the axis title.
  titlefont = f
)


###############################################################################
# CREATE AN ANNOTATION
###############################################################################

# Create a text annotation containing the author's name and affiliation.
a <- list(
  
  # Define the text displayed in the annotation.
  text = "Giovanni Pietro Vitali - UVSQ-Paris-Saclay (giovanni.vitali@uvsq.fr)",
  
  # Position the annotation relative to the entire plotting area.
  xref = "paper",
  yref = "paper",
  
  # Anchor the annotation from its bottom edge.
  yanchor = "bottom",
  
  # Anchor the annotation from its centre.
  xanchor = "center",
  
  # Centre the text inside the annotation.
  align = "center",
  
  # Set the horizontal position of the annotation.
  x = 0.8,
  
  # Set the vertical position of the annotation.
  y = 0.985,
  
  # Do not display an arrow.
  showarrow = FALSE
)


###############################################################################
# CREATE THE FIRST AREA
###############################################################################

# Create an interactive graph using the music dataset.
p <- plot_ly(
  
  # Put the months variable on the x-axis.
  x = data$months,
  
  # Put the Google Trends values for folk on the y-axis.
  y = data$folk,
  
  # Create a scatter trace.
  type = "scatter",
  
  # Connect the observations with a line.
  mode = "lines",
  
  # Fill the area between the line and the horizontal axis.
  fill = "tozeroy",
  
  # Add a name to the trace and to the legend.
  name = "Folk"
)


###############################################################################
# ADD THE SECOND AREA
###############################################################################

# Add a second trace to the existing graph.
p <- p %>%
  add_trace(
    
    # Use the same x-axis values as the first trace.
    x = data$months,
    
    # Put the Google Trends values for trap on the y-axis.
    y = data$trap,
    
    # Create another scatter trace.
    type = "scatter",
    
    # Connect the observations with a line.
    mode = "lines",
    
    # Fill the area between the line and the horizontal axis.
    fill = "tozeroy",
    
    # Add a name to the trace and to the legend.
    name = "Trap"
  )


###############################################################################
# CUSTOMIZE THE GRAPH
###############################################################################

# Modify the layout of the graph.
p <- p %>%
  layout(
    
    # Apply the previously defined properties to the x-axis.
    xaxis = x,
    
    # Apply the previously defined properties to the y-axis.
    yaxis = y,
    
    # Add a title to the graph.
    title = "Google Trends Interest in Folk and Trap (2004–2020)",
    
    # Add the annotation to the graph.
    annotations = list(a)
  )


###############################################################################
# DISPLAY THE GRAPH
###############################################################################

# Display the completed interactive graph.
p