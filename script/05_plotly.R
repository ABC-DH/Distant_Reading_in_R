fig <- plot_ly(
  
  # Use the imported dataset.
  data = data,
  
  # Put sepal_length on the x-axis.
  x = ~sepal_length,
  
  # Put petal_length on the y-axis.
  y = ~petal_length,
  
  # Use a different colour for each iris species.
  color = ~species,
  
  # Display the observations as points.
  type = "scatter",
  
  # Show only the markers.
  mode = "markers",
  
  # Customize the appearance of the points.
  marker = list(
    size = 10,
    line = list(
      color = "black",
      width = 1
    )
  )
)

fig <- fig %>%
  layout(
    title = "Customized Scatter Plot",
    xaxis = list(
      title = "Sepal Length",
      zeroline = FALSE
    ),
    yaxis = list(
      title = "Petal Length",
      zeroline = FALSE
    )
  )

fig