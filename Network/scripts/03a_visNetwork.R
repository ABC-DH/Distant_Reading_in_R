###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install visNetwork, the package used to create interactive networks.
# This command only needs to be run once and is therefore commented out.
# install.packages("visNetwork")

# Install tidyverse, a collection of packages used for importing
# and manipulating data.
# This command only needs to be run once and is therefore commented out.
# install.packages("tidyverse")


###############################################################################
# LOAD THE REQUIRED LIBRARIES
###############################################################################

library(visNetwork)  # Creates and customizes interactive network visualizations.
library(tidyverse)   # Imports and manipulates data; here it provides read_csv().


###############################################################################
# IMPORT THE NETWORK DATA
###############################################################################

# Read the nodes.csv file and store the node information in nodes.
nodes <- read_csv("data/nodes.csv")

# Read the edges.csv file and store the relationships in edges.
edges <- read_csv("data/edges.csv")

# Alternative datasets:
# nodes <- read_csv("data/NodesArte.csv")
# edges <- read_csv("data/EdgesArte.csv")


###############################################################################
# CREATE A SIMPLE INTERACTIVE NETWORK
###############################################################################

# Create an interactive network with groups and a legend.
visNetwork(
  nodes,                             # Use the nodes dataset.
  edges,                             # Use the edges dataset.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  
  visGroups(
    groupname = "A",                 # Customize the nodes belonging to group A.
    color = "red"                    # Set the colour of group A.
  ) %>%
  
  visGroups(
    groupname = "B",                 # Customize the nodes belonging to group B.
    color = "lightblue"              # Set the colour of group B.
  ) %>%
  
  visLegend(
    width = 0.1,                     # Set the width of the legend.
    position = "right",              # Place the legend on the right.
    main = "Group"                   # Add a title to the legend.
  )


###############################################################################
# APPLY AN IGRAPH LAYOUT
###############################################################################

# Create an interactive network using the Fruchterman-Reingold layout.
visNetwork(
  nodes,                             # Use the nodes dataset.
  edges,                             # Use the edges dataset.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  
  visIgraphLayout(
    layout = "layout_with_fr"        # Apply the Fruchterman-Reingold layout.
  ) %>%
  
  visEdges(
    arrows = "middle"                # Display arrows in the middle of the edges.
  )

###############################################################################
# CUSTOMIZE THE NODES
###############################################################################

# More information:
# https://datastorm-open.github.io/visNetwork/nodes.html

# Read a dataset containing customized node properties.
nodes_custom <- read_csv("data/nodes_visNetwork_1.csv")

# Read the corresponding edge dataset.
edges_custom <- read_csv("data/edges_visNetwork_1.csv")

# The nodes dataset can contain columns such as:
#
# id       Unique identifier of the node.
# label    Text displayed on the node.
# group    Group to which the node belongs.
# value    Numerical value used to determine node size.
# shape    Shape of the node.
# title    Text displayed when the pointer is placed over the node.
# color    Colour of the node.
# shadow   Indicates whether the node has a shadow.

# Create an interactive network using the node properties stored in the CSV.
visNetwork(
  nodes_custom,                      # Use the customized nodes.
  edges_custom,                      # Use the corresponding edges.
  main = "A simple example of customized nodes", # Add a title.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
)

###############################################################################
# CUSTOMIZE THE EDGES
###############################################################################

# Read a dataset containing customized edge properties.
edges_custom_2 <- read_csv("data/edges_visNetwork_2.csv")

# Read the corresponding node dataset.
nodes_custom_2 <- read_csv("data/nodes_visNetwork_2.csv")

# The edges dataset can contain columns such as:
#
# from     Identifier of the source node.
# to       Identifier of the target node.
# arrows   Position and direction of the arrow.
# color    Colour of the edge.
# width    Width of the edge.
# dashes   Indicates whether the edge is dashed.
# title    Text displayed when the pointer is placed over the edge.

# Create an interactive network using the edge properties stored in the CSV.
visNetwork(
  nodes_custom_2,                    # Use the corresponding nodes.
  edges_custom_2,                    # Use the customized edges.
  main = "A simple example of customized edges", # Add a title.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
)


###############################################################################
# GROUPS, LEGENDS AND INTERACTIVE OPTIONS
###############################################################################

# More information:
# https://datastorm-open.github.io/visNetwork/groups.html
# https://datastorm-open.github.io/visNetwork/legend.html

# Read the nodes used in the following interactive examples.
nodes_options <- read_csv("data/nodes_visNetwork_3.csv")

# Read the corresponding edges.
edges_options <- read_csv("data/edges_visNetwork_3.csv")


###############################################################################
# 1. HIGHLIGHT NEAREST NODES
###############################################################################

# Highlight the nodes directly connected to the selected node.
visNetwork(
  nodes_options,                     # Use the nodes dataset.
  edges_options,                     # Use the edges dataset.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  visOptions(
    highlightNearest = TRUE          # Highlight the nearest connected nodes.
  ) %>%
  visLayout(
    randomSeed = 123                 # Keep the same node positions at each run.
  )


###############################################################################
# 2. SELECT A NODE BY ITS IDENTIFIER
###############################################################################

# Add a menu that allows the user to select a node by its identifier.
visNetwork(
  nodes_options,                     # Use the nodes dataset.
  edges_options,                     # Use the edges dataset.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  visOptions(
    highlightNearest = TRUE,         # Highlight the nearest connected nodes.
    nodesIdSelection = TRUE          # Enable node selection by identifier.
  ) %>%
  visLayout(
    randomSeed = 123                 # Keep the same node positions at each run.
  )


###############################################################################
# 3. SELECT NODES BY A COLUMN
###############################################################################

# Add a menu that allows the user to select nodes according to their group.
visNetwork(
  nodes_options,                     # Use the nodes dataset.
  edges_options,                     # Use the edges dataset.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  visOptions(
    selectedBy = "group"             # Enable selection using the group column.
  ) %>%
  visLayout(
    randomSeed = 123                 # Keep the same node positions at each run.
  )


###############################################################################
# 4. CUSTOMIZE THE NODE SELECTION MENU
###############################################################################

# Create and customize a menu for selecting nodes by identifier.
visNetwork(
  nodes_options,                     # Use the nodes dataset.
  edges_options,                     # Use the edges dataset.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  visOptions(
    highlightNearest = TRUE,         # Highlight the nearest connected nodes.
    
    nodesIdSelection = list(
      enabled = TRUE,                # Enable node selection.
      selected = "8",                # Select node 8 when the graph opens.
      values = 5:10,                 # Show only these node identifiers.
      style = paste0(
        "width: 200px;",
        "height: 26px;",
        "background: #f8f8f8;",
        "color: darkblue;",
        "border: none;",
        "outline: none;"
      )                              # Customize the appearance of the menu.
    )
  ) %>%
  visLayout(
    randomSeed = 123                 # Keep the same node positions at each run.
  )


###############################################################################
# 5. ENABLE NETWORK MANIPULATION
###############################################################################

# Allow users to add, edit or remove nodes and edges interactively.
visNetwork(
  nodes_options,                     # Use the nodes dataset.
  edges_options,                     # Use the edges dataset.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  visOptions(
    manipulation = TRUE              # Enable the manipulation controls.
  ) %>%
  visLayout(
    randomSeed = 123                 # Keep the same node positions at each run.
  )


###############################################################################
# 6. USE AN AUTOMATIC IGRAPH LAYOUT
###############################################################################

# Create an interactive network using a layout calculated by igraph.
visNetwork(
  nodes_options,                     # Use the nodes dataset.
  edges_options,                     # Use the edges dataset.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  
  visIgraphLayout() %>%              # Apply an automatically selected igraph layout.
  visNodes(
    size = 10                        # Set the size of all nodes.
  )


###############################################################################
# 7. USE A CIRCULAR IGRAPH LAYOUT
###############################################################################

# Create an interactive network using a circular arrangement.
visNetwork(
  nodes_options,                     # Use the nodes dataset.
  edges_options,                     # Use the edges dataset.
  height = "500px",                  # Set the height of the visualization.
  width = "100%"                     # Use all the available horizontal space.
) %>%
  visIgraphLayout(
    layout = "layout_in_circle"      # Arrange all nodes around a circle.
  ) %>%
  visNodes(
    size = 10                        # Set the size of all nodes.
  ) %>%
  visOptions(
    highlightNearest = list(
      enabled = TRUE,                # Enable highlighting of connected nodes.
      hover = TRUE                   # Highlight connected nodes on mouse hover.
    ),
    nodesIdSelection = TRUE          # Enable node selection by identifier.
  )

