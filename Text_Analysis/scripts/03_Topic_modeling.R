### Topic modeling with R

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("mallet")
# install.packages("ggwordcloud")

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

### Your Turn (1) - start

# the easy task :)
# do the topic modeling on a different corpus
# this one for example: https://github.com/computationalstylistics/100_english_novels 

# remember that once downloaded the files, you need to change the working directory
# to a directory that contains "corpus" in itself


### Your Turn (1) - end


### Your Turn (2) - start

# the hard task :)
# try to do the tokenization at the beginning using UDpipe
# then select precise parts of speech, like nouns and adjectives


### Your Turn (2) - end
