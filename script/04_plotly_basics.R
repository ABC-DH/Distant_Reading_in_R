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
# CREATE SAMPLE DATA
###############################################################################

# Create a vector containing the x-axis values.
x <- c(1, 2, 3, 4, 5)

# Create a vector containing positive y-axis values.
y <- c(6, 7, 8, 9, 10)

# Create a vector containing negative y-axis values.
y3 <- c(-6, -7, -8, -9, -10)


###############################################################################
# BASIC LINE PLOT
###############################################################################

# Create an interactive line plot.
plot_ly(
  
  # Define the values displayed on the x-axis.
  x = c(1, 2, 3),
  
  # Define the values displayed on the y-axis.
  y = c(4, 5, 6),
  
  # Create a scatter plot.
  type = "scatter",
  
  # Connect the points with lines.
  mode = "lines"
)


###############################################################################
# LINE PLOT FROM A CSV FILE
###############################################################################

# Read the dataset stored in the data folder.
table_example_2 <- read.csv("data/plotly_example.csv")

# Create an interactive line plot using the imported dataset.
plot <- plot_ly(
  
  # Use column1 for the x-axis.
  x = table_example_2$column1,
  
  # Use column1 for the y-axis.
  y = table_example_2$column1,
  
  # Create a scatter plot.
  type = "scatter",
  
  # Connect the points with lines.
  mode = "lines"
)

# Display the interactive graph.
plot


###############################################################################
# BASIC SCATTER PLOT
###############################################################################

# Create an interactive scatter plot.
plot_ly(
  
  # Define the values displayed on the x-axis.
  x = c(1, 2, 3),
  
  # Define the values displayed on the y-axis.
  y = c(4, 5, 6),
  
  # Create a scatter plot.
  type = "scatter",
  
  # Display only the points.
  mode = "markers"
)


###############################################################################
# BASIC BAR CHART
###############################################################################

# Create an interactive bar chart.
plot_ly(
  
  # Define the values displayed on the x-axis.
  x = c(1, 2, 3),
  
  # Define the values displayed on the y-axis.
  y = c(4, 5, 6),
  
  # Display the data as bars.
  type = "bar"
)


###############################################################################
# BUBBLE CHART
###############################################################################

# Create an interactive bubble chart.
plot_ly(
  
  # Define the values displayed on the x-axis.
  x = c(1, 2, 3),
  
  # Define the values displayed on the y-axis.
  y = c(4, 5, 6),
  
  # Create a scatter plot.
  type = "scatter",
  
  # Display only the points.
  mode = "markers",
  
  # Set the size of each bubble.
  size = c(2, 6, 9),
  
  # Assign a different colour to each bubble.
  marker = list(
    color = c("red", "black", "yellow")
  )
)


###############################################################################
# AREA PLOT
###############################################################################

# Create an interactive area plot.
plot_ly(
  
  # Define the values displayed on the x-axis.
  x = c(1, 2, 3),
  
  # Define the values displayed on the y-axis.
  y = c(4, 5, 6),
  
  # Create a scatter plot.
  type = "scatter",
  
  # Connect the points with lines.
  mode = "lines",
  
  # Fill the area between the line and the x-axis.
  fill = "tozeroy"
)

