## install.packages("plotly")

library(plotly)

data <- read.csv("data/iris.csv")

## Basic scatter plot
fig <- plot_ly(data = iris, 
               x = ~Sepal.Length, 
               y = ~Petal.Length)
fig

## Customized Scatter Plot

fig <- plot_ly(data = iris, 
               x = ~Sepal.Length, 
               y = ~Petal.Length,
               marker = list(size = 10,
                             color = 'blue',
                             line = list(color = 'green',
                                         width = 2)))

fig <- fig %>% layout(title = 'Customized Scatter Plot',
                      yaxis = list(zeroline = FALSE),
                      xaxis = list(zeroline = FALSE))
fig

