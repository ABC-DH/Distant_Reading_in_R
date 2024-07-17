### Natural Language Processing with R

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!
# (it should be YOUR_COMPUTER/*/Distant_Reading_in_R/)

# required packages:
# install.packages("udpipe")
# install.packages("tidyverse")
# install.packages("word2vec")

# you can also install them by using the yellow warning above
# (...if it appears)

### 1. 
### Let's use an NLP library
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

### let's work on one entire novel

# read the novel
my_text <- readLines("corpus/Doyle_Study_1887.txt", warn = F)
head(my_text)

# collapse to a single string (separated by newlines) 
my_text <-  paste(my_text, collapse = "\n\n")

# analyze with Udpipe
result <- udpipe(x = my_text, object = "english")

### Dispersion plots (example taken from Matthew Jockers, Text analysis with R for students of literature, 2014)

# first, let's find the appearances of a certain word in the text
sherlock.v <- which(result$lemma== "Sherlock")
sherlock.v

# second, let's create a vector that represents the entire text
w.count.v <- rep(NA, length(result$lemma))
w.count.v

# ...and add the appearences in the vector
w.count.v[sherlock.v] <- 1
w.count.v[1000:1060]

plot(w.count.v, main="Dispersion Plot of 'Sherlock' in A study in Scarlet",
     xlab="Novel Time", ylab="Sherlock", type= "h" , ylim=c(0,1), yaxt= "n")

### Keyword in context
cat(result$token[(sherlock.v[1]-5):(sherlock.v[1]+5)])

# put it in a loop
for(i in 1:length(sherlock.v)){
  
  cat(i, "\t", result$token[(sherlock.v[i]-5):(sherlock.v[i]+5)], "\n")
  
}

### Better keyword in context (per sentence)

# find sentence id
my_sent_id <- result$sentence_id[sherlock.v[1]]
my_sent_id

# find rows in dataframe with matching sentence id
which(result$sentence_id == my_sent_id)

# print just the first
result$sentence[result$sentence_id == my_sent_id][1]

# put all in a loop
for(i in 1:length(sherlock.v)){
  
  my_sent_id <- result$sentence_id[sherlock.v[i]]
  
  cat(i, "\t", result$sentence[result$sentence_id == my_sent_id][1], "\n")
  
}

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


### Your Turn (1) - start

# try to do the same as above, but for adjectives
# suggestion: just copy/paste the code above
# modify the code and run it!
# (if you feel confident, you can also try to repeat all operations on a different text)



### Your Turn (1) - end


### 2.
### Word embeddings
library(word2vec)

set.seed(1234) # this is necessary for reproducibility

### We can create our own embeddings based on our corpus

# list all text files
all_text_files <- list.files("corpus", full.names = T)
all_text_files

# read them all
all_texts <- lapply(all_text_files, readLines)

# unlist and convert to lowercase
all_texts <- tolower(unlist(all_texts))
head(all_texts)

# now we can train our model (it will take a bit)
model <- word2vec(x = all_texts, type = "cbow", dim = 15, iter = 20)

# we can see the embeddings
embedding <- as.matrix(model)
View(embedding)

# find closest words
lookslike <- predict(model, "man", type = "nearest", top_n = 10)
lookslike

### Your Turn (2) - start

# experiment a bit with the model!
# try with other words
# or train the model with different setups



### Your Turn (2) - end


### Appendix. Pretrained models

# we need to download a "pretrained model", more info here: https://github.com/maxoodf/word2vec#basic-usage
options(timeout = 300) # set download timeout to 5 minutes (default is 1 minute) 
download.file(url = "https://owncloud.gwdg.de/index.php/s/zG7Ty3XZGbewAaP/download", destfile = "cb_ns_500_10.w2v")
# just consider that it was trained on 11.8GB English texts corpus!

# we read the model into R
model <- read.word2vec(file = "cb_ns_500_10.w2v", normalize = TRUE)

# then we can predict, the words that are closest to...
predict(model, newdata = c("sherlock", "man"), type = "nearest", top_n = 5)

# we can also make operations: actor - man + woman = ?
# first, we extract the vectors
wv <- predict(model, newdata = c("actor", "man", "woman"), type = "embedding")
View(wv)
# then we make our "operation" 
wv_new <- wv["actor", ] - wv["man", ] + wv["woman", ]
# and we predict the closest word to the result
predict(model, newdata = wv_new, type = "nearest", top_n = 1)

# also:
wv <- predict(model, newdata = c("white", "racism", "person"), type = "embedding")
wv_new <- wv["white", ] - wv["person", ] + wv["racism", ] 
predict(model, newdata = wv_new, type = "nearest", top_n = 10)
