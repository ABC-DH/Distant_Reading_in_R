# Install necessary packages for the project
# install.packages("tidyverse")
# install.packages("ggplot2")

# Load the required libraries for data manipulation and visualization
library(tidyverse)
library(ggplot2)

# Read the dataset from a CSV file and store it in the 'cronologia' variable
cronologia <- read.csv("data/eneko.csv")

# Create a scatter plot using ggplot2
ggplot(filter(cronologia, tematica %in% c("Dedicatoria", 
                                          "Ecología", 
                                          "Economía",
                                          "Historia&Sociedad",
                                          "Iglesia",
                                          "Independencia",
                                          "Migración",
                                          "Sexismo",
                                          "Política",
                                          "Periódico",
                                          "Guerra")),
       aes(x = tiempo,          # Set the x-axis to the 'tiempo' column
           y = areas,           # Set the y-axis to the 'areas' column
           color = tematica,    # Color the points by the 'tematica' column
           size = anno,         # Set the size of the points by the 'anno' column
           fillopacity = 0.9)) +# Set the fill opacity of the points to 0.9
  geom_point()                  # Use points to create the scatter plot

                                                        ###################
                                                        ## Explanation: ##
                                                        ##################

## Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries.

## Load libraries: The library commands load the tidyverse and ggplot2 packages into the R session.

## Read the dataset: The read.csv function reads data from a CSV file and stores it in the cronologia variable.

## Create scatter plot: The ggplot function initializes a scatter plot using the cronologia dataset, filtered to include only specific 'tematica' values.

## Filter dataset: The filter function from dplyr filters the dataset to include rows where the 'tematica' column matches one of the specified values.

## Set aesthetics: The aes function sets the aesthetics for the plot:
##  x = tiempo: The x-axis represents the 'tiempo' column.
##  y = areas: The y-axis represents the 'areas' column.
##  color = tematica: The points are colored based on the 'tematica' column.
## size = anno: The size of the points is based on the 'anno' column.
## fillopacity = 0.9: The fill opacity of the points is set to 0.9 (note: this argument is not standard in aes and will be ignored by ggplot2).

## Add points: The geom_point function adds points to the scatter plot.

## The code creates a scatter plot with points colored by theme ('tematica') and sized by year ('anno'), showing the relationship between 'tiempo' (time) and 'areas'.