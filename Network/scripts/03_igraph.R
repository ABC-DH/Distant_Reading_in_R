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
     vertex.shape="sphere",
     vertex.color="gold", 
     vertex.size = 10 + sqrt(nodes$weight),
     
     vertex.frame.color="gray", 
     vertex.label.color="black",
     vertex.label.cex=0.8, 
     vertex.label.dist=2,
     #edges options
     edge.width = sqrt(nodes$weight),
     edge.curved=0.5,
     edge.arrow.size = 0.2,
     #layout = layout_with_kk
     #layout=layout_with_fr
     #layout = layout_randomly
     layout = layout_with_graphopt
     #layout=layout_in_circle
     #layout = layout.fruchterman.reingold
                                            )

# Other graph layouts: 
#add_layout_(), component_wise(), layout_as_bipartite(), layout_as_star(), 
#layout_as_tree(), layout_in_circle(), layout_nicely(), layout_on_grid(), 
#layout_on_sphere(), layout_randomly(), layout_with_dh(), layout_with_fr(), 
#layout_with_gem(), layout_with_graphopt(), layout_with_kk(), layout_with_lgl(), 
#layout_with_sugiyama(), layout_(), merge_coords(), norm_coords(), normalize()


# Load libraries
library(tidygraph)
library(ggraph)

# edge list and node list to tbl_graph
routes_tidy <- tbl_graph(nodes = nodes, 
                         edges = edges, 
                         directed = TRUE)

# igraph to tbl_graph
routes_igraph_tidy <- as_tbl_graph(routes_igraph)

# Show classes of objects
class(routes_tidy)
class(routes_igraph_tidy)
class(routes_igraph)

# Print routes tidy
routes_tidy

# Activate edges
routes_tidy %>% 
  activate(edges) %>% 
  arrange(desc(weight))

# Basic ggraph plot
ggraph(routes_tidy) + geom_edge_link() + geom_node_point() + theme_graph()

# More complex ggraph plot
ggraph(routes_tidy, 
       layout = "graphopt") + 
  geom_node_point() +
  geom_edge_link(aes(width = weight), 
                 alpha = 0.8) + 
  scale_edge_width(range = c(0.2, 2)) +
  geom_node_text(aes(label = label), 
                 repel = TRUE) +
  labs(edge_width = "Letters") +
  theme_graph()

# ggraph arc plot
ggraph(routes_igraph, 
       layout = "linear") + 
  geom_edge_arc(aes(width = weight), 
                alpha = 0.8) + 
  scale_edge_width(range = c(0.8, 2)) +
  geom_node_text(aes(label = label)) +
  labs(edge_width = "Letters") +
  theme_graph()


