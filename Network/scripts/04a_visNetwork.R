## install.packages("visNetwork")
## install.packages("tidyverse")

################
## visNetwork ##
################

## More information https://datastorm-open.github.io/visNetwork/

library(visNetwork)
library(tidyverse)

# Load data
nodes <- read_csv("data/nodes.csv")
edges <- read_csv("data/edges.csv")

# use a data DataFrame
## nodes <- data.frame(id = 1:10)
## edges <- data.frame(from = c(1,2,5,7,8,10), to = c(9,3,1,6,4,7))

# Simple interactive plot
visNetwork(nodes, 
           edges,
           width = "100%")

# Width attribute
edges <- mutate(edges, 
                width = weight/5 + 1)

# visNetwork edge width plot
visNetwork(nodes, 
           edges, 
           width = "100%") %>% 
  
  visIgraphLayout(layout = "layout_with_fr") %>% 
  
  visEdges(arrows = "middle")