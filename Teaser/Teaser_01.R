### Teaser

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

install.packages("udpipe")
install.packages("tidyverse")
install.packages("syuzhet")
install.packages("mallet")
install.packages("stylo")


### 1. 
### Natural language processing

# load the library
library(udpipe)
library(tidyverse)

### Simplest example

# choose a text
my_text <- "To be or not to be. That is the question."

# annotate it with udpipe!
x <- udpipe(x = my_text, object = "english")
View(x)

# of course, you can also work on different languages
my_text <- "Nel mezzo del cammin della mia vita, mi ritrovai per una selva oscura."

# annotate it with udpipe!
x <- udpipe(x = my_text, object = "italian")
View(x)

# let's work on one entire novel
novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, collapse = "\n")
result <- udpipe(x = text, object = "english")

### Dispersion plot

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

### Word co-occurrences

# calculate cooccurrences
# i.e., how many times words are used in the same sentence
# to make results more meaningful, we can limit the analysis just to nouns and adjectives
cooc1 <- cooccurrence(x = subset(result, 
                                 upos %in% c("NOUN", "ADJ")), 
                      term = "lemma", 
                      group = c("doc_id", 
                                "paragraph_id", 
                                "sentence_id"))

head(cooc1)

### 2.
### Sentiment analysis

# load the package
library(syuzhet) # you will have to do it every time you restart R

# here Syuzhet comes into action: it splits the text into sentences
sentences_vector <- get_sentences(text)

# ...and calulates the sentiment for each sentence
syuzhet_vector <- get_sentiment(sentences_vector, method="syuzhet")

# let's visualize the results
syuzhet_vector

# put them in a graph
plot(
  syuzhet_vector, 
  type="l", 
  main="Sentiment Arc", 
  xlab = "Narrative Time", 
  ylab= "Emotional Valence"
)

# ...it is still too noisy: we'll need to use some filters
simple_plot(syuzhet_vector, title = "Sentiment arc")

# we can also look at the basic emotions (Plutchik)
syuzhet_emotions <- get_nrc_sentiment(sentences_vector)

# and visualize the result (in a matrix)
View(syuzhet_emotions)

# to have an overview, we can calculate the mean for each emotion (i.e. the columns of the matrix)
colMeans(syuzhet_emotions)


### 3.
### Topic modeling

# load the packages
# remember that you will have to do it every time you restart R
library(mallet) 

# Define variables
num_topics <- 10 # number of topics
len_split <- 10000 # length of the split texts (they will be the actual documents to work on)

# Prepare the corpus
tm_corpus <- list()
my_texts <- character()
file_list <- list.files("corpus", full.names = T)

# First loop: read file and tokenize them (in the easiest way)
for(i in 1:length(file_list)){
  
  # read text
  loaded_file <- readLines(file_list[i], warn = F)
  loaded_file <- paste(loaded_file, collapse = "\n")
  
  # tokenize
  tm_corpus[[i]] <- unlist(strsplit(loaded_file, "\\W"))
  tm_corpus[[i]] <- tm_corpus[[i]][which(tm_corpus[[i]] != "")]
  # then add correct names to the different texts in the list
  # (we can re-use the names saved in the list_files variable, by deleting the "corpus/" at the beginning)
  names(tm_corpus)[i] <- gsub(pattern = "corpus/|.txt", replacement = "", x = file_list[i])
  
  # print progress
  print(i)
  
}

# Second loop to generate final files
counter <- 1
for(i in 1:length(tm_corpus)){
  # work on single text
  tokenized_text <- tm_corpus[[i]]
  # get total length
  len_limit <- length(tokenized_text)
  # use total length to get the number of times you can split it
  split_dim <- trunc(len_limit/len_split)
  # then do the actual splitting
  tokenized_text_split <- split(tokenized_text, ceiling(seq_along(tokenized_text)/len_split))
  # last part will be shorter than the set length, so better merge it with the previous one
  tokenized_text_split[[length(tokenized_text_split)-1]] <- c(tokenized_text_split[[length(tokenized_text_split)-1]], tokenized_text_split[[length(tokenized_text_split)]])
  tokenized_text_split <- tokenized_text_split[-length(tokenized_text_split)]
  # then collapse back the split texts into a single string 
  tokenized_text_split <- unlist(lapply(tokenized_text_split, function(x) paste(x, collapse = " ")))
  # finally we perform a loop on the split texts to incrementally save all in just one variable 
  for(n in 1:length(tokenized_text_split)){
    # put to lowercase
    my_texts[counter] <- tolower(tokenized_text_split[n])
    # assign names
    names(my_texts)[counter] <- paste(names(tm_corpus)[i], n, sep = "_")
    # increase the counter (started as 1 from outside the loop)
    counter <- counter+1
  }
  print(i)
}


