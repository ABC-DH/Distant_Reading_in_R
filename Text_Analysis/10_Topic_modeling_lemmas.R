### Topic modeling with lemmas

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
# install.packages("mallet")
# install.packages("tidyverse")
# install.packages("ggwordcloud")
# install.packages("udpipe")

# you can also install them by using the yellow warning above
# (...if it appears)

# load the packages
library(mallet) 
library(tidyverse)
library(ggwordcloud)
library(udpipe)
library(tidytext)

### Define variables
# here you define the variables for your topic modeling
num_topics <- 10 # number of topics
num_iterations <- 200 # number of iterations
len_split <- 10000 # length of the split texts (they will be the actual documents to work on)

# new variables for lemmatization
lemma_corpus_file <- "TM_lemmas.RData"
my_language <- "english"
my_stopwords <- "resources/stopwords-en.stopwords"

# Prepare the corpus
my_texts <- character()

file_list <- list.files("corpus", full.names = T)

# loop modified to convert text to lemmas
# note: it will take some time!
# for this reason, we check if the lemmatized corpus already exists
if(file.exists(lemma_corpus_file)){
  # if yes, we just load it
  load(lemma_corpus_file)
  # if not, we process all files and then save the result
}else{

  for(i in 1:length(file_list)){
    
    # read text
    loaded_file <- readLines(file_list[i], warn = F)
    loaded_file <- paste(loaded_file, collapse = "\n")
    
    # convert to lemmas
    loaded_file <- udpipe(loaded_file, object = my_language)
    # eventually, limit to selected POS (uncomment following line)
    #loaded_file <- loaded_file %>% filter(upos %in% c("NOUN", "ADJ"))
    loaded_file <- paste(loaded_file$lemma, collapse = " ")
    
    # tokenize
    tokenized_text <- unlist(strsplit(loaded_file, "\\W"))
    tokenized_text <- tokenized_text[which(tokenized_text != "")]
    
    # then save the name of the text
    # (we can re-use the names saved in the list_files variable, by deleting the "corpus/" at the beginning)
    text_name <- gsub(pattern = "corpus/|.txt", replacement = "", x = file_list[i])
    
    # get the number of times we can split it
    split_dim <- trunc(length(tokenized_text)/len_split)
    
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
      my_texts <- c(my_texts, tolower(tokenized_text_split[n]))
      # assign names
      names(my_texts)[length(my_texts)] <- paste(text_name, n, sep = "_")
    }
    print(i)
    
  }
  
  # save all to result file
  save.image(lemma_corpus_file)
  
}

# preparation of texts for topic model
text.instances <- 
  mallet.import(text.array = my_texts, 
                stoplist = my_stopwords, # this removes the stopwords (ie. function words) 
                id.array = names(my_texts))

# define all variables (better not to change alpha and beta)
topic.model <- MalletLDA(num.topics=num_topics, alpha.sum = 1, beta = 0.1)

# load documents for topic modeling
topic.model$loadDocuments(text.instances)

# prepare topic models' features (again, you can leave the values as they are)
topic.model$setAlphaOptimization(20, 50) # this is for optimization

# create the topic models
topic.model$train(num_iterations)

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

# visualize the table
View(top_words)

# visualize the first five words per topic
names(firstwords) <- paste("Topic", 1:length(firstwords))
firstwords

### Wordcloud visualization

# prepare the plot
p1 <- ggplot(
  top_words,
  aes(label = term, size = weight)) +
  geom_text_wordcloud_area() +
  scale_size_area(max_size = 20) +
  theme_minimal() +
  facet_wrap(~topic)

# show it
p1

# save it
ggsave(p1, filename = "Topics_wordcloud.png", scale = 1.5)

### Alternative visualization (barcharts)

p2 <- top_words %>%
  mutate(term = reorder_within(term, weight, topic)) %>%
  ggplot(aes(weight, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

# show it
p2

# save it
ggsave(p2, filename = "Topics_barchart.png", scale = 2)

### Cluster the documents per topic

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

### Your Turn - start

# do the topic modeling on a different corpus
# this one for example: https://github.com/computationalstylistics/100_english_novels 

# option 1. you can download the files and simply add them to the "corpus" directory in this project
# option 2. you can create a new project starting from the "100_english_novels" GitHub repo, copy this script there and run it


### Your Turn - end