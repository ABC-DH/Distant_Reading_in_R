library(diffobj)

# Define your strings
lines1 <- "The Hague"

my_places_df <- read.csv("data/csv/places.csv")
lines2 <- my_places_df$label[11]

# Compare the lines using diffChr
comparison <- diffChr(lines1, lines2)

# Display the comparison
print(comparison)

# Function to get UTF-8 representation of a string
utf8_representation <- function(line) {
  rawToChar(charToRaw(line), multiple = TRUE)
}

# Apply the function to each line
utf8_lines1 <- lapply(lines1, utf8_representation)
utf8_lines2 <- lapply(lines2, utf8_representation)

# Create a data frame for better visualization
comparison <- data.frame(
  Line1 = lines1,
  UTF8_Line1 = sapply(utf8_lines1, paste, collapse = " "),
  Line2 = lines2,
  UTF8_Line2 = sapply(utf8_lines2, paste, collapse = " ")
)

# show comparison
comparison
