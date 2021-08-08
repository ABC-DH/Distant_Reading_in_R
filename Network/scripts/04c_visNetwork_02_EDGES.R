## Check this out: ## https://datastorm-open.github.io/visNetwork/edges.html

## install.packages("visNetwork")
## install.packages("tidyverse")

library(visNetwork)
library(tidyverse)

#######################################
## Custumise the edges in visNetwork ##
#######################################

## 1.EDGES
edges_1 <- data.frame(from = sample(1:10,8), to = sample(1:10, 8),
                    
                    # add labels on edges                  
                    label = paste("Edge", 1:8),
                    
                    # length
                    length = c(100,500),
                    
                    # width
                    width = c(4,1),
                    
                    # arrows
                    arrows = c("to", "from", "middle", "middle;to"),
                    
                    # dashes
                    dashes = c(TRUE, FALSE),
                    
                    # tooltip (html or character)
                    title = paste("Edge", 1:8),
                    
                    # smooth
                    smooth = c(FALSE, TRUE),
                    
                    # shadow
                    shadow = c(FALSE, TRUE, FALSE, TRUE)) 

# head(edges)
#  from to  label length    arrows dashes  title smooth shadow
#    10  7 Edge 1    100        to   TRUE Edge 1  FALSE  FALSE
#     4 10 Edge 2    500      from  FALSE Edge 2   TRUE   TRUE

nodes_1 <- data.frame(id = 1:10, group = c("A", "B"))

visNetwork(nodes_1, edges_1, height = "500px", width = "100%")

## 2. GLOBAL CONFIGURATIONS - CLICK TO CHANGE THE COLORS OF THE EDGES
nodes_2 <- data.frame(id = 1:4)
edges_2 <- data.frame(from = c(2,4,3,2), 
                      to = c(1,2,4,3))
                      # dashes = c(FALSE, TRUE)) # add dashes to edges

visNetwork(nodes_2, edges_2, width = "100%") %>% 
  visEdges(shadow = TRUE,
           arrows =list(to = list(enabled = TRUE, scaleFactor = 2)),
           color = list(color = "lightblue", highlight = "red")) %>%
  visLayout(randomSeed = 12) # to have always the same network     

## 3. USE COMPLEX CONFIGURATION INDIVIDUALLY
nodes <- data.frame(id = 1:3, 
                    color.background = c("red", "blue", "green"),
                    color.highlight.background = c("red", NA, "red"), 
                    shadow.size = c(5, 10, 15))

edges <- data.frame(from = c(1,2), to = c(1,3),
                    label = LETTERS[1:2], 
                    font.color =c ("red", "blue"), 
                    font.size = c(10,20))

visNetwork(nodes, edges)  



