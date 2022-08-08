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

#nodes <- read_csv("data/NodesArte.csv")
#edges <- read_csv("data/EdgesArte.csv")

# use a data DataFrame
## nodes <- data.frame(id = 1:10)
## edges <- data.frame(from = c(1,2,5,7,8,10), to = c(9,3,1,6,4,7))

  
# Simple interactive plot
visNetwork(nodes, edges, width = "100%") %>%
  visGroups(groupname = "A", color = "red") %>%
  visGroups(groupname = "B", color = "lightblue") %>%
  visLegend(width = 0.1, position = "right", main = "Group")


# visNetwork edge width plot
visNetwork(nodes, 
           edges, 
           width = "100%") %>% 
  
  visIgraphLayout(layout = "layout_with_fr") %>% 
  
  visEdges(arrows = "middle")

################################################################################
################################################################################
################################################################################

## Check this out: ## https://datastorm-open.github.io/visNetwork/nodes.html

## install.packages("visNetwork")
## install.packages("tidyverse")

library(visNetwork)
library(tidyverse)

#######################################
## Custumise the nodes in visNetwork ##
#######################################

nodes <- read.csv("data/nodes_visNetwork_1.csv")
# head(nodes)
# id  label group value    shape                     title    color shadow
#  1 Node 1   GrA     1   square <p><b>1</b><br>Node !</p>  darkred  FALSE
#  2 Node 2   GrB     2 triangle <p><b>2</b><br>Node !</p>     grey   TRUE

edges <- read.csv("data/edges_visNetwork_1.csv")

visNetwork(nodes, 
           edges,
           main = "A really simple example of Nodes",
           height = "500px", 
           width = "100%")

## install.packages("visNetwork")
## install.packages("tidyverse")

library(visNetwork)
library(tidyverse)

#######################################
## Custumise the edges in visNetwork ##
#######################################

## 1.EDGES
edges_1 <- read.csv("data/edges_visNetwork_2.csv")
nodes_1 <- read.csv("data/nodes_visNetwork_2.csv")

visNetwork(nodes_1, 
           edges_1, 
           main = "A really simple example of Edges",
           height = "500px", 
           width = "100%")


###################################################
## Create GROUPS, LEGENDS & TITLES in visNetwork ##
###################################################

## Check this out: 
## https://datastorm-open.github.io/visNetwork/groups.html 
## https://datastorm-open.github.io/visNetwork/legend.html


## install.packages("visNetwork")
## install.packages("tidyverse")

library(visNetwork)
library(tidyverse)
nodes_3 <- read.csv("data/nodes_visNetwork_3")
edges_3 <- read.csv("data/edges_visNetwork_3")

# 1. HIGHLIGHT NEAREST
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE) %>%
  visLayout(randomSeed = 123)

# 2. HIGHLIGHT NEAREST (DYNAMIC)
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = list(enabled = T, degree = 2, hover = T)) %>%
  visLayout(randomSeed = 123)

#3. SELECT BY NODE ID
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
  visLayout(randomSeed = 123)

# 4.SELECT BY A COLUMN
# on "authorised" column
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>%
  visOptions(selectedBy = "group") %>%
  visLayout(randomSeed = 123)

# 5. CUSTOMIZE OPTIONS
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE, 
             nodesIdSelection = list(enabled = TRUE,
                                     selected = "8",
                                     values = c(5:10),
                                     style = 'width: 200px; height: 26px;
                                 background: #f8f8f8;
                                 color: darkblue;
                                 border:none;
                                 outline:none;')) %>%
  visLayout(randomSeed = 123)

# 6. DATA MANIPULATION
visNetwork(nodes_3, edges_3, height = "500px", width = "100%") %>% 
  visOptions(manipulation = TRUE) %>%
  visLayout(randomSeed = 123)

# 7. USE IGRAPH LAYOUT
visNetwork(nodes_3, edges_3, height = "500px") %>%
  visIgraphLayout() %>%
  visNodes(size = 10)

# USE IGRAPH LAYOUT (in circle)
visNetwork(nodes_3, edges_3, height = "500px") %>%
  visIgraphLayout(layout = "layout_in_circle") %>%
  visNodes(size = 10) %>%
  visOptions(highlightNearest = list(enabled = T, hover = T), 
             nodesIdSelection = T)