# preparation of texts for topic model
text.instances <- 
  mallet.import(text.array = my_texts, 
                stoplist = "resources/stopwords-en.stopwords", # this removes the stopwords (ie. function words) 
                id.array = names(my_texts))

# define all variables (better not to change alpha and beta)
topic.model <- MalletLDA(num.topics=num_topics, alpha.sum = 1, beta = 0.1)

# load documents for topic modeling
topic.model$loadDocuments(text.instances)

# create the topic models
topic.model$setAlphaOptimization(20, 50) # this is for optimization
topic.model$train(200)

# calculate topic per document
doc.topics <- mallet.doc.topics(topic.model, smoothed=TRUE, normalized=TRUE)

# calculate topic per words
topic.words <- mallet.topic.words(topic.model, smoothed=TRUE, normalized=TRUE)

# use a loop to visualize the top words per topic in a table
top_words <- data.frame()
firstwords <- character()
for(i in 1:num_topics){
  words.per.topic <- mallet.top.words(topic.model, word.weights = topic.words[i,], num.top.words = 20)
  words.per.topic$topic <- i
  top_words <- rbind(top_words, words.per.topic)
  firstwords[i] <- paste(words.per.topic$term[1:5], collapse = " ")
}

# visualize the first five words per topic
names(firstwords) <- paste("Topic", 1:length(firstwords))
firstwords

# use the doc.topics to cluster the documents

# first assign names that correspond to:
# the first five words of the topics
colnames(doc.topics) <- firstwords
# the titles of the documents
rownames(doc.topics) <- names(my_texts) # to make them look better, remove "corpus" from the names

# visualize an heatmap and save it to a file
png(filename = "heatmap.png", width = 4000, height = 4000)
heatmap(doc.topics, margins = c(25,25), cexRow = 2, cexCol = 2)
dev.off()

# simplify the visualization 
# start by changing variable type
doc.topics <- as.data.frame(doc.topics)

# create a variable that contains the groups (i.e. the books)
groups_tmp <- rownames(doc.topics)
groups_tmp <- strsplit(groups_tmp, "_")
groups_tmp <- sapply(groups_tmp, function(x) paste(x[1:3], collapse = "_"))

# add it to the dataframe
doc.topics$group <- groups_tmp

# calculate mean for each topic probability per group
doc.topics.simple <- doc.topics %>% 
  group_by(group) %>%
  summarise(across(everything(), mean))

# re-convert the format to matrix
groups_tmp <- doc.topics.simple$group
doc.topics.simple$group <- NULL
doc.topics.simple <- as.matrix(doc.topics.simple)
rownames(doc.topics.simple) <- groups_tmp

# visualize another heatmap and save it to a file
png(filename = "heatmap_simple.png", width = 1000, height = 1000)
heatmap(doc.topics.simple, margins = c(25,25), cexRow = 2, cexCol = 2)
dev.off()

### 4.
### Stylometry

# call the "stylo" library
library(stylo)

# Stylo works by default on the files in the "corpus" folder inside the working directory
# if you are not there, it will ask you to reach that folder
# HOWEVER, it is always good practice to define the working directory from the beginning
# it can be done via the menu "Session" -> "Set Working Directory" -> "Choose Working Directory"
# in the menu, you will have to browse to the folder that contains the "corpus" folder (NOT to the "corpus" folder itself!)

# to use stylo, write this very simple command:
stylo()
# it has a user interface, so (for simple experiments) it does not require coding
