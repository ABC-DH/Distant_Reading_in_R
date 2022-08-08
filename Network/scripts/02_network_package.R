#####################
## network package ##
#####################

library(network)
library(tidyverse)

# Load data
nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")

# network object
routes_network <- network(edges, 
                          vertex.attr = nodes,
                          matrix.type = "edgelist",
                          ignore.eval = FALSE)

# Print network object
routes_network

# network plot
plot(routes_network, 
     vertex.cex = "number",
     displaylabels = TRUE)

# network circle plot
plot(routes_network,
     label = network.vertex.names(routes_network),
     vertex.cex = sqrt(nodes$value),
     #mode = "circle",
     #mode = "kamadakawai",
     mode = "fruchtermanreingold",
     displaylabels = TRUE)



