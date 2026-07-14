###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install networkD3, the package used to create interactive
# network visualizations and Sankey diagrams.
# This command only needs to be run once and is therefore commented out.
# install.packages("networkD3")

# Install tidyverse, a collection of packages used for importing
# and manipulating data.
# This command only needs to be run once and is therefore commented out.
# install.packages("tidyverse")


###############################################################################
# LOAD THE REQUIRED LIBRARIES
###############################################################################

library(networkD3)  # Creates interactive network visualizations with D3.js.
library(tidyverse)  # Imports and manipulates data; here it provides read_csv() and mutate().


###############################################################################
# IMPORT THE NETWORK DATA
###############################################################################

# Read the nodes_network3d.csv file and store the node information in nodes_4.
nodes_4 <- read_csv("data/nodes_network3d.csv")

# Read the edges_network3d.csv file and store the relationships in edges_4.
edges_4 <- read_csv("data/edges_network3d.csv")


###############################################################################
# PREPARE THE NODE IDENTIFIERS
###############################################################################

# networkD3 requires node identifiers to start at 0 instead of 1.
nodes_d3 <- mutate(
  nodes_4,          # Use the original nodes dataset.
  id = id - 1       # Subtract 1 from each node identifier.
)


###############################################################################
# PREPARE THE EDGE IDENTIFIERS
###############################################################################

# Adjust the source and target identifiers so that they match
# the new node identifiers starting at 0.
edges_d3 <- mutate(
  edges_4,          # Use the original edges dataset.
  from = from - 1,  # Subtract 1 from each source identifier.
  to = to - 1       # Subtract 1 from each target identifier.
)


###############################################################################
# CREATE A SIMPLE INTERACTIVE NETWORK
###############################################################################

# Create a two-column data frame containing the source
# and target node of each connection.
network_data <- data.frame(
  source = edges_d3$from,  # Store the source node identifiers.
  target = edges_d3$to     # Store the target node identifiers.
)

# Create a simple interactive network visualization.
simpleNetwork(
  network_data             # Use the source-target edge list.
)


###############################################################################
# CREATE A FORCE-DIRECTED NETWORK
###############################################################################

# Create an interactive force-directed network.
forceNetwork(
  Links = edges_d3,        # Use the edges dataset.
  Nodes = nodes_d3,        # Use the nodes dataset.
  Source = "from",         # Use from as the source-node column.
  Target = "to",           # Use to as the target-node column.
  NodeID = "label",        # Display the label column as node names.
  Group = "id",            # Assign nodes to groups using the id column.
  Value = "weight",        # Use weight to represent edge importance.
  opacity = 1,             # Make the network fully opaque.
  fontSize = 16,           # Set the size of the node labels.
  zoom = TRUE              # Allow users to zoom and move the network.
)


###############################################################################
# CREATE A SANKEY DIAGRAM
###############################################################################

# Create an interactive Sankey diagram.
sankeyNetwork(
  Links = edges_d3,        # Use the edges dataset.
  Nodes = nodes_d3,        # Use the nodes dataset.
  Source = "from",         # Use from as the source-node column.
  Target = "to",           # Use to as the target-node column.
  NodeID = "label",        # Display the label column as node names.
  Value = "weight",        # Use weight to determine the width of the flows.
  fontSize = 16,           # Set the size of the node labels.
  unit = "Letter(s)"       # Display the unit associated with the flow values.
)

