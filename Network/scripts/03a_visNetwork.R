## install.packages("visNetwork")
## install.packages("tidyverse")

################
## visNetwork ##
################

## More information https://datastorm-open.github.io/visNetwork/

# Load the necessary libraries for interactive network visualization and data manipulation
library(visNetwork)
library(tidyverse)

# Load data from CSV files
nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")

# Alternate datasets (commented out)
# nodes <- read_csv("data/NodesArte.csv")
# edges <- read_csv("data/EdgesArte.csv")

# Simple interactive plot using visNetwork
visNetwork(nodes, edges, width = "100%") %>%
  visGroups(groupname = "A", color = "red") %>%
  visGroups(groupname = "B", color = "lightblue") %>%
  visLegend(width = 0.1, position = "right", main = "Group")

# Interactive plot with customized edge width and layout
visNetwork(nodes, 
           edges, 
           width = "100%") %>% 
  visIgraphLayout(layout = "layout_with_fr") %>% 
  visEdges(arrows = "middle")

################################################################################
################################################################################
################################################################################

## Check this out: ## https://datastorm-open.github.io/visNetwork/nodes.html

## install.packages("visNetwork")
## install.packages("tidyverse")

# Load the necessary libraries for interactive network visualization and data manipulation
library(visNetwork)
library(tidyverse)

#######################################
## Customize the nodes in visNetwork ##
#######################################

# Load customized node and edge data from CSV files
nodes <- read.csv("data/nodes_visNetwork_1.csv")
# Sample data preview
# head(nodes)
# id  label group value    shape                     title    color shadow
#  1 Node 1   GrA     1   square <p><b>1</b><br>Node !</p>  darkred  FALSE
#  2 Node 2   GrB     2 triangle <p><b>2</b><br>Node !</p>     grey   TRUE

edges <- read.csv("data/edges_visNetwork_1.csv")

# Create a visNetwork plot with customized nodes
visNetwork(nodes, 
           edges,
           main = "A really simple example of Nodes",
           height = "500px", 
           width = "100%")

## install.packages("visNetwork")
## install.packages("tidyverse")

# Load the necessary libraries for interactive network visualization and data manipulation
library(visNetwork)
library(tidyverse)

#######################################
## Customize the edges in visNetwork ##
#######################################

# Load customized edge and node data from CSV files
edges_1 <- read.csv("data/edges_visNetwork_2.csv")
nodes_1 <- read.csv("data/nodes_visNetwork_2.csv")

# Create a visNetwork plot with customized edges
visNetwork(nodes_1, 
           edges_1, 
           main = "A really simple example of Edges",
           height = "500px", 
           width = "100%")

###################################################
## Create GROUPS, LEGENDS & TITLES in visNetwork ##
###################################################

## Check this out: 
## https://datastorm-open.github.io/visNetwork/groups.html 
## https://datastorm-open.github.io/visNetwork/legend.html

## install.packages("visNetwork")
## install.packages("tidyverse")

# Load the necessary libraries for interactive network visualization and data manipulation
library(visNetwork)
library(tidyverse)

# Load customized node and edge data from CSV files
nodes_3 <- read.csv("data/nodes_visNetwork_3.csv")
edges_3 <- read.csv("data/edges_visNetwork_3.csv")

# 1. Highlight nearest nodes
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE) %>%
  visLayout(randomSeed = 123)

# 2. Select by node ID
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
  visLayout(randomSeed = 123)

# 3. Select by a column (e.g., "group")
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>%
  visOptions(selectedBy = "group") %>%
  visLayout(randomSeed = 123)

# 5. Customize options for node selection and highlighting
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE, 
             nodesIdSelection = list(enabled = TRUE,
                                     selected = "8",
                                     values = c(5:10),
                                     style = 'width: 200px; height: 26px;
                                 background: #f8f8f8;
                                 color: darkblue;
                                 border:none;
                                 outline:none;')) %>%
  visLayout(randomSeed = 123)

# 6. Enable data manipulation features
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(manipulation = TRUE) %>%
  visLayout(randomSeed = 123)

# 7. Use igraph layout for network visualization
visNetwork(nodes_3, edges_3, height = "500px") %>%
  visIgraphLayout() %>%
  visNodes(size = 10)

# Use igraph layout with a circular arrangement
visNetwork(nodes_3, edges_3, height = "500px") %>%
  visIgraphLayout(layout = "layout_in_circle") %>%
  visNodes(size = 10) %>%
  visOptions(highlightNearest = list(enabled = T, hover = T), 
             nodesIdSelection = T)

###################
## Explanation: ##
#################

##   Install necessary packages: The install.packages commands (commented out) suggest installing the required libraries visNetwork and tidyverse.

## Load libraries: The library commands load the visNetwork and tidyverse packages into the R session.

## Load data from CSV files: The read_csv function reads data from CSV files and stores them in the nodes and edges variables.

## Simple interactive plot using visNetwork:
##   visNetwork(nodes, edges, width = "100%"): Initializes a visNetwork plot with the nodes and edges data, setting the width to 100%.
## visGroups(groupname = "A", color = "red"): Defines a group "A" with red color.
## visGroups(groupname = "B", color = "lightblue"): Defines a group "B" with light blue color.
## visLegend(width = 0.1, position = "right", main = "Group"): Adds a legend to the plot.
## Interactive plot with customized edge width and layout:
##   visIgraphLayout(layout = "layout_with_fr"): Applies the Fruchterman-Reingold layout.
## visEdges(arrows = "middle"): Adds arrows to the middle of the edges.

## Customizing nodes and edges:
##   Nodes:
##   read.csv("data/nodes_visNetwork_1.csv"): Loads customized node data.
## visNetwork(nodes, edges, ...): Creates a visNetwork plot with the customized nodes.

## Edges:
##   read.csv("data/edges_visNetwork_2.csv"): Loads customized edge data.
## visNetwork(nodes_1, edges_1, ...): Creates a visNetwork plot with the customized edges.
## Creating groups, legends, and titles:
##   Highlight nearest nodes:
##   visOptions(highlightNearest = TRUE): Highlights the nearest nodes.
## visLayout(randomSeed = 123): Sets the layout with a random seed for reproducibility.

## Select by node ID:
##   visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE): Enables node ID selection and highlighting.

## Select by a column:
##   visOptions(selectedBy = "group"): Enables selection by the "group" column.
## Customize options for node selection and highlighting:
##   nodesIdSelection = list(...): Customizes the node ID selection options.
## Enable data manipulation features:
##   visOptions(manipulation = TRUE): Enables data manipulation features in the plot.

## Use igraph layout:
##   visIgraphLayout(): Applies an igraph layout to the network.
## visNodes(size = 10): Sets the size of the nodes.
## Use igraph layout with a circular arrangement:
##   visIgraphLayout(layout = "layout_in_circle"): Arranges the network in a circle.
## visOptions(highlightNearest = list(enabled = T, hover = T), nodesIdSelection = T): Enables highlighting nearest nodes and node ID selection with hover functionality.