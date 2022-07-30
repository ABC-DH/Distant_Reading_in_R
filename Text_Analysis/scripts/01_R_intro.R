### Welcome!

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

### 1. Basic funtions

# print something to the screen
print("Hello world")

# get info on a function
help(print)

# the "cat" function
cat("Hello world")
help(cat)

# concatenate and print
cat("The cat is", "on the table")
cat("The cat is", "on the table", "sleeping")

# add arguments
cat("The cat is", "on the table", "sleeping", sep = "\n")
cat("The cat is", "on the table", "sleeping", sep = " happy ")

### Your Turn (1) - start

# use the cat function to print this message:
# "The cat is with Simone on the table with Simone sleeping"
# you can complete the code here below:
cat("The cat is", "on the table", "sleeping", sep = "")

### Your Turn (1) - end


### 2. Creating variables

# numbers
my_number <- 1
my_number

# strings of text
my_string <- "to be or not to be"
my_string

# vectors
my_first_vector <- c(1,2,3,4,5)
my_first_vector

# tip: you can get the same by writing
my_first_vector <- 1:5
my_first_vector

# you can also plot a vector in the "plots" panel
plot(my_first_vector)

# vectors (of strings)
my_second_vector <- c("to", "be", "or", "not", "to", "be")
my_second_vector

# lists
my_list <- list(1:5, c("to", "be", "or", "not", "to", "be"))
my_list

# tip: you can get the same by writing
my_list <- list(my_first_vector, my_second_vector)
my_list

# dataframes
my_df <- data.frame(author = c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality = c("English", "Italian", "Spanish", "American"))
View(my_df)

### Your Turn (2) - start

# create a new dataframe with other authors
# you can complete the code here below:
my_new_df <- data.frame(author = c(), nationality = c())
View(my_new_df)

### Your Turn (2) - end


### 3. Accessing variables

# vector subsets
my_first_vector[1]
my_second_vector[1]
my_second_vector[4]
my_second_vector[1:4]
my_second_vector[c(1,4)]

# list subsets
my_list[[1]]
my_list[[1]][4]
my_list[[2]][4]
my_list[[2]][1:3]

# dataframes
my_df$author 
my_df[,1] # the same!!
my_df$nationality
my_df[,2] # the same!!
my_df$author[1:3]
my_df[1:3,1] # the same!!
my_df[1,]
my_df[3,]

# accessing variables in a meaningful way
my_df$author == "Dante"
which(my_df$author == "Dante")
my_df$nationality[which(my_df$author == "Dante")]

### Your Turn (3) - start

# find the author who has "Spanish" nationality
my_df$author[which()]

### Your Turn (3) - end


### 4. Manipulating variables
my_first_vector+1
my_first_vector[2]+1
my_second_vector+1 # this produces an error!!

# manipulating strings
paste(my_string, "?")
strsplit(my_string, " ")
strsplit(my_string, " ")[[1]]
table(strsplit(my_string, " ")[[1]])
sort(table(strsplit(my_string, " ")[[1]]))

### Your Turn (4) - start

# use the "strsplit" function to split my_string into single characters
# tip: you can find the solution via the help function
help(strsplit)


### Your Turn (4) - end

### 5. Reading/writing text files

# printing working directory
getwd()
setwd("/cloud/project/scripts") # notice that this can also be done via the RStudio GUI
getwd()
setwd("/cloud/project")

# read text line by line
my_text <- readLines("corpus/Cbronte_Jane_1847.txt")
head(my_text)

# collapse all text in a single line (separated by the "newline" character)
my_text <- paste(my_text, collapse = "\n")

# write file
cat("The cat is on the table", file = "Cat.txt")

### Your Turn (5) - start

# read another .txt file in the "samples" folder
# and split it into single words 
my_text <- readLines("")
strsplit()

### Your Turn (5) - end

### 6. Making loops

# basic loop
for(i in 1:10){
  print(i)
}

# if conditions
for(i in 1:10){
  if(i == 1){
    print(i)
  }
}

# if/else conditions
for(i in 1:10){
  if(i == 1){
    print(i)
  }else{
    print("more than one")
  }
}

### Your Turn (6) - start

# write a loop that prints numbers until 4, then prints "more than four"
# tip: copy paste here below the "more than one" loop and modify it


### Your Turn (6) - end

### 7. Functions

# basic (stupid) example
my_function <- function(x){
  cat("Ciao", x)
}

my_function("Simone")
my_function("Giovanni")

### Your Turn (7) - start

# create a function that takes as input two names 
# (e.g. "Simone" and "Giovanni")
# ...and prints a sentence including those two names
# (e.g. "Simone is teaching R with Giovanni")


### Your Turn (7) - end

### 8. Packages

# install (this should be done just once)
install.packages("tidyverse")

# load (this should be done every time you start R!)
library(tidyverse)
# more efficient ways to manage dataframes

# for example: find the Italian author in our dataframe of authors
# with base R, you should do like that
my_df[which(my_df$nationality == "Italian"),]

# with tidyverse, you do like
my_df %>% filter(nationality == "Italian")


### 9. Cheat sheets
# good practice when you start coding with R is to use cheat sheets
# you can download some from here (or just Google them!)
# https://iqss.github.io/dss-workshops/R/Rintro/base-r-cheat-sheet.pdf
# https://www.rstudio.com/resources/cheatsheets/
