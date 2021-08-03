# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("udpipe")
# install.packages("tidyverse")

### 1. 
### Simple text exploration

# read the text
novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, collapse = "\n")

# simplest tokenization function (using a basic regular expression)
text <- strsplit(text, "\\W")
head(text)

# slight issue: the strsplit funciton creates a (useless, for now) list
text <- unlist(text)
head(text)

# another issue: the function generated many "empty tokens"
which(text == "")

# let's delete them!
text <- text[which(text != "")]

### Dispersion plots (example taken from Matthew Jockers, Text analysis with R for students of literature, 2014)

# first, let's find the appearances of a certain word in the text
sherlock.v <- which(text == "Sherlock")

# second, let's create a vector that represents the entire text
w.count.v <- rep(NA, length(text))

# ...and add the appearences in the vector
w.count.v[sherlock.v] <- 1

plot(w.count.v, main="Dispersion Plot of 'Sherlock' in A study in Scarlet",
     xlab="Novel Time", ylab="Sherlock", type= "h" , ylim=c(0,1), yaxt= "n")

### Keyword in context
for(i in 1:length(sherlock.v)){
  
  cat(i, "\t", text[(sherlock.v[i]-5):(sherlock.v[i]+5)], "\n")
  
}

### 2. 
### Let's do things more professionally, using an NLP library
### (examples adapted from: https://bnosac.github.io/udpipe/en/)

# load the library
library(udpipe)
library(tidyverse)

### Simplest example

# choose a text
my_text <- "To be or not to be. That is the question, my dear Watson."

# annotate it with udpipe!
x <- udpipe(x = my_text, object = "english")
View(x)

# of course, you can also work on different languages
my_text <- "Nel mezzo del cammin della mia vita, mi ritrovai con il mio caro Watson."

# annotate it with udpipe!
x <- udpipe(x = my_text, object = "italian")
View(x)

# let's work on one entire novel
novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, collapse = "\n")
result <- udpipe(x = text, object = "english")

### Repeat the analyses of above

# first, let's find the appearances of a certain word in the text
sherlock.v <- which(result$lemma== "Sherlock")

# second, let's create a vector that represents the entire text
w.count.v <- rep(NA, length(text))

# ...and add the appearences in the vector
w.count.v[sherlock.v] <- 1

plot(w.count.v, main="Dispersion Plot of 'Sherlock' in A study in Scarlet",
     xlab="Novel Time", ylab="Sherlock", type= "h" , ylim=c(0,1), yaxt= "n")

### Keyword in context
for(i in 1:length(sherlock.v)){
  
  cat(i, "\t", result$token[(sherlock.v[i]-5):(sherlock.v[i]+5)], "\n")
  
}


### Better keyword in context (per sentence)
for(i in 1:length(sherlock.v)){
  
  my_sent_id <- result$sentence_id[sherlock.v[i]]
  
  cat(i, "\t", result$sentence[result$sentence_id == my_sent_id][1], "\n")
  
}

### Basic frequency statistics

# calculate number of tokens
n_tokens <- length(result$token)
n_tokens

# calculate number of types
n_types <- length(unique(result$token))
n_types

# calculate number of lemma types
n_lemmas <- length(unique(result$lemma))
n_lemmas

# then, you can calculate type/token ratio
n_types/n_tokens

### Overall stats per part of speech

# calculate frequencies of "upos"
stats <- txt_freq(result$upos)

# convert to factor (to simplify visualization)
stats$key <- factor(stats$key, 
                    levels = stats$key)

# plot result using ggplot (from tidyverse)
ggplot(data = stats, mapping = aes(x = key, y = freq)) +
  geom_bar(stat = "identity", fill = "cadetblue") +
  labs(title = "UPOS (Universal Parts of Speech)\nfrequency of occurrence")

### NOUNS
# same procedure as above, but preselecting just nouns
stats <- subset(result, 
                upos %in% c("NOUN")) 

stats <- txt_freq(stats$token)

stats$key <- factor(stats$key, 
                    levels = stats$key)

ggplot(data = stats[1:20,], mapping = aes(x = key, y = freq)) +
  geom_bar(stat = "identity", fill = "cadetblue") +
  labs(title = "Most occurring nouns")

### ADJECTIVES
# same procedure as above, but preselecting just adjectives
stats <- subset(result, 
                upos %in% c("ADJ")) 

stats <- txt_freq(stats$token)

stats$key <- factor(stats$key, 
                    levels = stats$key)

ggplot(data = stats[1:20,], mapping = aes(x = key, y = freq)) +
  geom_bar(stat = "identity", fill = "cadetblue") +
  labs(title = "Most occurring adjectives")

## Using RAKE - (Rapid Automatic Keyword Extraction)
## (Finding keywords) 
stats <- keywords_rake(result, 
                       term = "lemma", 
                       group = "doc_id", 
                       relevant = result$upos %in% c("NOUN", "ADJ"))

stats$key <- factor(stats$keyword, 
                    levels = stats$keyword)

ggplot(data = stats[1:12,], mapping = aes(x = key, y = rake)) +
  geom_bar(stat = "identity", fill = "cadetblue") +
  labs(title = "Keywords identified by RAKE")

# filter out keywords that appear only a few times
stats <- stats %>% filter(freq > 3)

ggplot(data = stats[1:12,], mapping = aes(x = key, y = rake)) +
  geom_bar(stat = "identity", fill = "cadetblue") +
  labs(title = "Keywords identified by RAKE\nappearing at least four times")

### Your turn!!
# Suggested activities: 
# 1. Run the same analyses on a different text from the "corpus" folder (or your own texts, even in different languages...)
# 2. Run slightly different analyses by modifying a bit the code (e.g. look for adverbs instead of adjectives, etc.) 

# Or... freely discuss about your doubts, try ideas, experiment, etc.