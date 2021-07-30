################
## visNetwork ##
################

library(visNetwork)
library(tidyverse)

# Load data
nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")

# Simple interactive plot
visNetwork(nodes, edges, width = "100%")

# Width attribute
edges <- mutate(edges, width = weight/5 + 1)

# visNetwork edge width plot
visNetwork(nodes, edges, width = "100%") %>% 
  visIgraphLayout(layout = "layout_with_fr") %>% 
  visEdges(arrows = "middle")

