## PACKAGE INSTALLATION & DATA

# Install necessary package for the project
# install.packages("plotly")

# Load the required library for interactive plotting
library(plotly)

# Define sample data
x = c(1, 2, 3, 4, 5)
y = c(6, 7, 8, 9, 10)
y3 = c(-6, -7, -8, -9, -10)

# Create a basic line plot
plot_ly(x = c(1, 2, 3),
        y = c(4, 5, 6),
        type = "scatter",
        mode = "lines")

# Create a line plot using data from a CSV file
table_example_2 <- read.csv("data/plotly_example.csv")
plot <- plot_ly(x = table_example_2$column1, 
                y = table_example_2$column1,
                type = "scatter",
                mode = "lines")
plot

# Create a basic scatter plot
plot_ly(x = c(1, 2, 3),
        y = c(4, 5, 6),
        type = "scatter", 
        mode = "markers")

# Create a basic bar plot
plot_ly(x = c(1, 2, 3),
        y = c(4, 5, 6),
        type = "bar")

# Create a bubble chart
plot_ly(x = c(1, 2, 3),
        y = c(4, 5, 6),
        type = "scatter",
        mode = "markers",
        size = c(2, 6, 9),
        marker = list(color = c("red", "black", "yellow")))

# Create an area plot
plot_ly(x = c(1, 2, 3),
        y = c(4, 5, 6),
        type = "scatter",
        mode = "lines",
        fill = "tozeroy")

                                    ###################
                                    ## Explanation: ##
                                    ##################

##Install necessary package: The install.packages command (commented out) suggests installing the plotly library.

## Load library: The library command loads the plotly package into the R session.

## Define sample data: Three vectors x, y, and y3 are defined with numerical values.

## Create a basic line plot:
## The plot_ly function initializes a plot.
## x = c(1, 2, 3): Sets the x-axis values.
## y = c(4, 5, 6): Sets the y-axis values.
## type = "scatter": Specifies that the plot is a scatter plot.
## mode = "lines": Specifies that the points should be connected with lines.

## Create a line plot using data from a CSV file:
##  The read.csv function reads data from a CSV file and stores it in table_example_2.
##  The plot_ly function creates a line plot using column1 from the dataset for both x and y axes.
##  plot stores the plot object, and plot renders it.

## Create a basic scatter plot:
##  Similar to the line plot but with mode = "markers" to show individual points without connecting lines.

## Create a basic bar plot:
##  The plot_ly function initializes a bar plot with specified x and y values.
##  type = "bar": Specifies that the plot is a bar plot.

## Create a bubble chart:
##  The plot_ly function initializes a scatter plot.
##  mode = "markers": Specifies that individual points should be shown.
##  size = c(2, 6, 9): Sets the size of the points.
##  marker = list(color = c("red", "black", "yellow")): Specifies the colors of the points.

## Create an area plot:
##  The plot_ly function initializes a scatter plot.
##  fill = "tozeroy": Fills the area under the lines down to the y=0 line.