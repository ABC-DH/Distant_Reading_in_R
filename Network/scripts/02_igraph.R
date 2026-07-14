###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install igraph, the package used to create, analyse
# and visualize network objects.
# This command only needs to be run once and is therefore commented out.
# install.packages("igraph")

# Install tidyverse, a collection of packages used for importing
# and manipulating data.
# This command only needs to be run once and is therefore commented out.
# install.packages("tidyverse")


###############################################################################
# LOAD THE REQUIRED LIBRARIES
###############################################################################

library(igraph)     # Creates, analyses and visualizes network objects.
library(tidyverse)  # Imports and manipulates data; here it provides read_csv().


###############################################################################
# IMPORT THE NETWORK DATA
###############################################################################

# Read the nodes.csv file and store the node information in nodes.
nodes <- read_csv("data/nodes.csv")

# Read the edges.csv file and store the relationships in edges.
edges <- read_csv("data/edges.csv")


###############################################################################
# CREATE THE NETWORK OBJECT
###############################################################################

# Create an igraph object from the edge list.
routes_igraph <- graph_from_data_frame(
  d = edges,            # Use edges to define the relationships.
  vertices = nodes,     # Add node attributes from nodes.csv.
  directed = TRUE       # Create a directed network.
)


###############################################################################
# INSPECT THE NETWORK
###############################################################################

# Print a summary of the network object.
routes_igraph


###############################################################################
# GRAPH LAYOUTS
###############################################################################

# A layout determines how the nodes are positioned in the graph.
#
# Different layouts display the same network in different ways.
# Only the position of the nodes changes.
# The relationships remain exactly the same.
#
# Some of the most common layouts are:
#
# layout_in_circle
# Arranges all nodes around a circle.
#
# layout_with_kk
# Places strongly connected nodes closer together
# using the Kamada-Kawai algorithm.
#
# layout_with_fr
# Uses the Fruchterman-Reingold force-directed algorithm.
#
# layout_randomly
# Places the nodes randomly.
#
# layout_as_tree
# Displays the network as a hierarchical tree.
#
# layout_on_grid
# Places the nodes on a regular grid.
#
# layout_on_sphere
# Places the nodes on the surface of a sphere.
#
# layout_nicely
# Automatically selects an appropriate layout.
#
# There is no "best" layout.
# Different layouts highlight different characteristics
# of the same network.


###############################################################################
# PLOT THE NETWORK WITH DEFAULT SETTINGS
###############################################################################

# Create a basic network visualization.
plot(
  routes_igraph,          # Use the previously created network object.
  edge.arrow.size = 0.2   # Set the size of the arrows.
)


###############################################################################
# PLOT THE NETWORK WITH CUSTOM SETTINGS
###############################################################################

# Create a customized network visualization.
plot(routes_igraph, # Use the previously created network object.
     # Node options
     vertex.shape = "square",                     # Set the node shape.
     vertex.color = "red",                        # Set the node colour.
     vertex.size = 10 + sqrt(nodes$value),        # Set the node size.
     vertex.frame.color = "gray",                 # Set the node border colour.
     vertex.label.color = "black",                # Set the label colour.
     vertex.label.cex = 0.8,                      # Set the label size.
     vertex.label.dist = 2,                       # Set the distance between nodes and labels.
    # Edge options
    edge.width = sqrt(nodes$value),              # Set the edge width.
    edge.curved = 0.5,                           # Curve the edges.
    edge.arrow.size = 0.2,                       # Set the arrow size.
    # Layout options
    layout = layout_in_circle                    # Arrange the nodes around a circle.
)
  # Alternative layouts:
  # layout = layout_with_kk
  # layout = layout_with_fr
  # layout = layout_randomly
  # layout = layout_as_tree
  # layout = layout_on_grid
  # layout = layout_on_sphere
  # layout = layout_nicely
