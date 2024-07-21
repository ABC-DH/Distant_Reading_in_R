# Libraries
# install.packages("ggplot2")
# install.packages("dplyr")
# install.packages("plotly")
# install.packages("hrbrthemes")

# Load the required libraries for data manipulation and visualization
library(ggplot2)
library(dplyr)
library(plotly)
library(hrbrthemes)

# Load the dataset from a CSV file and store it in the 'data' variable
data <- read.csv("data/music.csv")
# data <- read.csv("data/music_2.csv")  # Another dataset option (commented out)

# Customize font properties for the plot
f <- list(
  family = "Arial, monospace",
  size = 14,
  color = "#7f7f7f"
)

# Customize x-axis properties
x <- list(
  title = "Anni",
  titlefont = f
)

# Customize y-axis properties
y <- list(
  title = "Numero di ricerche",
  titlefont = f
)

# Add annotations to the plot
a <- list(
  text = "Giovanni Pietro Vitali - UVSQ-Paris-Saclay (giovanni.vitali@uvsq.fr)",
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.8,
  y = 0.985,
  showarrow = FALSE
)

b <- list(
  text = "",
  font = f,
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.5,
  y = 0.95,
  showarrow = FALSE
)

# Create an area chart with multiple groups
p <- plot_ly(x = data$months, 
             y = data$rap,
             type = "scatter", 
             mode = "markers", 
             fill = "tozeroy",
             name = "Rap") 

p <- p %>% add_trace(y = data$trap, 
                     name = "Trap") 

p <- p %>% add_trace(y = data$hip_hop, 
                     name = "Hip Hop") 

p <- p %>% add_trace(y = data$classical_music, 
                     name = "Classical Music") 

p <- p %>% add_trace(y = data$patchanka, 
                     name = "Patchanka") 

p <- p %>% add_trace(y = data$folk, 
                     name = "Folk") 

p <- p %>% add_trace(y = data$punk, 
                     name = "Punk") 

p <- p %>% add_trace(y = data$rock, 
                     name = "Rock") 

# Customize the layout of the plot
p <- p %>% layout(xaxis = x, 
                  yaxis = y, 
                  title = "Ricerche su Google su generi musicali (2004-2020)", 
                  annotations = list(a, b))

# Display the plot
p

                                                        ###################
                                                        ## Explanation: ##
                                                        ##################

## Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries.
## Load libraries: The library commands load the ggplot2, dplyr, plotly, and hrbrthemes packages into the R session.
## Read the dataset: The read.csv function reads data from a CSV file and stores it in the data variable.
## Customize font properties: The f list defines the font properties (family, size, color) to be used in the plot.
## Customize x-axis properties: The x list sets the title and title font for the x-axis.
## Customize y-axis properties: The y list sets the title and title font for the y-axis.

## Add annotations:
##    a: Contains the first annotation with text, positioning, and other properties.
##    b: Contains an empty annotation for potential future use, with font properties defined.
## Create an area chart with multiple groups:
##    plot_ly: Initializes a plotly plot.
##    x = data$months: Sets the x-axis values to the 'months' column from the dataset.
##    y = data$rap: Sets the y-axis values to the 'rap' column from the dataset.
##    type = "scatter": Specifies that the plot is a scatter plot.
##    mode = "markers": Specifies that individual markers should be shown.
##    fill = "tozeroy": Fills the area under the lines down to the y=0 line.
##    name = "Rap": Names this trace "Rap".
##    add_trace: Adds additional traces to the plot for other genres (Trap, Hip Hop, Classical Music, Patchanka, Folk, Punk, Rock).

## Customize plot layout:
##    layout: Customizes the layout of the plot.
##    xaxis = x: Applies the x-axis properties defined earlier.
##    yaxis = y: Applies the y-axis properties defined earlier.
##    title = "Ricerche su Google su generi musicali (2004-2020)": Sets the plot title.
##    annotations = list(a, b): Adds the annotations to the plot.
##    Display the plot: The final line displays the plot with the defined properties and data.