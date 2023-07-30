# required packages:
# install.packages("geonames")
# install.packages("tidyverse")
# install.packages("plyr")

# set the options to your username in geonames
options(geonamesUsername="my_username")

# load the library
library(geonames)
library(tidyverse)
library(plyr)

# search for one place and save result in variable
Verona <- GNsearch(name_equals = "Verona")

# visualize the variable
View(Verona)

# read a list of places (from the Network folder)
my_places_df <- read.csv("../Network/data/nodes.csv", stringsAsFactors = F)
my_places_df$label

# create empty dataframe
my_geonames <- data.frame()

# loop on all places
for(i in 1:length(my_places_df$id)){
  
  print(i)
  # prepare result dataframe
  tmp_df <- my_places_df[i,]
  # search the place
  result_tmp <- GNsearch(name_equals = my_places_df$label[i])
  # check if I have a result (I might also get an empty dataframe)
  if(length(result_tmp) == 0){
    # bind (missing) result to final dataframe and jump to next iteration
    my_geonames <- rbind.fill(my_geonames, tmp_df)
    next
  }
  # select just cities
  result_tmp <- result_tmp %>% filter(fclName == "city, village,...")
  # select the biggest city
  result_tmp <- result_tmp %>% filter(population == max(as.numeric(population)))
  # check if I have still some results
  if((length(result_tmp$adminCode1) > 0))
    tmp_df <- cbind(tmp_df, result_tmp)
  # bind result to final dataframe gradually
  my_geonames <- rbind.fill(my_geonames, tmp_df)
  # let the API breath (add pause)
  Sys.sleep(0.5)
  
}

# visualize the result
View(my_geonames)

# save results
write.csv(my_geonames, "../Network/data/nodes_geo.csv")
