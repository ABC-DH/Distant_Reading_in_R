# install.packages("ggridges")
# install.packages("ggplot2")

# library
library(ggridges)
library(ggplot2)

cronologia <- read.csv("data/eneko.csv")

# basic example
ggplot(cronologia, aes(x = anno, y = tematica, fill = tematica)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")