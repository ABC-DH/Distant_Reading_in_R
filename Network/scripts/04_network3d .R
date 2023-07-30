###############
## networkD3 ##
###############

# more information on https://christophergandrud.github.io/networkD3/

library(networkD3)
library(tidyverse)

# Load data
nodes_4 <- read_csv("data/nodes_network3d.csv")
edges_4 <- read_csv("data/edges_network3d.csv")

# Redo id numbers to have them begin at 0
nodes_d3 <- mutate(nodes_4, 
                   id = id - 1)

edges_d3 <- mutate(edges_4, 
                   from = from - 1, 
                   to = to - 1)

# simpleNetwork
networkData <- data.frame(edges_d3$from, edges_d3$to)

simpleNetwork(networkData)

# d3 force-network plot
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

# Sankey diagram
sankeyNetwork(Links = edges_d3, 
              Nodes = nodes_d3, 
              Source = "from", 
              Target = "to", 
              NodeID = "label", 
              Value = "weight", 
              fontSize = 16, 
              unit = "Letter(s)")


