## Tutorial inspired by Alessio Passalacqua

## Install necessary packages for the project
## install.packages("ggplot2")
## install.packages("plotly")
## install.packages("GGally")

# Load the required libraries for data visualization
library(ggplot2)

###############################################################################
# The wine dataset contains the results of a chemical analysis of wines grown #
# in a specific area of Italy.                                                #    
# Three types of wine are represented in the 178 samples,                     #
# with the results of 13 chemical analyses recorded for each sample.          #
# The Type variable has been transformed into a categoric variable.           # 
# The data contains no missing values and consists of only numeric data,      #
# with a three-class target variable (Type) for classification.               #
###############################################################################

# Read the wine dataset from a CSV file
table <- read.csv("data/wine.csv")

# Background scatter plot
ggplot(data = table, aes(x = Magnesium, y = Flavanoids))

# Scatter plot of Magnesium vs Flavanoids
ggplot(data = table, aes(x = Magnesium, y = Flavanoids)) + geom_point()

# Customized scatter plot with additional aesthetics
ggplot(data = table, aes(x = Magnesium, 
                         y = Flavanoids,
                         colour = Hue,
                         size = Proline))  +
  geom_point() + 
  labs(x = "Magnesium", 
       y = "Flavanoids", 
       title = "Wine data set",
       subtitle = "Scatter plot",
       caption = "Data from library rattle.data")

# Add a theme to the scatter plot
# theme_gray() | theme_bw() | theme_classic() | theme_dark() | theme_gray()
# theme_grey() | theme_light() | theme_linedraw() | theme_minimal()

ggplot(data = table, aes(x = Magnesium, 
                         y = Flavanoids,
                         colour = Hue,
                         size = Proline))  +
  geom_point() + 
  labs(x = "Magnesium", y = "Flavanoids", 
       title = "Wine data set",
       subtitle = "Scatter plot",
       caption = "Data from library rattle.data") +
  theme_grey()

# Change the dataset to WWII data
table_ww2 <- read.csv("data/1943.csv")

ggplot(data = table_ww2, aes(x = date,
                             y = old_people,
                             colour = authors_event,
                             size = victims))  +
  geom_point() + 
  labs(x = "Dates of the massacres", y = "Elderly people killed", 
       title = "Massacres during 1943 by Nazis or Fascists",
       subtitle = "Relationships between the total victims and the old people",
       caption = "Data from library rattle.data") +
  theme_minimal()

# Return to the wine dataset
# Histogram of Alcohol content
ggplot(data = table, aes(x = Alcohol)) + 
  geom_histogram(fill = "#69b3a2", color = "#e9ecef", alpha = 0.7, binwidth = 0.5)

# Density plot of Alcohol content
ggplot(data = table, aes(x = Alcohol)) + 
  geom_density(fill = "#69b3a2", color = "red", alpha = 0.5, bw = 0.1)

# Boxplot of Alcohol content
ggplot(data = table, aes(y = Alcohol)) + geom_boxplot()

# Line plot of Alcohol vs Color
ggplot(data = table, aes(Alcohol, Color)) + 
  geom_line()

# Two-dimensional density plot of Alcohol vs Ash
ggplot(data = table, aes(x = Alcohol, y = Ash)) + 
  geom_density2d() + 
  geom_point()

# Jitter plot of Alcohol vs Proline
ggplot(data = table, aes(x = Alcohol, y = Proline)) + 
  geom_jitter()

# Jitter plot with a linear trend line
ggplot(data = table, aes(x = Alcohol, y = Proline)) + 
  geom_jitter() +  
  geom_smooth(method = lm)

# Jitter plot with a loess curve
ggplot(data = table, aes(x = Alcohol, y = Proline)) + 
  geom_jitter() +  
  geom_smooth(method = loess)

# Scatter plot with 3 or more numerical variables
ggplot(data = table, aes(x = Magnesium, y = Flavanoids, colour = Hue, size = Proline))  + 
  geom_point()

# Load the plotly library for interactive plots
library(plotly)

# Convert ggplot to an interactive plot with plotly
fig <-
  ggplot(data = table, aes(x = Magnesium, y = Flavanoids, colour = Type, size = Proline)) +
  geom_point(alpha = 0.5) + 
  theme_bw()

ggplotly(fig)

# Change the dataset to WWII data and create an interactive plot
fig_example <-
  ggplot(data = table_ww2, aes(x = execution, y = authors_event, colour = authors_event, size = victims)) +
  geom_point(alpha = 0.5) + 
  theme_bw()

ggplotly(fig_example)

# Return to the wine dataset
# Create a correlogram using the GGally package
library(GGally)

ggpairs(data = table[2:5])

# Plot a bar chart for the categorical variable 'Type'
ggplot(data = table, aes(Type)) + geom_bar()

# Boxplot of Proline by Type with jittered points
ggplot(data = table, aes(x = Type, y = Proline))  + 
  geom_boxplot() + 
  geom_jitter()

# Adding colors to the boxplot and jittered points
ggplot(data = table, aes(x = Type, y = Proline, colour = Type))  + 
  geom_boxplot() + 
  geom_jitter()

# Density plot of Proline colored by Type
ggplot(data = table, aes(x = Proline, fill = Type))  + 
  geom_density(alpha = .3)

# Save plots using the ggsave function
# ggsave("file_name.png")

# Specify size when saving plots
# ggsave("wine.png", width = 10, height = 14, units = "cm")


                                                      ###################
                                                      ## Explanation: ##
                                                      ##################

## Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries.

## Load libraries: The library commands load the required packages into the R session.

## Wine dataset background: Comments provide context about the wine dataset, including the number of samples, types of wine, and chemical analyses.

## Read wine dataset: The read.csv function reads data from a CSV file containing wine information and stores it in the table variable.

## Background scatter plot: A basic scatter plot of Magnesium vs Flavanoids.

## Scatter plot: A scatter plot of Magnesium vs Flavanoids using geom_point.

## Customized scatter plot: Adds color and size aesthetics to the scatter plot, with additional labels and titles.

## Add a theme: Demonstrates adding different themes to the scatter plot. theme_grey is used as an example.

## Change to WWII dataset: Reads a new dataset from a CSV file and stores it in the table_ww2 variable.

## WWII scatter plot: Creates a scatter plot of WWII data with custom labels and a minimal theme.

## Return to wine dataset: Continues visualizations using the wine dataset.

## Histogram: Creates a histogram of Alcohol content.

## Density plot: Creates a density plot of Alcohol content.

## Boxplot: Creates a boxplot of Alcohol content.

## Line plot: Creates a line plot of Alcohol vs Color.

## Two-dimensional density plot: Creates a 2D density plot of Alcohol vs Ash, with points overlaid.

## Jitter plot: Creates a jitter plot of Alcohol vs Proline.

## Jitter plot with trend line: Adds a linear trend line to the jitter plot.

## Jitter plot with loess curve: Adds a loess curve to the jitter plot.

## Scatter plot with multiple variables: Creates a scatter plot with Magnesium, Flavanoids, Hue, and Proline.

## Interactive plots with plotly: Converts ggplot scatter plots to interactive plots using plotly.

## Correlogram: Uses the GGally package to create a correlogram of selected variables from the wine dataset.

## Bar chart: Creates a bar chart for the categorical variable 'Type'.

## Boxplot with jitter: Creates a boxplot of Proline by Type, with jittered points.

## Colored boxplot with jitter: Adds color to the boxplot and jittered points.

## Density plot: Creates a density plot of Proline, filled by Type.

## Save plots: Comments show how to save plots using ggsave, including specifying size.