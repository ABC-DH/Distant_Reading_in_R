###############
## networkD3 ##
###############

# More information on https://christophergandrud.github.io/networkD3/

# Load necessary libraries for network visualization and data manipulation
library(networkD3)
library(tidyverse)

# Load data from CSV files
nodes_4 <- read_csv("data/nodes_network3d.csv")
edges_4 <- read_csv("data/edges_network3d.csv")

# Adjust node IDs to start at 0
nodes_d3 <- mutate(nodes_4, 
                   id = id - 1)

# Adjust edge IDs to match the node IDs starting at 0
edges_d3 <- mutate(edges_4, 
                   from = from - 1, 
                   to = to - 1)

# Create a simple network plot
networkData <- data.frame(edges_d3$from, edges_d3$to)
simpleNetwork(networkData)

# Create a force-directed network plot
forceNetwork(Links = edges_d3, 
             Nodes = nodes_d3, 
             Source = "from", 
             Target = "to", 
             NodeID = "label", 
             Group = "id", 
             Value = "weight", 
             opacity = 1, 
             fontSize = 16, 
             zoom = TRUE)

# Create a Sankey diagram
sankeyNetwork(Links = edges_d3, 
              Nodes = nodes_d3, 
              Source = "from", 
              Target = "to", 
              NodeID = "label", 
              Value = "weight", 
              fontSize = 16, 
              unit = "Letter(s)")
###################
## Explanation: ##
##################

##   Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries networkD3 and tidyverse.
## Load libraries: The library commands load the networkD3 and tidyverse packages into the R session.
## Load data from CSV files: The read_csv function reads data from CSV files and stores them in the nodes_4 and edges_4 variables.

## Adjust node IDs to start at 0:
##   mutate(nodes_4, id = id - 1): Adjusts the id column in the nodes data to start from 0.

## Adjust edge IDs to match the node IDs starting at 0:
##   mutate(edges_4, from = from - 1, to = to - 1): Adjusts the from and to columns in the edges data to start from 0.

## Create a simple network plot:
##   networkData <- data.frame(edges_d3$from, edges_d3$to): Creates a dataframe for the simple network plot.
## simpleNetwork(networkData): Creates a simple interactive network plot.

## Create a force-directed network plot:
##   forceNetwork(Links = edges_d3, Nodes = nodes_d3, ...): Creates a force-directed network plot with the following options:
##   Links = edges_d3: Sets the edges data.

## Nodes = nodes_d3: Sets the nodes data.
## Source = "from": Specifies the source column in the edges data.
## Target = "to": Specifies the target column in the edges data.
## NodeID = "label": Sets the node labels.
## Group = "id": Sets the group attribute for nodes.
## Value = "weight": Sets the weight attribute for edges.
## opacity = 1: Sets the opacity of the network.
## fontSize = 16: Sets the font size for node labels.
## zoom = TRUE: Enables zoom functionality.

## Create a Sankey diagram:
##   sankeyNetwork(Links = edges_d3, Nodes = nodes_d3, ...): Creates a Sankey diagram with the following options:
##   Links = edges_d3: Sets the edges data.

## Nodes = nodes_d3: Sets the nodes data.

## Source = "from": Specifies the source column in the edges data.
## Target = "to": Specifies the target column in the edges data.
## NodeID = "label": Sets the node labels.
## Value = "weight": Sets the weight attribute for edges.
## fontSize = 16: Sets the font size for node labels.
## unit = "Letter(s)": Sets the unit of measurement for the edges.