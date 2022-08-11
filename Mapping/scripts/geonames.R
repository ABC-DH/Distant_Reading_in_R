# required packages:
# install.packages("geonames")
# install.packages("tidyverse")

# set the options to your username in geonames
options(geonamesUsername="my_username")

# load the library
library(geonames)
library(tidyverse)

# search for one place and save result in variable
Verona <- GNsearch(name_equals = "Verona")

# visualize the variable
View(Verona)

# read a list of places
my_places <- c("My home", "New York", "Verona", "Leipzig", "Papapapa da", "Paris")
my_places

# initialize empty dataframe to store results
my_geonames <- data.frame()

# loop on all places
for(i in 1:length(my_places)){
  
  # search the places one by one
  result_tmp <- GNsearch(name_equals = my_places[i])
  # check if I have a result (I might also get an empty dataframe)
  if(length(result_tmp) == 0)
    next
  # select just cities
  result_tmp <- result_tmp %>% filter(fclName == "city, village,...")
  # select the biggest city
  result_tmp <- result_tmp %>% filter(population == max(as.numeric(population)))
  # check if I have deleted all results
  if((length(result_tmp$adminCode1) == 0))
    next
  result_tmp$text <- my_places[i]
  # bind result to dataframe gradually
  my_geonames <- rbind(my_geonames, result_tmp)
  # let the API breath (add pause)
  Sys.sleep(0.5)
  print(i)
  
}

# visualize the result
View(my_geonames)
