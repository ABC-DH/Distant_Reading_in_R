## Install necessary package for the project
## install.packages("plotly")

# Load the required library for interactive plotting
library(plotly)

# Read the dataset from a CSV file and store it in the 'data' variable
data <- read.csv("data/iris.csv")

## Basic scatter plot
# Create a basic scatter plot using the iris dataset
fig <- plot_ly(data = iris, 
               x = ~Sepal.Length, # Set the x-axis to the 'Sepal.Length' column
               y = ~Petal.Length) # Set the y-axis to the 'Petal.Length' column
fig # Display the plot

## Customized Scatter Plot
# Create a customized scatter plot using the iris dataset
fig <- plot_ly(data = iris, 
               x = ~Sepal.Length, # Set the x-axis to the 'Sepal.Length' column
               y = ~Petal.Length, # Set the y-axis to the 'Petal.Length' column
               marker = list(size = 10, # Set the size of the markers
                             color = 'blue', # Set the color of the markers
                             line = list(color = 'green', # Set the color of the marker borders
                                         width = 2))) # Set the width of the marker borders

# Customize the layout of the plot
fig <- fig %>% layout(title = 'Customized Scatter Plot', # Set the title of the plot
                      yaxis = list(zeroline = FALSE), # Remove the zero line from the y-axis
                      xaxis = list(zeroline = FALSE)) # Remove the zero line from the x-axis
fig # Display the customized plot

                                                          ###################
                                                          ## Explanation: ##
                                                          ##################
##  Install necessary package: The install.packages command (commented out) suggests installing the plotly library.

## Load library: The library command loads the plotly package into the R session.

## Read the dataset: The read.csv function reads data from a CSV file and stores it in the data variable.

## Basic scatter plot:
##  The plot_ly function initializes a basic scatter plot using the iris dataset.
##      x = ~Sepal.Length: Sets the x-axis to the Sepal.Length column.
##      y = ~Petal.Length: Sets the y-axis to the Petal.Length column.
##      fig: Stores the plot object, and fig displays the plot.

## Customized scatter plot:

##  The plot_ly function initializes a scatter plot using the iris dataset with additional customization for the markers.
##      marker = list(...): Customizes the markers:
##      size = 10: Sets the size of the markers.
##      color = 'blue': Sets the color of the markers.
##      line = list(...): Customizes the marker borders:
##      color = 'green': Sets the color of the marker borders.
##      width = 2: Sets the width of the marker borders.

##  The layout function further customizes the plot layout:
##      title = 'Customized Scatter Plot': Sets the title of the plot.
##      yaxis = list(zeroline = FALSE): Removes the zero line from the y-axis.
##      xaxis = list(zeroline = FALSE): Removes the zero line from the x-axis.
##      fig: Stores the customized plot object, and fig displays the customized plot.