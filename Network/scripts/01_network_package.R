#####################
## network package ##
#####################

# Load necessary libraries for network analysis and data manipulation
library(network)
library(tidyverse)

# Load data from CSV files
nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")

# Create a network object
routes_network <- network(edges, 
                          vertex.attr = nodes, # Add attributes to the nodes
                          matrix.type = "edgelist", # Specify that the edges are given as an edge list
                          ignore.eval = FALSE) # Include edge values

# Print network object to the console
routes_network

# Plot the network with default layout
plot(routes_network, 
     vertex.cex = "number", # Set vertex size based on the 'number' attribute
     displaylabels = TRUE)  # Display labels for each vertex

# Plot the network in a circle layout
plot(routes_network,
     label = network.vertex.names(routes_network), # Display vertex names as labels
     vertex.cex = sqrt(nodes$value), # Set vertex size based on the square root of the 'value' attribute
     mode = "circle", # Arrange vertices in a circle
     #mode = "kamadakawai", # Alternative layout option (commented out)
     #mode = "fruchtermanreingold", # Another alternative layout option (commented out)
     displaylabels = TRUE)  # Display labels for each vertex

                                                                        ###################
                                                                        ## Explanation: ##
                                                                        ##################

## Load necessary libraries: The library commands load the network package for network analysis and the tidyverse package for data manipulation.

## Load data from CSV files: The read_csv function reads data from CSV files and stores them in the nodes and edges variables.

## Create a network object:
##  network: Creates a network object from the edges data.
##  vertex.attr = nodes: Adds attributes to the nodes from the nodes data.
##  matrix.type = "edgelist": Specifies that the edges data is given as an edge list.
##  ignore.eval = FALSE: Includes edge values in the network.

## Print network object: Displays the network object in the console to inspect its properties.

## Plot the network:
##   plot(routes_network): Plots the network with the following options:
##   vertex.cex = "number": Sets the vertex size based on the 'number' attribute.
## displaylabels = TRUE: Displays labels for each vertex.

## Plot the network in a circle layout:
##   plot(routes_network): Plots the network with the following options:
##   label = network.vertex.names(routes_network): Uses vertex names as labels.
## vertex.cex = sqrt(nodes$value): Sets the vertex size based on the square root of the 'value' attribute.
## mode = "circle": Arranges vertices in a circle.
#mode = "kamadakawai": Alternative layout option (commented out).
#mode = "fruchtermanreingold": Another alternative layout option (commented out).
## displaylabels = TRUE: Displays labels for each vertex.