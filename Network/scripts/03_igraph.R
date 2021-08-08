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
     layout = layout_with_graphopt, 
     edge.arrow.size = 0.2)

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
  scale_edge_width(range = c(0.2, 2)) +
  geom_node_text(aes(label = label)) +
  labs(edge_width = "Letters") +
  theme_graph()


