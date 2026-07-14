## Tutorial inspired by Alessio Passalacqua


###############################################################################
# INSTALL THE PACKAGES
###############################################################################

# Install ggplot2, the package used to create graphs.
# This command only needs to be run once and is therefore commented out.
## install.packages("ggplot2")

# Install plotly, the package used to create interactive graphs.
# This command only needs to be run once and is therefore commented out.
## install.packages("plotly")

# Install GGally, the package used to compare several variables in one graph.
# This command only needs to be run once and is therefore commented out.
## install.packages("GGally")


###############################################################################
# LOAD THE REQUIRED LIBRARY
###############################################################################

# Load ggplot2 into the current R session.
# The package must be loaded each time R is restarted.
library(ggplot2)


###############################################################################
# THE WINE DATASET
###############################################################################

# The wine dataset contains the results of a chemical analysis of wines grown
# in a specific area of Italy.
#
# Three types of wine are represented in the 178 samples.
#
# The dataset contains the results of 13 chemical analyses for each sample.
#
# The Type variable identifies the category of wine.
#
# The dataset contains no missing values.
#
# Most of the variables contain numerical values.


###############################################################################
# IMPORT THE WINE DATASET
###############################################################################

# Read the wine.csv file located in the data folder.
# Store the imported data in an object called table.
table <- read.csv("data/wine.csv")


###############################################################################
# BASIC SCATTER PLOT
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Define which variables are represented in the graph.
  aes(
    x = Magnesium,      # Put Magnesium on the x-axis.
    y = Flavanoids      # Put Flavanoids on the y-axis.
  )
) +
  
  # Represent each wine sample with one point.
  geom_point()


###############################################################################
# SCATTER PLOT WITH ADDITIONAL VARIABLES
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Define the variables and graphical properties used in the graph.
  aes(
    x = Magnesium,      # Put Magnesium on the x-axis.
    y = Flavanoids,     # Put Flavanoids on the y-axis.
    colour = Hue,       # Change point colour according to the Hue value.
    size = Proline      # Change point size according to the Proline value.
  )
) +
  
  # Represent each wine sample with one point.
  geom_point() +
  
  # Add titles and descriptions to the graph.
  labs(
    x = "Magnesium",                  # Add a label to the x-axis.
    y = "Flavanoids",                 # Add a label to the y-axis.
    title = "Wine data set",          # Add the main title.
    subtitle = "Scatter plot",        # Add a subtitle.
    caption = "Data from library rattle.data" # Add the data source.
  )


###############################################################################
# ADD A THEME
###############################################################################

# ggplot2 includes several predefined graphical themes:
#
# theme_gray()      # Default ggplot2 theme with a grey background.
# theme_grey()      # Same as theme_gray().
# theme_bw()        # White background with black grid lines.
# theme_classic()   # White background without grid lines.
# theme_dark()      # Dark grey background.
# theme_light()     # Light background with subtle grid lines.
# theme_linedraw()  # White background with thin black lines.
# theme_minimal()   # Minimal theme with few graphical elements.
# theme_void()      # Empty theme without axes, labels or grid lines.
# theme_test()      # Simple theme mainly intended for testing.

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Define the variables and graphical properties used in the graph.
  aes(
    x = Magnesium,      # Put Magnesium on the x-axis.
    y = Flavanoids,     # Put Flavanoids on the y-axis.
    colour = Hue,       # Change point colour according to Hue.
    size = Proline      # Change point size according to Proline.
  )
) +
  
  # Represent each observation with one point.
  geom_point() +
  
  # Add titles and descriptions to the graph.
  labs(
    x = "Magnesium",                  # Add a label to the x-axis.
    y = "Flavanoids",                 # Add a label to the y-axis.
    title = "Wine data set",          # Add the main title.
    subtitle = "Scatter plot",        # Add a subtitle.
    caption = "Data from library rattle.data" # Add the data source.
  ) +
  
  # Apply the default grey ggplot2 theme.
  theme_grey()


###############################################################################
# THE WWII DATASET
###############################################################################

# Read the 1943.csv file located in the data folder.
# Store the imported data in an object called table_ww2.
table_ww2 <- read.csv("data/1943.csv")

# Convert the date column into text and then into an R Date object.
table_ww2$date <- as.Date(
  
  # Convert the values to character strings before processing them as dates.
  as.character(table_ww2$date),
  
  # Indicate that the dates follow the year-month-day format.
  format = "%Y-%m-%d"
)


###############################################################################
# WWII SCATTER PLOT
###############################################################################

