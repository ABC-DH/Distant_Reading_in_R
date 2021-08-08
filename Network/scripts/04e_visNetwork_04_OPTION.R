## Check this out: 
## https://datastorm-open.github.io/visNetwork/groups.html 
## https://datastorm-open.github.io/visNetwork/legend.html

library(visNetwork)
library(tidyverse)
###################################################
## Create GROUPS, LEGENDS & TITLES in visNetwork ##
###################################################

## install.packages("visNetwork")
## install.packages("tidyverse")

# data used in next examples
nb <- 10
nodes <- data.frame(id = 1:nb, label = paste("Label", 1:nb),
                    group = sample(LETTERS[1:3], nb, replace = TRUE), value = 1:nb,
                    title = paste0("<p>", 1:nb,"<br>Tooltip !</p>"), stringsAsFactors = FALSE)

edges <- data.frame(from = c(8,2,7,6,1,8,9,4,6,2),
                    to = c(3,7,2,7,9,1,5,3,2,9),
                    value = rnorm(nb, 10), label = paste("Edge", 1:nb),
                    title = paste0("<p>", 1:nb,"<br>Edge Tooltip !</p>"))

# 1. HIGHLIGHT NEAREST
visNetwork(nodes, edges, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE) %>%
  visLayout(randomSeed = 123)

# 2. HIGHLIGHT NEAREST (DYNAMIC)
visNetwork(nodes, edges, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = list(enabled = T, degree = 2, hover = T)) %>%
  visLayout(randomSeed = 123)

#3. SELECT BY NODE ID
visNetwork(nodes, edges, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
  visLayout(randomSeed = 123)

# 4.SELECT BY A COLUMN
# on "authorised" column
visNetwork(nodes, edges, height = "500px", width = "100%") %>%
  visOptions(selectedBy = "group") %>%
  visLayout(randomSeed = 123)

# 5. CUSTOMIZE OPTIONS
visNetwork(nodes, edges, height = "500px", width = "100%") %>% 
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
visNetwork(nodes, edges, height = "500px", width = "100%") %>% 
  visOptions(manipulation = TRUE) %>%
  visLayout(randomSeed = 123)

# 7. USE IGRAPH LAYOUT
visNetwork(nodes, edges, height = "500px") %>%
  visIgraphLayout() %>%
  visNodes(size = 10)

# USE IGRAPH LAYOUT (in circle)
visNetwork(nodes, edges, height = "500px") %>%
  visIgraphLayout(layout = "layout_in_circle") %>%
  visNodes(size = 10) %>%
  visOptions(highlightNearest = list(enabled = T, hover = T), 
             nodesIdSelection = T)
