# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("stylo")
# install.packages("quanteda")
# install.packages("quanteda.textstats")
# install.packages("quanteda.textplots")

### 1. Zeta Analysis

library(stylo)

# First, select all files in the "corpus" folder
file_list <- list.files("corpus", full.names = T)
file_list
### then prepare an empty list for the texts 
my_texts <- list()
### and run a loop on all the files
for(i in 1:length(file_list)){
  # read text (for .txt files)
  if(grepl(pattern = ".txt", x = file_list[i])){
    loaded_file <- readLines(file_list[i], warn = F)
    loaded_file <- paste(loaded_file, collapse = "\n")
  }
  # in case it is an xml file, let's delete the markup
  if(grepl(pattern = ".xml", x = file_list[i])){
    loaded_file <- scan(file_list[i], what = "char", encoding = "utf-8", sep = "\n", quiet = TRUE)
    loaded_file <- delete.markup(loaded_file, markup.type = "xml")
  }
  # If we want to run stylo on the texts now saved in the list, we need to "tokenize" them (i.e. split them into single words)
  # There is a function in the "stylo" package that does it:
  my_texts[[i]] <- stylo::txt.to.words.ext(loaded_file, corpus.lang = "English")
  # then add correct names to the different texts in the list
  # (we can re-use the names saved in the list_files variable, by deleting the "corpus/" at the beginning)
  names(my_texts)[i] <- gsub(pattern = "corpus/|.txt|.xml", replacement = "", x = file_list[i])
  # print progress
  print(i)
}

### find the texts written by one author (e.g. Woolf)
Chosen_texts <- which(grepl("Woolf", names(my_texts)))
# This is a typical example of an "embedded" R function
# the "grepl" function checks if the string "Woolf" is present in the names of the "plays_text" list
# the "which" function check where the "grep" function found a correspondence
Chosen_texts

### We use the "oppose" function, still in the "stylo" package,
### that looks for the most distinctive words.
### The method it uses is known as "Zeta Analysis"
### The corpus should be divided in two parts:
### A "primary set" where we have the texts of interest;
### A "secondary set" to be compared with

### Our primary set are the texts by Woolf
primary_set <- my_texts[Chosen_texts]
### Our secondary set are the texts by all the others
secondary_set <- my_texts[-Chosen_texts]

### now everything is ready to run an "oppose" analysis
oppose(primary.corpus = primary_set, secondary.corpus = secondary_set)
# in the graphical interface, you can leave things as they are
# please choose the "Words" visualization

### 2. Log-likelihood
### with the "quanteda" package

library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)

### First, data has to be prepared (by repeating the procedure above)

# In this case, we do not need to tokenize the text
# so the "my_texts" variable can be a vector, not a list 
my_texts <- character()

# and run again a loop on all the files
for(i in 1:length(file_list)){
  # read text (for .txt files)
  if(grepl(pattern = ".txt", x = file_list[i])){
    loaded_file <- readLines(file_list[i], warn = F)
    loaded_file <- paste(loaded_file, collapse = "\n")
  }
  # in case it is an xml file, let's delete the markup
  if(grepl(pattern = ".xml", x = file_list[i])){
    loaded_file <- scan(file_list[i], what = "char", encoding = "utf-8", sep = "\n", quiet = TRUE)
    loaded_file <- delete.markup(loaded_file, markup.type = "xml")
  }
  my_texts[i] <- loaded_file
  names(my_texts)[i] <- gsub(pattern = "corpus/|.txt|.xml", replacement = "", x = file_list[i])
  # print progress
  print(i)
}

# We repeat the selection already done for the "oppose" function in Stylo
Chosen_texts <- which(grepl("Woolf", names(my_texts)))

# As quanteda does not look at distribution, but just at frequencies
# we have to collapse all texts by Woolf and Others into single strings
# by separating target and reference corpus
quanteda_texts <- paste(my_texts[Chosen_texts], collapse = "\n")
quanteda_texts[2] <- paste(my_texts[-Chosen_texts], collapse = "\n")
names(quanteda_texts) <- c("Woolf", "Others")

### Here quanteda gets in action
# first, it tokenizes the text 
quanteda_texts <- tokens(quanteda_texts, remove_punct = T)

# second, it transforms the corpus into a document-feature matrix 
document_feature_matrix <- dfm(quanteda_texts)
# note that the "grouping" is based on the names of the corpus, i.e. "Woolf" and "Others" 

# third, it calculates the keyness for each word
# choosing as a target the documents with the "Woolf" name
# and using as a measure the "log-likelihood ratio" method ("lr")
keyness_results <- textstat_keyness(document_feature_matrix, target = "Woolf", measure = "lr")

# Finally, we plot the results
textplot_keyness(keyness_results, n = 20)

# ...and save them as png, for a comparison with the "Zeta analysis"
png(filename = "Woolf_LogLikelihood.png", height = 2000, width = 3000, res = 300)
textplot_keyness(keyness_results, n = 20)
dev.off()
