### Introduction to Network Analysis with R ###

## packages
##install.packages("tidyverse")
##install.packages("network")
##install.packages("igraph")
##install.packages("visNetwork")
##install.packages("networkD3")
##install.packages("ggraph")

# This script goes along with the blog post of the same name,
# which can be found at https://www.jessesadler.com/post/network-analysis-with-r/

library(tidyverse)

# Load data
letters <- read_csv("data/correspondence-data-1585.csv")

################################
## Create node and edge lists ##
################################

### Node list ###
sources <- letters %>%
  distinct(source) %>%
  rename(label = source)

destinations <- letters %>%
  distinct(destination) %>%
  rename(label = destination)

nodes <- full_join(sources, destinations, by = "label")

# Create id column and reorder columns
nodes <- add_column(nodes, id = 1:nrow(nodes)) %>% 
  select(id, everything())

### Edge list ###
per_route <- letters %>%  
  group_by(source, destination) %>%
  summarise(weight = n()) %>% 
  ungroup()

# Join with node ids and reorder columns
edges <- per_route %>% 
  left_join(nodes, by = c("source" = "label")) %>% 
  rename(from = id)

edges <- edges %>% 
  left_join(nodes, by = c("destination" = "label")) %>% 
  rename(to = id)

edges <- select(edges, from, to, weight)