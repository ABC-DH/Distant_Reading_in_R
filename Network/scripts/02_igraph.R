####################
## igraph package ##
####################

library(igraph)
library(tidyverse)

# Load data
nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")


# igraph object
routes_igraph <- graph_from_data_frame(d = edges, 
                                       vertices = nodes, 
                                       directed = TRUE)

# Print igraph object
routes_igraph

# igraph plot
plot(routes_igraph, 
     edge.arrow.size = 0.2)

# igraph-graphopt-plot
plot(routes_igraph,
     #nodes options
     vertex.shape="square",
     vertex.color="red", 
     vertex.size = 10 + sqrt(nodes$value),
     
     vertex.frame.color="gray", 
     vertex.label.color="black",
     vertex.label.cex=0.8, 
     vertex.label.dist=2,
     #edges options
     edge.width = sqrt(nodes$value),
     edge.curved=0.5,
     edge.arrow.size = 0.2,
     #layout = layout_with_kk
     #layout=layout_with_fr
     #layout = layout_randomly
     layout = layout_in_circle
     #layout=layout_in_circle
     #layout = layout.fruchterman.reingold
                                            )

# Other graph layouts: 
#add_layout_(), component_wise(), layout_as_bipartite(), layout_as_star(), 
#layout_as_tree(), layout_in_circle(), layout_nicely(), layout_on_grid(), 
#layout_on_sphere(), layout_randomly(), layout_with_dh(), layout_with_fr(), 
#layout_with_gem(), layout_with_graphopt(), layout_with_kk(), layout_with_lgl(), 
#layout_with_sugiyama(), layout_(), merge_coords(), norm_coords(), normalize()