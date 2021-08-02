### Welcome!

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

### 1. Creating variables

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

### 2. Accessing variables

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

### 3. Manipulating variables
my_first_vector+1
my_first_vector[2]+1
my_second_vector+1 # this produces an error!!

# the functions syntax
paste(my_string, "?")
nchar(my_string)
strsplit(my_string, " ")
strsplit(my_string, " ")[[1]]
unlist(strsplit(my_string, " ")) # the same! (in this specific case)

my_second_vector
my_third_vector <- unlist(strsplit(my_string, " "))
my_third_vector == my_second_vector

table(my_third_vector)
sort(table(my_third_vector))
sort(table(my_third_vector), decreasing = T)

### Appendix
# note: the "<-" sign can be substitited by "="
my_variable <- "Shakespeare"
my_variable = "Shakespeare"
# still, it is advised to distinguish between the two, as the "<-" sign has a "stronger" function. See for example in the creation of a dataframe
my_df <- data.frame(author = c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality = c("English", "Italian", "Spanish", "American"))
author # it does not exist!!

my_df_2 <- data.frame(author <- c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality <- c("English", "Italian", "Spanish", "American"))
author # now it exists!!

# for more details (and discussion): https://stackoverflow.com/questions/1741820/what-are-the-differences-between-and-assignment-operators-in-r 

### Your turn!!
# Suggested activities: 
# 1. what happens if I sum/multiply a numeric vector by one number? Why?
# 2. what happens if I sum/multiply two numeric vectors? Why?
# 3. increase the "my_df" dataframe with more authors and info (e.g. date of birth)
# 4. modify one entry in the "my_df" dataframe (e.g. Dante is Florentin, not Italian)
# 5. how do I use strsplit() to split a sting into its single characters? Tip (that is valid in any case!): look into the "help" panel on the right

# Or... freely discuss about your doubts, try ideas, experiment, etc.