### Hands-on with R (extra)

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("udpipe")
# install.packages("tidyverse")

### 1. Process multiple files with udpipe

library(udpipe)
library(tidyverse)

# get names of all files in the "corpus" folder
file_list <-  list.files("corpus", full.names = T)

# prepare empty list to store result
my_texts <- list()

# and run a loop on all the files
for(i in 1:length(file_list)){
  
  # read the files (one by one)
  novel <- readLines(file_list[i])
  text <-  paste(novel, collapse = "\n\n")
  # text <- substr(text, 1, 1000) # uncomment this line if you want to simply test the script on text samples
  
  # annotate the text with udpipe (and incrementally save to list)
  my_texts[[i]] <- udpipe(x = text, object = "english")
  
  # then add correct names to the different texts in the list
  # (we can re-use the names saved in the list_files variable, by deleting the "corpus/" at the beginning)
  names(my_texts)[i] <- gsub(pattern = "corpus/|.txt|.xml", replacement = "", x = file_list[i])
  
  # print progress
  print(i)
  
}

# you can explore the results in the different parts of the list
my_df <- my_texts[[1]]
View(my_df)

# you can even (if you like) merge them all in a single dataframe
my_full_df <- bind_rows(my_texts, .id = "book_title")

### 2. Save and load variables to RData files

# you can save any variable in your environment with this command 
save(my_texts, my_full_df, file = "My_udpipe_texts.RData")

# if you want to save ALL variables in your environment
save.image("My_udpipe_texts_and_all_the_rest.RData")

# then you can load the RData file with
load("My_udpipe_texts.RData")
