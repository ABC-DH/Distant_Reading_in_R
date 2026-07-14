###############################################################################
# IMPORT THE DATASET
###############################################################################

# Read the eneko.csv file located in the data folder.
# Store the imported data in an object called cronologia.
cronologia <- read.csv("data/eneko.csv")

# Convert the tiempo column from text into R Date objects.
# The dates follow the year-month-day format.
cronologia$tiempo <- as.Date(
  cronologia$tiempo,
  format = "%Y-%m-%d"
)


###############################################################################
# FILTER THE DATA AND CREATE THE GRAPH
###############################################################################

# Create a graph using a filtered version of the cronologia dataset.
ggplot(
  
  # Keep only the observations belonging to the selected themes.
  data = filter(
    cronologia,
    tematica %in% c(
      "Dedicatoria",
      "Ecología",
      "Economía",
      "Historia&Sociedad",
      "Iglesia",
      "Independencia",
      "Migración",
      "Sexismo",
      "Política",
      "Periódico",
      "Guerra"
    )
  ),
  
  # Define the variables and graphical properties represented in the graph.
  aes(
    x = tiempo,          # Put the date on the x-axis.
    y = areas,           # Put the geographical area on the y-axis.
    colour = tematica,   # Use colour to distinguish the themes.
    size = anno          # Use point size to represent the year.
  )
) +
  
  # Represent each observation with one point.
  geom_point(
    alpha = 0.9
  ) +
  
  # Add titles and descriptions to the graph.
  labs(
    x = "Time",
    y = "Areas",
    colour = "Theme",
    size = "Year",
    title = "Themes represented over time",
    subtitle = "Distribution of themes according to time and area",
    caption = "Data from the eneko.csv dataset"
  ) +
  
  # Treat the x-axis as a chronological scale.
  scale_x_date(
    
    # Display one label for each year.
    date_breaks = "1 year",
    
    # Display only the year, for example 2007 or 2008.
    date_labels = "%Y"
  ) +
  
  # Apply a simple graphical theme.
  theme_minimal() +
  
  # Modify the labels displayed on the x-axis.
  theme(
    axis.text.x = element_text(
      angle = 45,        # Rotate the labels by 45 degrees.
      hjust = 1          # Align each label with its tick mark.
    )
  )