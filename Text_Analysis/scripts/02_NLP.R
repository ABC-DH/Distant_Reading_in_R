### Natural Language Processing with R

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
# install.packages("word2vec")

### 1. 
### Simple text exploration

# to read another text in the "corpus" folder, you have to change the title
# tip: you can help yourself by using the "Tab" key (autocomplete)
text <- readLines("corpus/Doyle_Study_1887.txt") 
# you might get a warning here (please disregard it!)

# as warnings in readLines are generally useless (and annoying), you might want to disable them
text <- readLines("corpus/Doyle_Study_1887.txt", warn = F)

# R reads the text line by line. To simplify Syuzhet's work, let's collapse it in a single string
text <-  paste(text, collapse = "\n")

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


### Your Turn (1) - start

# look at the distribution of another word in another text
# suggestion: just copy/paste here all the code above
# (at least, lines 20-57)
# modify the code and run it!


### Your Turn (1) - end

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
novel <- readLines("corpus/Doyle_Study_1887.txt", warn = F)
text <-  paste(novel, collapse = "\n\n")
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

### Your Turn (2) - start

# look at the distribution of another part of speech in another text
# as usual: just copy/paste the code above
# (...here you can just select the relevant parts...)
# modify the code and run it!


### Your Turn (2) - end

### 3.
### Word co-occurrences
# annotate the novel (again, if needed)
novel <- readLines("corpus/Doyle_Study_1887.txt")
text <-  paste(novel, collapse = "\n\n")
result <- udpipe(x = text, object = "english")

# calculate cooccurrences
# i.e., how many times words are used in the same sentence
cooc <- cooccurrence(x = result,
                     term = "lemma", 
                     group = c("doc_id", 
                               "paragraph_id", 
                               "sentence_id"))

head(cooc)

# to make results more meaningful, we can limit the analysis just to nouns and adjectives
cooc1 <- cooccurrence(x = subset(result, 
                                 upos %in% c("NOUN", "ADJ")), 
                      term = "lemma", 
                      group = c("doc_id", 
                                "paragraph_id", 
                                "sentence_id"))

head(cooc1)

# we can even look at nouns / adjectives which follow one another
cooc2 <- cooccurrence(result$lemma, 
                      relevant = result$upos %in% c("NOUN", "ADJ"), 
                      skipgram = 1)

head(cooc2)

### Your Turn (3) - start

# calculate cooccurrences of nouns and verbs, using a 5-word window, for "To the lighthouse"
# as usual: just copy/paste the code above
# (...here you can just select the relevant parts...)
# modify the code and run it!


### Your Turn (3) - end

### 4.
### A little peek into word embeddings
library(word2vec)

# we need to download a "pretrained model", more info here: https://github.com/maxoodf/word2vec#basic-usage
download.file(url = "https://owncloud.gwdg.de/index.php/s/zG7Ty3XZGbewAaP/download", destfile = "cb_ns_500_10.w2v")
# just consider that it was trained on 11.8GB English texts corpus!

# we read the model into R
model <- read.word2vec(file = "cb_ns_500_10.w2v", normalize = TRUE)

# then we can predict, the words that are closest to...
predict(model, newdata = c("sherlock", "man"), type = "nearest", top_n = 5)

# we can also make operations: actor - man + woman = ?
wv <- predict(model, newdata = c("actor", "man", "woman"), type = "embedding")
wv <- wv["actor", ] - wv["man", ] + wv["woman", ]
predict(model, newdata = wv, type = "nearest", top_n = 1)

# also:
wv <- predict(model, newdata = c("white", "racism", "person"), type = "embedding")
wv <- wv["white", ] - wv["person", ] + wv["racism", ] 
predict(model, newdata = wv, type = "nearest", top_n = 10)

### Your Turn (4) - start

# experiment a bit with the model!
# try new combinations between words


### Your Turn (4) - end
