# Libraries
# install.packages("ggplot2")
# install.packages("dplyr")
# install.packages("plotly")
# install.packages("hrbrthemes")

library(ggplot2)
library(dplyr)
library(plotly)
library(hrbrthemes)

# Load dataset
data <- read.csv("data/music.csv")

f <- list(
  family = "Arial, monospace",
  size = 14,
  color = "#7f7f7f"
)
x <- list(
  title = "Anni",
  titlefont = f
)
y <- list(
  title = "Numero di ricerche",
  titlefont = f
)

# annotations
a <- list(
  text = "Giovanni Pietro  Vitali - UVSQ-Paris-Saclay (giovanni.vitali@uvsq.fr)",
  
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.8,
  y = 0.985,
  showarrow = FALSE
)

b <- list(
  text = "",
  font = f,
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.5,
  y = 0.95,
  showarrow = FALSE
)


# Area chart with 2 groups
p <- plot_ly(x = data$months, 
             y = data$folk,
             type="scatter", 
             mode="markers", 
             fill = "tozeroy",
             name = "folk") 
  
p <- p %>% add_trace(y = data$trap, 
                     name = "trap") 

p <- p %>% layout(xaxis = x, 
                  yaxis = y, 
                  title= "Ricerche su Google di Folk e Trap (2004-2020)", 
                  annotations = list(a, b))

p
