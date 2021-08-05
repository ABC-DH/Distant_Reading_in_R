## PACKAGE INSTALLATION & DATA

# install.packages("plotly")
library(plotly)

x =c(1,2,3,4,5 )
y =c(6,7,8,9,10)
y3=c(-6,-7,-8,-9,-10)

# Line Plot
plot_ly (x =c(1,2,3),
         y =c(4,5,6),
         type = "scatter",
         mode = "lines")

# Line Plot with table (same dataset, different form)
table_example_2 <- read.csv("data/plotly_example.csv")
plot <- plot_ly (x = table_example_2$column1, 
         y = table_example_2$column1,
         type = "scatter",
         mode = "lines")
plot

# Scatter Plot
plot_ly (x =c(1,2,3),
         y =c(4,5,6),
         type = "scatter", 
         mode = "markers")

# Bar Plot
plot_ly (x =c(1,2,3),
         y =c(4,5,6),
         type = "bar")

# Bubble Chart
plot_ly (x =c(1, 2, 3 ),
         y =c(4,5, 6 ),
         type = "scatter" ,
         mode = "markers" ,
         size =c( 2,6,9 ),
         marker = list(color =c( "red",
                                 "black",
                                 "yellow" )))

## Area Plot

plot_ly (x =c(1,2,3),
         y =c(4,5,6),
         type = "scatter",
         mode = "lines",
         fill = "tozeroy")
