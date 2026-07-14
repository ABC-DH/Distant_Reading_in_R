###############################################################################
# CREATE A RIDGELINE PLOT WITH LABELS
###############################################################################

# Create a graph using the cronologia dataset.
ggplot(
  data = cronologia,
  
  # Define the variables and graphical properties used in the graph.
  aes(
    x = anno,          # Put the year variable on the x-axis.
    y = tematica,      # Put the different themes on the y-axis.
    fill = tematica    # Use a different fill colour for each theme.
  )
) +
  
  # Create one density curve for each theme.
  geom_density_ridges() +
  
  # Add titles and descriptions to the graph.
  labs(
    x = "Year",                              # Add a label to the x-axis.
    y = "Theme",                             # Add a label to the y-axis.
    title = "Distribution of themes over time",
    subtitle = "Density of observations by year and theme",
    caption = "Data from the eneko.csv dataset"
  ) +
  
  # Apply a theme designed specifically for ridgeline plots.
  theme_ridges() +
  
  # Remove the legend because the themes are already shown on the y-axis.
  theme(
    legend.position = "none"
  )