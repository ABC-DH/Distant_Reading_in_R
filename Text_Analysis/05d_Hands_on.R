### Hands-on (convert csv file of paragraphs/comments to txt files)

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# IMPORTANT NOTE: this script works on the mock dataset "comments_1.csv"
# in the "hands_on_files" folder. You should delete this file
# and substitute it with your own.

library(tidyverse)

# here we read our .csv file
my_df <- read.csv("hands_on_files/comments_1.csv")

# convert paragraphs to factor to keep order
my_df$paragraph <- factor(my_df$paragraph, levels = unique(my_df$paragraph))

# we then group the comments based on paragraph
my_df_red <- my_df %>%
  group_by(paragraph) %>%
  summarise(comments = paste(comment, collapse = "\n"))

# remove paragraphs with no comments
my_df_red <- my_df_red %>%
  filter(!grepl("NO_COMMENTS", comments))

# write paragraphs to file
cat(as.character(my_df_red$paragraph), sep = "\n", file = "corpus/paragraphs_full_0.txt")

# we then loop on the comments
for(i in 1:length(my_df_red$paragraph)){
  
  cat(my_df_red$comments[i], file = paste("corpus/comments_par_", i, ".txt", sep = ""))
  
}

# this script will create a series of .txt files in the "corpus" folder,
# on which you can apply all the others scripts presented in the workshop
