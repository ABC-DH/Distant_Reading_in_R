## Check this out: ## https://datastorm-open.github.io/visNetwork/nodes.html

## install.packages("visNetwork")
## install.packages("tidyverse")

library(visNetwork)
library(tidyverse)

#######################################
## Custumise the nodes in visNetwork ##
#######################################

nodes <- data.frame(id = 1:10,
                    
                    # add labels on nodes
                    label = paste("Node", 1:10),
                    
                    # add groups on nodes 
                    group = c("GrA", "GrB"),
                    
                    # size adding value
                    value = 1:10,          
                    
                    # control shape of nodes
                    shape = c("square", "triangle", "box", "circle", "dot", "star",
                              "ellipse", "database", "text", "diamond"),
                    
                    # tooltip (html or character), when the mouse is above
                    title = paste0("<p><b>", 1:10,"</b><br>Node !</p>"),
                    
                    # color
                    color = c("darkred", "grey", "orange", "darkblue", "purple"),
                    
                    # shadow
                    shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE))             

# head(nodes)
# id  label group value    shape                     title    color shadow
#  1 Node 1   GrA     1   square <p><b>1</b><br>Node !</p>  darkred  FALSE
#  2 Node 2   GrB     2 triangle <p><b>2</b><br>Node !</p>     grey   TRUE

edges <- data.frame(from = c(1,2,5,7,8,10), to = c(9,3,1,6,4,7))

visNetwork(nodes, edges, height = "500px", width = "100%")