# Create a graph using the WWII dataset.
ggplot(
  data = table_ww2,
  
  # Define the variables and graphical properties used in the graph.
  aes(
    x = date,                  # Put the date of each massacre on the x-axis.
    y = old_people,            # Put the number of elderly victims on the y-axis.
    colour = authors_event,    # Use colours to distinguish the perpetrators.
    size = victims             # Use point size to represent total victims.
  )
) +
  
  # Represent each massacre with one point.
  geom_point() +
  
  # Add titles and descriptions to the graph.
  labs(
    x = "Dates of the massacres", # Add a label to the x-axis.
    y = "Elderly people killed",  # Add a label to the y-axis.
    
    # Add the main title.
    title = "Massacres during 1943 by Nazis or Fascists",
    
    # Explain the relationship represented in the graph.
    subtitle = "Relationship between total victims and elderly people killed",
    
    # Indicate the source of the data.
    caption = "Data from the rattle.data package"
  ) +
  
  # Control how dates are displayed on the x-axis.
  scale_x_date(
    
    # Display one label for each month.
    date_breaks = "1 month",
    
    # Display the abbreviated month followed by the year.
    # For example: Jul 1943.
    date_labels = "%b %Y"
  ) +
  
  # Apply a simple theme with a light background.
  theme_minimal() +
  
  # Modify specific visual elements of the theme.
  theme(
    
    # Modify the text displayed on the x-axis.
    axis.text.x = element_text(
      
      # Rotate the date labels by 90 degrees.
      angle = 90,
      
      # Adjust the vertical position of the labels.
      vjust = 0.5,
      
      # Align the labels with the corresponding tick marks.
      hjust = 1
    )
  )


###############################################################################
# ALTERNATIVE DATE SCALE
###############################################################################

# The following version can replace the previous scale_x_date() function.
# It displays one date label every 15 days instead of every month.

# scale_x_date(
#   date_breaks = "15 days",  # Display one label every 15 days.
#   date_labels = "%d %b"     # Display the day and abbreviated month.
# )


###############################################################################
# HISTOGRAM
###############################################################################

# Return to the wine dataset.

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol values on the x-axis.
  aes(x = Alcohol)
) +
  
  # Divide Alcohol values into intervals and count observations in each interval.
  geom_histogram(
    fill = "#69b3a2",    # Set the colour inside the bars.
    color = "#e9ecef",   # Set the colour of the bar borders.
    alpha = 0.7,         # Make the bars slightly transparent.
    binwidth = 0.5       # Set the width of each interval to 0.5.
  )


###############################################################################
# DENSITY PLOT
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol values on the x-axis.
  aes(x = Alcohol)
) +
  
  # Estimate and represent the distribution of Alcohol values.
  geom_density(
    fill = "#69b3a2",    # Set the colour inside the density curve.
    color = "red",       # Set the colour of the curve.
    alpha = 0.5,         # Make the filled area transparent.
    bw = 0.1             # Set the smoothing bandwidth.
  )


###############################################################################
# BOXPLOT
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol values on the y-axis.
  aes(y = Alcohol)
) +
  
  # Represent the distribution of Alcohol values with a boxplot.
  geom_boxplot()


###############################################################################
# LINE GRAPH
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol on the x-axis and Color on the y-axis.
  aes(
    x = Alcohol,
    y = Color
  )
) +
  
  # Connect consecutive observations with lines.
  geom_line()


###############################################################################
# TWO-DIMENSIONAL DENSITY PLOT
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol on the x-axis and Ash on the y-axis.
  aes(
    x = Alcohol,
    y = Ash
  )
) +
  
  # Draw contour lines showing areas with different concentrations of points.
  geom_density2d() +
  
  # Add the original observations as points.
  geom_point()


###############################################################################
# JITTER PLOT
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol on the x-axis and Proline on the y-axis.
  aes(
    x = Alcohol,
    y = Proline
  )
) +
  
  # Add a small random displacement to the points.
  # This helps distinguish observations that have similar values.
  geom_jitter()


###############################################################################
# JITTER PLOT WITH A LINEAR TREND
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol on the x-axis and Proline on the y-axis.
  aes(
    x = Alcohol,
    y = Proline
  )
) +
  
  # Represent the observations with slightly displaced points.
  geom_jitter() +
  
  # Add a linear regression line.
  geom_smooth(
    method = lm
  )


###############################################################################
# JITTER PLOT WITH A LOESS CURVE
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Alcohol on the x-axis and Proline on the y-axis.
  aes(
    x = Alcohol,
    y = Proline
  )
) +
  
  # Represent the observations with slightly displaced points.
  geom_jitter() +
  
  # Add a flexible curve describing the local trend in the data.
  geom_smooth(
    method = loess
  )


