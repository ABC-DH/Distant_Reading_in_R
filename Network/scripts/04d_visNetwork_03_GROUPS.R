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

## 1. GROUPS
nodes <- data.frame(id = 1:5, group = c(rep("A", 2), rep("B", 3)))
edges <- data.frame(from = c(2,5,3,3), to = c(1,2,4,2))

visNetwork(nodes, edges, width = "100%") %>% 
  # darkblue square with shadow for group "A"
  visGroups(groupname = "A", color = "darkblue", shape = "square", 
            shadow = list(enabled = TRUE)) %>% 
  # red triangle for group "B"
  visGroups(groupname = "B", color = "red", shape = "triangle") 

## 2. TITLES
nodes <- data.frame(id = 1:3, group = c("B", "A", "B"))
edges <- data.frame(from = c(1,2), to = c(2,3))

# default, on group
visNetwork(nodes, edges, main = "A really simple example", width = "100%")

## 3. LEGEND BASED ON GROUPS
# default, on group
visNetwork(nodes, edges, width = "100%") %>%
  visGroups(groupname = "A", color = "red") %>%
  visGroups(groupname = "B", color = "lightblue") %>%
  visLegend()

## 4. PLACEMENT & TITLE

visNetwork(nodes, edges, width = "100%") %>%
  visGroups(groupname = "A", color = "red") %>%
  visGroups(groupname = "B", color = "lightblue") %>%
  visLegend(width = 0.1, position = "right", main = "Group")

## 5. CUSTOM NODES/EDGES
# nodes data.frame for legend
lnodes <- data.frame(label = c("Group A", "Group B"),
                     shape = c( "ellipse"), color = c("red", "lightblue"),
                     title = "Informations", id = 1:2)

# edges data.frame for legend
ledges <- data.frame(color = c("lightblue", "red"),
                     label = c("reverse", "depends"), arrows =c("to", "from"))

visNetwork(nodes, edges, width = "100%") %>%
  visGroups(groupname = "A", color = "red") %>%
  visGroups(groupname = "B", color = "lightblue") %>%
  visLegend(addEdges = ledges, addNodes = lnodes, useGroups = FALSE)

## 6. MORE COMPLEX ELEMENT
nodes <- data.frame(id = 1:3, group = c("B", "A", "B"))
edges <- data.frame(from = c(1,2), to = c(2,3),color = c("lightblue", "red"),
                    label = c("reverse", "depends"), arrows =c("to", "from"))

visNetwork(nodes, edges) %>%
  visGroups(groupname = "A", shape = "icon", 
            icon = list(code = "f0c0", size = 75)) %>%
  visGroups(groupname = "B", shape = "icon", 
            icon = list(code = "f007", color = "red")) %>%
  addFontAwesome() %>%
  visLegend(addEdges = ledges, 
            addNodes = list(list(label = "Group", 
                                 shape = "icon",
                                 icon = list(code = "f0c0", 
                                             size = 25)),
    list(label = "User", shape = "icon", 
         icon = list(code = "f007", size = 50, color = "red"))), 
    useGroups = FALSE)
