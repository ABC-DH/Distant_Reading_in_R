# Install required packages for the project
# install.packages("geonames")
# install.packages("tidyverse")
# install.packages("plyr")

# Set the options to your username in geonames
options(geonamesUsername="geonames_user")

# To create a geonames username please visit https://www.geonames.org/login and create a new user account

# Load the required libraries
library(geonames)
library(tidyverse)
library(plyr)

# Search for a specific place (Verona) and save the result in a variable
Verona <- GNsearch(name_equals = "Verona")

# Visualize the variable in a viewer
View(Verona)

# Read a list of places from a CSV file and save it as a dataframe
my_places_df <- read.csv("data/csv/places.csv", stringsAsFactors = F)
# Display the 'label' column from the dataframe
my_places_df$label

# Create an empty dataframe to store geonames results
my_geonames <- data.frame()

# Loop through all places in the dataframe
for(i in 1:length(my_places_df$id)){
  
  print(i)
  # Prepare a temporary dataframe for the current place
  tmp_df <- my_places_df[i,]
  # Search for the place using geonames API
  result_tmp <- GNsearch(name_equals = my_places_df$label[i])
  # Check if the search returned any results
  if(length(result_tmp) == 0){
    # If no results, bind the temporary dataframe to the final dataframe and continue to the next iteration
    my_geonames <- rbind.fill(my_geonames, tmp_df)
    next
  }
  # Filter the results to include only cities, villages, etc.
  result_tmp <- result_tmp %>% filter(fclName == "city, village,...")
  # Select the city with the largest population
  result_tmp <- result_tmp %>% filter(population == max(as.numeric(population)))
  # Check if there are still results after filtering
  if((length(result_tmp$adminCode1) > 0))
    # Combine the temporary dataframe with the search results
    tmp_df <- cbind(tmp_df, result_tmp)
  # Gradually bind the combined result to the final dataframe
  my_geonames <- rbind.fill(my_geonames, tmp_df)
  # Pause for 0.5 seconds to avoid overwhelming the API
  Sys.sleep(0.5)
  
}

# Visualize the final dataframe with all geonames results
View(my_geonames)

# Save the results to a CSV file
write.csv(my_geonames, "data/csv/places_geo.csv")

##################
## Explanation: ##
#################

##  Install required packages: The install.packages commands (commented out) suggest installing the required libraries.

## Set geonames username: The options command sets the geonames username for API access.

## Load libraries: The library commands load the required packages into the R session.

## Search for a specific place: The GNsearch function searches for "Verona" using the geonames API and saves the result in the Verona variable.

## Visualize the variable: The View function opens a viewer to inspect the contents of the Verona variable.

## Read list of places: The read.csv function reads a CSV file containing a list of places and stores it in the my_places_df dataframe.

## Display 'label' column: The my_places_df$label command displays the 'label' column from the dataframe.

## Create empty dataframe: An empty dataframe my_geonames is created to store the geonames results.

## Loop through places: A for loop iterates over each place in my_places_df.

## Print index: The print(i) command prints the current iteration index.

## Prepare temporary dataframe: A temporary dataframe tmp_df is created for the current place.

## Search for place: The GNsearch function searches for the current place using the geonames API.

## Check for results: An if statement checks if the search returned any results.

## No results: If no results, the temporary dataframe is added to the final dataframe, and the loop continues to the next iteration.

## Filter results: The filter function selects only cities, villages, etc., from the search results.

## Select largest city: The filter function selects the city with the largest population.

## Check for remaining results: An if statement checks if there are still results after filtering.

## Combine dataframes: The cbind function combines the temporary dataframe with the filtered search results.

## Bind results: The rbind.fill function adds the combined result to the final dataframe.

## Pause for API: The Sys.sleep(0.5) command pauses the loop for 0.5 seconds to avoid overwhelming the geonames API.

## Visualize final dataframe: The View function opens a viewer to inspect the contents of the final dataframe my_geonames.

## Save results: The write.csv function saves the final dataframe to a CSV file.