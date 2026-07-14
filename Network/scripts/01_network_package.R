###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install network, the package used to create and analyse network objects.
# This command only needs to be run once and is therefore commented out.
# install.packages("network")

# Install sna, a package that provides additional tools
# and layouts for network analysis.
# This command only needs to be run once and is therefore commented out.
# install.packages("sna")

# Install tidyverse, a collection of packages used for importing
# and manipulating data.
# This command only needs to be run once and is therefore commented out.
# install.packages("tidyverse")


###############################################################################
# LOAD THE REQUIRED LIBRARIES
###############################################################################

library(network)    # Creates and visualizes network objects.
library(sna)        # Provides network analysis functions and graph layouts.
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

# Create a network object from the edge list.
routes_network <- network(
  edges,                       # Use edges to define the connections.
  vertex.attr = nodes,         # Add node attributes from nodes.csv.
  matrix.type = "edgelist",    # Specify that the data is stored as an edge list.
  ignore.eval = FALSE          # Keep additional edge values, if available.
)


###############################################################################
# INSPECT THE NETWORK
###############################################################################

# Print a summary of the network object.
routes_network


###############################################################################
# NETWORK LAYOUTS
###############################################################################

# A layout determines how the nodes are positioned in the graph.
#
# Different layouts display the same network in different ways.
# Only the position of the nodes changes.
# The relationships remain exactly the same.
#
# Some of the most common layouts are:
#
# circle
# Arranges all nodes around a circle.
# Useful for displaying hierarchical or cyclic structures.
#
# kamadakawai
# Places strongly connected nodes closer together.
# Produces compact and easy-to-read networks.
#
# fruchtermanreingold
# Uses a force-directed algorithm.
# One of the most popular layouts for exploring network structure.
#
# random
# Places the nodes randomly.
# Mainly useful for comparison or testing.
#
# mds (Multidimensional Scaling)
# Positions nodes according to their similarities or distances.
# Often used in social network analysis.
#
# geodist
# Positions nodes according to their geodesic (shortest path) distances.
#
# target
# Places one selected node at the centre of the graph,
# highlighting its relationships with the other nodes.
#
# eigen
# Positions nodes according to the eigenvectors of the network.
# Useful for highlighting the overall structure.
#
# There is no "best" layout.
# Different layouts highlight different characteristics
# of the same network.


###############################################################################
# PREPARE THE GRAPH
###############################################################################

# Create proportional node sizes.
# The square root reduces large differences between node sizes.
node_size <- 1 + 2 * sqrt(nodes$value / max(nodes$value))

# Reduce the margins around the graph.
par(mar = c(1, 1, 1, 1))


###############################################################################
# PLOT THE NETWORK WITH THE DEFAULT LAYOUT
###############################################################################

# Create a basic network visualization.
plot(
  routes_network,           # Use the previously created network object.
  vertex.cex = node_size,   # Set the node size.
  displaylabels = TRUE      # Display the node names.
)


###############################################################################
# PLOT THE NETWORK WITH A CIRCULAR LAYOUT
###############################################################################

# Create a network visualization using a circular layout.
plot(
  routes_network,                                # Use the network object.
  label = network.vertex.names(routes_network),  # Display the node names.
  vertex.cex = node_size,                        # Set the node size.
  label.cex = 0.8,                               # Set the label size.
  mode = "circle",                               # Arrange the nodes around a circle.
  pad = 1.5,                                     # Leave space around the graph.
  displaylabels = TRUE                           # Display the node labels.
)


###############################################################################
# PLOT THE NETWORK WITH THE KAMADA-KAWAI LAYOUT
###############################################################################

# Create a network visualization using the Kamada-Kawai layout.
plot(
  routes_network,                                # Use the network object.
  label = network.vertex.names(routes_network),  # Display the node names.
  vertex.cex = node_size,                        # Set the node size.
  label.cex = 0.8,                               # Set the label size.
  mode = "kamadakawai",                          # Place connected nodes closer together.
  pad = 1.5,                                     # Leave space around the graph.
  displaylabels = TRUE                           # Display the node labels.
)


###############################################################################
# PLOT THE NETWORK WITH THE FRUCHTERMAN-REINGOLD LAYOUT
###############################################################################

# Create a network visualization using the Fruchterman-Reingold layout.
plot(
  routes_network,                                # Use the network object.
  label = network.vertex.names(routes_network),  # Display the node names.
  vertex.cex = node_size,                        # Set the node size.
  label.cex = 0.8,                               # Set the label size.
  mode = "fruchtermanreingold",                  # Apply a force-directed layout.
  pad = 1.5,                                     # Leave space around the graph.
  displaylabels = TRUE                           # Display the node labels.
)

