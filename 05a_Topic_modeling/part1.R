# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("mallet")
# install.packages("ggwordcloud")
# install.packages("igraph")
# install.packages("ggraph")
# install.packages("ggplot2")

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
                stoplist.file = "resources/stopwords-en.stopwords", # this removes the stopwords (ie. function words) 
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
  firstwords[i] <- paste(words.per.topic$words[1:5], collapse = " ")
}

# visualize the table
View(top_words)

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

### Network visualization
# re-using libraries and scripts we have already seen with Udpipe
library(igraph)
library(ggraph)
library(ggplot2)

# we need to create an edges table from the doc.topics matrix
wordnetwork <- expand.grid(colnames(doc.topics), rownames(doc.topics))
colnames(wordnetwork) <- c("topic", "document")
wordnetwork$probability  <- 0

for(i in 1:length(wordnetwork$topic)){
  
  wordnetwork$probability[i] <- doc.topics[which(rownames(doc.topics) == wordnetwork$document[i]),
                                           which(colnames(doc.topics) == wordnetwork$topic[i])]
  
}

# then we can plot the result
wordnetwork <- graph_from_data_frame(wordnetwork)

ggraph(wordnetwork, layout = "fr") +
  geom_edge_link(aes(width = probability, 
                     edge_alpha = probability), 
                 edge_colour = "pink")  +
  geom_node_text(aes(label = name), 
                 col = "darkgreen", 
                 size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  labs(title = "Document/topic network")

# not really good, but with Gephi you can get a much better visualization!

### Wordcloud visualization
# using a specific ggplot library
library(ggwordcloud)

# prepare the plot
p1 <- ggplot(
  top_words,
  aes(label = words, size = weights)) +
  geom_text_wordcloud_area() +
  scale_size_area(max_size = 20) +
  theme_minimal() +
  facet_wrap(~topic)

# show it
p1

# save it
ggsave(p1, filename = "Topics_wordcloud.png", scale = 2.5)

### Your turn!!
# Suggested activities: 
# 1. Run the same analyses on a different corpus (e.g. in a different language)
# see for example the corpora available here: https://github.com/computationalstylistics?tab=repositories
# unfortunaltely, here the ELTeC corpora are not advisable, as mallet cannot deal (directly) with XML files
# 2. How could we integrate udpipe in this topic modeling pipeline? (e.g. for removing not simply stopwords, but precise parts of speech, named entities, etc.)

# Or... freely discuss about your doubts, try ideas, experiment, etc.
