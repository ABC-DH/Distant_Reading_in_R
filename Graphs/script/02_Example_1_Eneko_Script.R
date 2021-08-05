# install.packages("tidyverse")
library(tidyverse)
library(ggplot2)

cronologia <- read.csv("data/eneko.csv")

ggplot(filter(cronologia, tematica %in% c("Dedicatoria", 
                                          "Ecología", 
                                          "Economía",
                                          "Historia&Sociedad",
                                          "Iglesia",
                                          "Independencia",
                                          "Migración",
                                          "Sexismo",
                                          "Política",
                                          "Periódico",
                                          "Guerra")),
       aes(x=tiempo,
           y=areas,
           color=tematica,
           size=anno,
           fillopacity=0.9))+
  geom_point()
scale_color_gradient2(midpoint=mid, low="blue", mid="white",
                          high="red", space ="Lab" )

