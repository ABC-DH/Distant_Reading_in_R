# Install necessary packages for the project
# install.packages("ggridges")
# install.packages("ggplot2")

# Load the required libraries for creating ridgeline plots and data visualization
library(ggridges)
library(ggplot2)

# Read the dataset from a CSV file and store it in the 'cronologia' variable
cronologia <- read.csv("data/eneko.csv")

# Create a ridgeline plot using ggplot2 and ggridges
ggplot(cronologia, aes(x = anno,      # Set the x-axis to the 'anno' column
                       y = tematica,  # Set the y-axis to the 'tematica' column
                       fill = tematica)) + # Fill the ridges based on the 'tematica' column
  geom_density_ridges() + # Add ridgeline plots using geom_density_ridges
  theme_ridges() +        # Apply the theme_ridges theme for a clean look
  theme(legend.position = "none") # Remove the legend from the plot

                                                          ###################
                                                          ## Explanation: ###
                                                          ###################

## Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries ggridges and ggplot2.
## Load libraries: The library commands load the ggridges and ggplot2 packages into the R session.
## Read the dataset: The read.csv function reads data from a CSV file and stores it in the cronologia variable.
## Create ridgeline plot: The ggplot function initializes a ridgeline plot using the cronologia dataset.
## Set aesthetics: The aes function sets the aesthetics for the plot:
##    x = anno: The x-axis represents the 'anno' (year) column.
##    y = tematica: The y-axis represents the 'tematica' (theme) column.
##    fill = tematica: The fill color of the ridges is based on the 'tematica' column.

## Add ridgeline plots: The geom_density_ridges function adds ridgeline plots to the graph.

## Apply theme: The theme_ridges function applies a clean, ridgeline-specific theme to the plot.

## Remove legend: The theme function with legend.position = "none" removes the legend from the plot for a cleaner appearance.

## The code creates a ridgeline plot showing the density distribution of the 'anno' (year) for each 'tematica' (theme) in the cronologia dataset, with each ridge filled according to its theme.