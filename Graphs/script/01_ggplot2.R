## Tutorial inspired by Alessio Passalacqua

## install.packages("ggplot2")
## install.packages("plotly")
## install.packages("GGally")

library(ggplot2)

###############################################################################
# The wine dataset contains the results of a chemical analysis of wines grown #
# in a specific area of Italy.                                                #    
# Three types of wine are represented in the 178 samples,                     #
# with the results of 13 chemical analyses recorded for each sample.          #
# The Type variable has been transformed into a categoric variable.           # 
# The data contains no missing values and consits of only numeric data,       #
# with a three class target variable (Type) for classification.               #
###############################################################################

table <- read.csv("data/wine.csv")

# Background
ggplot(data = table, aes(x= Magnesium, y=Flavanoids ))

# Scatter plot
ggplot(data = table, aes(x= Magnesium, y=Flavanoids )) + geom_point() 

# Customise the graph
ggplot(data = table, aes(x= Magnesium, 
                         y=Flavanoids,
                        colour=Hue,
                        size=Proline ))  +
  geom_point() + 
  labs(x="Magnesium", 
       y="Flavanoids", 
       title = "Wine data set",
       subtitle = "Scatter plot",
       caption = "Data from library rattle.data") 

# Add a theme:
# theme_gray() | theme_bw() | theme_classic() | theme_dark() | theme_gray()
# theme_grey() | theme_light() | theme_linedraw() | theme_minimal()

ggplot(data = table, aes(x= Magnesium, 
                        y=Flavanoids,
                        colour=Hue,
                        size=Proline ))  +
  geom_point() + 
  labs(x="Magnesium", y="Flavanoids", 
       title = "Wine data set",
       subtitle = "Scatter plot",
       caption = "Data from library rattle.data") +
  theme_grey()

# Change the data WWII:

table_ww2 <- read.csv("data/1943.csv")

ggplot(data = table_ww2, aes(x= date,
                                 y=old_people,
                                 colour=authors_event,
                                 size=victims))  +
  geom_point() + 
  labs(x="Dates of the massacres", y="Ederly people killed", 
       title = "Massacres during 1943 by Nazis or Fascists",
       subtitle = "Relationships bewteen the total victims and the old people",
       caption = "Data from library rattle.data") +
  theme_minimal()

# LET'S COME BACK TO THE WINE
# Histogram_1
ggplot(data = table, aes(x=Alcohol)) + 
  geom_histogram(fill="#69b3a2", color="#e9ecef", alpha=0.7, binwidth = 0.5)

# Histogram_2
ggplot(data = table, aes(x=Alcohol)) + 
  geom_density(fill="#69b3a2", color="red", alpha=0.5, bw=0.1) 

# Boxplot
ggplot(data = table, aes(y=Alcohol)) + geom_boxplot()

# Cartesian axes
ggplot(data = table, aes(Alcohol, Color)) + 
  geom_line() 

# Two-dimensional density
ggplot(data = table, aes(x=Alcohol,y=Ash)) + 
  geom_density2d() + 
  geom_point()

# Dispersion graph
ggplot(data = table, aes(x=Alcohol,y=Proline)) + 
  geom_jitter() 

# With tendency line
ggplot(data = table, aes(x=Alcohol,y=Proline)) + 
  geom_jitter() +  
  geom_smooth(method = lm)

# Interpolar curve
ggplot(data = table, aes(x=Alcohol,y=Proline)) + 
  geom_jitter() +  
  geom_smooth(method = loess)

# 3 or more numerical variables

ggplot(data = table, aes(x= Magnesium, y=Flavanoids,colour=Hue,size=Proline ))  + 
  geom_point()

library(plotly)

fig <-
  ggplot(data = table, aes(x= Magnesium, y=Flavanoids,colour=Type, size=Proline )) +
  geom_point(alpha=0.5) + 
  theme_bw()

ggplotly(fig)


# Change the data:

fig_example <-
  ggplot(data = table_ww2, aes(x= execution, y=authors_event, colour=authors_event, size=victims)) +
  geom_point(alpha=0.5) + 
  theme_bw()

ggplotly(fig_example)

# LET'S COME BACK TO THE WINE
# Correlogram
library(GGally)

ggpairs(data = table[2:5])

# Categorical variable 
# Variable whose set of possible values consists of a 
# finite number of categories (2 or more).

ggplot(data = table, aes(Type)) + geom_bar()

# Numerical Distribution Vs Categorical
ggplot(data = table, aes(x=Type,y=Proline))  + 
  geom_boxplot() + 
  geom_jitter()

# Adding colors
ggplot(data = table, aes(x=Type,y=Proline,colour=Type))  + 
  geom_boxplot() + 
  geom_jitter()

# Density layers
ggplot(data = table, aes(x=Proline,fill=Type))  + 
  geom_density(alpha=.3)

# The following function can be used to save files 
# without using Rstudio's saving options:
# ggsave("file_name.png")

# Size specifications can also be added:
# ggsave("wine.png", width=10, height=14, units="cm")