###############################################################################
# SCATTER PLOT WITH FOUR VARIABLES
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Represent four numerical variables in the same graph.
  aes(
    x = Magnesium,      # Put Magnesium on the x-axis.
    y = Flavanoids,     # Put Flavanoids on the y-axis.
    colour = Hue,       # Use colour to represent Hue.
    size = Proline      # Use point size to represent Proline.
  )
) +
  
  # Represent each observation with one point.
  geom_point()


###############################################################################
# INTERACTIVE GRAPHS WITH PLOTLY
###############################################################################

# Load plotly into the current R session.
library(plotly)

# Create a ggplot graph and store it in an object called fig.
fig <-
  ggplot(
    data = table,
    
    # Define the variables used in the graph.
    aes(
      x = Magnesium,    # Put Magnesium on the x-axis.
      y = Flavanoids,   # Put Flavanoids on the y-axis.
      colour = Type,    # Use colour to distinguish wine types.
      size = Proline    # Use point size to represent Proline.
    )
  ) +
  
  # Represent each observation with a partially transparent point.
  geom_point(
    alpha = 0.5
  ) +
  
  # Apply a black-and-white theme.
  theme_bw()

# Convert the ggplot graph stored in fig into an interactive plot.
ggplotly(fig)


###############################################################################
# INTERACTIVE WWII GRAPH
###############################################################################

# Create a ggplot graph and store it in an object called fig_example.
fig_example <-
  ggplot(
    data = table_ww2,
    
    # Define the variables used in the graph.
    aes(
      x = execution,              # Put the execution variable on the x-axis.
      y = authors_event,          # Put the perpetrators on the y-axis.
      colour = authors_event,     # Use colour to distinguish perpetrators.
      size = victims              # Use point size to represent total victims.
    )
  ) +
  
  # Represent each observation with a partially transparent point.
  geom_point(
    alpha = 0.5
  ) +
  
  # Apply a black-and-white theme.
  theme_bw()

# Convert the WWII graph into an interactive plot.
ggplotly(fig_example)


###############################################################################
# CORRELOGRAM WITH GGALLY
###############################################################################

# Load GGally into the current R session.
library(GGally)

# Select columns 2 to 5 from the wine dataset.
# Create a matrix of graphs comparing all the selected variables.
ggpairs(
  data = table[2:5]
)


###############################################################################
# BAR CHART
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put the categorical Type variable on the x-axis.
  aes(x = Type)
) +
  
  # Count how many observations belong to each wine type.
  geom_bar()


###############################################################################
# BOXPLOT BY WINE TYPE
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Compare Proline values for the different wine types.
  aes(
    x = Type,          # Put the wine type on the x-axis.
    y = Proline        # Put Proline values on the y-axis.
  )
) +
  
  # Represent the distribution of Proline for each wine type.
  geom_boxplot() +
  
  # Add the individual observations with a small random displacement.
  geom_jitter()


###############################################################################
# COLOURED BOXPLOT BY WINE TYPE
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Define the variables and colours used in the graph.
  aes(
    x = Type,          # Put the wine type on the x-axis.
    y = Proline,       # Put Proline values on the y-axis.
    colour = Type      # Use a different colour for each wine type.
  )
) +
  
  # Represent the distribution of Proline for each wine type.
  geom_boxplot() +
  
  # Add the individual observations.
  geom_jitter()


###############################################################################
# DENSITY PLOT BY WINE TYPE
###############################################################################

# Create a graph using the wine dataset.
ggplot(
  data = table,
  
  # Put Proline on the x-axis and distinguish wine types with fill colours.
  aes(
    x = Proline,
    fill = Type
  )
) +
  
  # Represent the distribution of Proline for each wine type.
  geom_density(
    
    # Make the density areas transparent so that they remain visible
    # when they overlap.
    alpha = 0.3
  )


###############################################################################
# SAVE A GRAPH
###############################################################################

# Save the most recently displayed graph as a PNG file.
# The command is commented out so that it is not run automatically.
# ggsave("file_name.png")


###############################################################################
# SAVE A GRAPH WITH A SPECIFIC SIZE
###############################################################################

# Save the most recently displayed graph as wine.png.
# Set the image width to 10 centimetres and its height to 14 centimetres.
# The command is commented out so that it is not run automatically.
# ggsave(
#   "wine.png",
#   width = 10,
#   height = 14,
#   units = "cm"
# )