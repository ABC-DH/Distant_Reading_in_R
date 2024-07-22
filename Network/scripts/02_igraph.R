####################
## igraph package ##
####################

# Load necessary libraries for network analysis and data manipulation
library(igraph)
library(tidyverse)

# Load data from CSV files
nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")

# Create an igraph object
routes_igraph <- graph_from_data_frame(d = edges, 
                                       vertices = nodes, 
                                       directed = TRUE)

# Print igraph object to the console
routes_igraph

# Plot the igraph object with basic settings
plot(routes_igraph, 
     edge.arrow.size = 0.2)  # Set the size of the arrows on the edges

# Plot the igraph object with additional customizations
plot(routes_igraph,
     # Nodes options
     vertex.shape = "square",               # Set the shape of the vertices to square
     vertex.color = "red",                  # Set the color of the vertices to red
     vertex.size = 10 + sqrt(nodes$value),  # Set the size of the vertices based on the 'value' attribute
     vertex.frame.color = "gray",           # Set the color of the vertex frames to gray
     vertex.label.color = "black",          # Set the color of the vertex labels to black
     vertex.label.cex = 0.8,                # Set the size of the vertex labels
     vertex.label.dist = 2,                 # Set the distance of the vertex labels from the vertices
     # Edges options
     edge.width = sqrt(nodes$value),        # Set the width of the edges based on the 'value' attribute
     edge.curved = 0.5,                     # Curve the edges
     edge.arrow.size = 0.2,                 # Set the size of the arrows on the edges
     # Layout options
     #layout = layout_with_kk               # Use the Kamada-Kawai layout (commented out)
     #layout = layout_with_fr               # Use the Fruchterman-Reingold layout (commented out)
     #layout = layout_randomly              # Use a random layout (commented out)
     layout = layout_in_circle              # Arrange vertices in a circle
     #layout = layout.fruchterman.reingold  # Use the Fruchterman-Reingold layout (commented out)
)

# Other graph layouts:
#add_layout_(), component_wise(), layout_as_bipartite(), layout_as_star(), 
#layout_as_tree(), layout_in_circle(), layout_nicely(), layout_on_grid(), 
#layout_on_sphere(), layout_randomly(), layout_with_dh(), layout_with_fr(), 
#layout_with_gem(), layout_with_graphopt(), layout_with_kk(), layout_with_lgl(), 
#layout_with_sugiyama(), layout_(), merge_coords(), norm_coords(), normalize()

                                                                      ###################
                                                                      ## Explanation: ##
                                                                      #################

## Load necessary libraries: The library commands load the igraph package for network analysis and the tidyverse package for data manipulation.
## Load data from CSV files: The read_csv function reads data from CSV files and stores them in the nodes and edges variables.

## Create an igraph object:
## graph_from_data_frame: Creates an igraph object from the edges data.
## d = edges: Specifies the edges dataframe.
## vertices = nodes: Adds attributes to the nodes from the nodes dataframe.
## directed = TRUE: Specifies that the graph is directed.

## Print igraph object: Displays the igraph object in the console to inspect its properties.

## Plot the igraph object with basic settings:
## plot(routes_igraph): Plots the network with the following options:
## edge.arrow.size = 0.2: Sets the size of the arrows on the edges.

## Plot the igraph object with additional customizations:
## plot(routes_igraph): Plots the network with additional customization for nodes, edges, and layout:
## Nodes options:
## vertex.shape = "square": Sets the shape of the vertices to square.
## vertex.color = "red": Sets the color of the vertices to red.
## vertex.size = 10 + sqrt(nodes$value): Sets the size of the vertices based on the 'value' attribute.
## vertex.frame.color = "gray": Sets the color of the vertex frames to gray.
## vertex.label.color = "black": Sets the color of the vertex labels to black.
## vertex.label.cex = 0.8: Sets the size of the vertex labels.
## vertex.label.dist = 2: Sets the distance of the vertex labels from the vertices.

## Edges options:
## edge.width = sqrt(nodes$value): Sets the width of the edges based on the 'value' attribute.
## edge.curved = 0.5: Curves the edges.
## edge.arrow.size = 0.2: Sets the size of the arrows on the edges.

## Layout options:
## layout = layout_in_circle: Arranges vertices in a circle.

## Commented out alternative layout options (layout_with_kk, layout_with_fr, layout_randomly).
## Other graph layouts: Comments list other layout functions available in igraph for creating different network visualizations.Explanation:

##   Load necessary libraries: The library commands load the igraph package for network analysis and the tidyverse package for data manipulation.

## Load data from CSV files: The read_csv function reads data from CSV files and stores them in the nodes and edges variables.

## Create an igraph object:
##   graph_from_data_frame: Creates an igraph object from the edges data.
## d = edges: Specifies the edges dataframe.
## vertices = nodes: Adds attributes to the nodes from the nodes dataframe.
## directed = TRUE: Specifies that the graph is directed.

## Print igraph object: Displays the igraph object in the console to inspect its properties.

## Plot the igraph object with basic settings:
##   plot(routes_igraph): Plots the network with the following options:
##   edge.arrow.size = 0.2: Sets the size of the arrows on the edges.

## Plot the igraph object with additional customizations:
##   plot(routes_igraph): Plots the network with additional customization for nodes, edges, and layout:
##   Nodes options:
##   vertex.shape = "square": Sets the shape of the vertices to square.
##   vertex.color = "red": Sets the color of the vertices to red.
##   vertex.size = 10 + sqrt(nodes$value): Sets the size of the vertices based on the 'value' attribute.
##   vertex.frame.color = "gray": Sets the color of the vertex frames to gray.
##   vertex.label.color = "black": Sets the color of the vertex labels to black.
##   vertex.label.cex = 0.8: Sets the size of the vertex labels.
##   vertex.label.dist = 2: Sets the distance of the vertex labels from the vertices.

## Edges options:
##   edge.width = sqrt(nodes$value): Sets the width of the edges based on the 'value' attribute.
##   edge.curved = 0.5: Curves the edges.
##   edge.arrow.size = 0.2: Sets the size of the arrows on the edges.

## Layout options:
##   layout = layout_in_circle: Arranges vertices in a circle.

## Commented out alternative layout options (layout_with_kk, layout_with_fr, layout_randomly).
## Other graph layouts: Comments list other layout functions available in igraph for creating different network visualizations.