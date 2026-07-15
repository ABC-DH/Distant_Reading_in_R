###############################################################################
# INSTALL THE REQUIRED PACKAGES
###############################################################################

# Install geonames, the package used to query the GeoNames geographical database.
# This command only needs to be run once and is therefore commented out.
# install.packages("geonames")

# Install tidyverse, a collection of packages used for importing,
# filtering and manipulating data.
# This command only needs to be run once and is therefore commented out.
# install.packages("tidyverse")

# Install plyr, used here to combine data frames with different columns.
# This command only needs to be run once and is therefore commented out.
# install.packages("plyr")


###############################################################################
# SET THE GEONAMES USERNAME
###############################################################################

# Enter the username associated with your GeoNames account.
# Create a free account at: https://www.geonames.org/login
options(geonamesUsername = "geonames_user")


###############################################################################
# LOAD THE REQUIRED LIBRARIES
###############################################################################

library(geonames)  # Searches the GeoNames geographical database.
library(tidyverse) # Imports, filters and manipulates data.
library(plyr)      # Combines data frames that do not have exactly the same columns.


###############################################################################
# TEST A SINGLE GEOGRAPHICAL SEARCH
###############################################################################

# Search for places whose name is exactly "Verona".
Verona <- GNsearch(
  name_equals = "Verona"  # Search for an exact place name.
)

# Open the GeoNames results in the RStudio data viewer.
View(Verona)


###############################################################################
# IMPORT THE LIST OF PLACES
###############################################################################

# Read the places.csv file and store it in my_places_df.
my_places_df <- read.csv(
  "data/csv/places.csv",
  stringsAsFactors = FALSE  # Keep textual columns as character strings.
)

# Display the place names stored in the label column.
my_places_df$label


###############################################################################
# CREATE AN EMPTY RESULTS TABLE
###############################################################################

# Create an empty data frame that will contain the final GeoNames results.
my_geonames <- data.frame()


###############################################################################
# SEARCH ALL PLACES WITH GEONAMES
###############################################################################

# Repeat the geographical search for every row of my_places_df.
for (i in seq_len(nrow(my_places_df))) {
  
  # Display the number of the current iteration.
  print(i)
  
  # Copy the current place into a temporary data frame.
  tmp_df <- my_places_df[i, ]
  
  # Search GeoNames for the place written in the label column.
  result_tmp <- GNsearch(
    name_equals = my_places_df$label[i]
  )
  
  # Check whether GeoNames returned no results.
  if (nrow(result_tmp) == 0) {
    
    # Keep the original place even when no geographical result is found.
    my_geonames <- rbind.fill(
      my_geonames,
      tmp_df
    )
    
    # Continue directly with the next place.
    next
  }
  
  # Keep only populated places such as cities, towns and villages.
  result_tmp <- result_tmp %>%
    filter(fclName == "city, village,...")
  
  # Check whether any populated places remain after filtering.
  if (nrow(result_tmp) == 0) {
    
    # Keep the original place without adding GeoNames information.
    my_geonames <- rbind.fill(
      my_geonames,
      tmp_df
    )
    
    # Continue directly with the next place.
    next
  }
  
  # Convert population values into numbers.
  result_tmp$population <- as.numeric(result_tmp$population)
  
  # Keep the result with the largest population.
  # This generally selects the most important place when names are ambiguous.
  result_tmp <- result_tmp %>%
    filter(population == max(population, na.rm = TRUE)) %>%
    slice(1)  # Keep only one result if several places have the same population.
  
  # Combine the original place information with the GeoNames result.
  tmp_df <- cbind(
    tmp_df,
    result_tmp
  )
  
  # Add the completed row to the final data frame.
  my_geonames <- rbind.fill(
    my_geonames,
    tmp_df
  )
  
  # Pause briefly between requests to avoid sending too many calls to the API.
  Sys.sleep(0.5)
}


###############################################################################
# INSPECT THE RESULTS
###############################################################################

# Open the completed data frame in the RStudio data viewer.
View(my_geonames)


###############################################################################
# SAVE THE RESULTS
###############################################################################

# Save the enriched geographical data as a new CSV file.
write.csv(
  my_geonames,
  "data/csv/places_geo.csv",
  row.names = FALSE  # Do not add an additional row-number column.
)
