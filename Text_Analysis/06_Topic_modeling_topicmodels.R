### Topic modeling with R

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
# install.packages("topicmodels")
# install.packages("tidyverse")
# install.packages("tidytext")
# install.packages("ggwordcloud")
# install.packages("maditr")
# install.packages("reshape2")

# you can also install them by using the yellow warning above
# (...if it appears)

# load the packages
library(topicmodels)
library(tidyverse)
library(tidytext)
library(ggwordcloud)
library(maditr)

### Define variables
# here you define the variables for your topic modeling
num_topics <- 10 # number of topics
len_split <- 10000 # length of the split texts (they will be the actual documents to work on)

file_list <- list.files("corpus", full.names = T)
text_name <- gsub(pattern = "corpus/|.txt", replacement = "", x = file_list)

all_texts <- lapply(file_list, function(x) readLines(x, warn = F))
all_texts <- sapply(all_texts, function(x) paste(x, collapse = "\n"))
all_texts <- tibble(document = text_name, text = all_texts)

tokenized_texts <- all_texts %>%
  unnest_tokens(word, text) %>% # tokenize texts
  group_by(document) %>% # group by document
  mutate(subgroup = ceiling(row_number() / len_split)) %>% # create split ids
  ungroup() %>% # remove groups (after usage)
  mutate(ids = paste(document, subgroup, sep = "_")) # add split ids
View(tokenized_texts)

# find document-word counts
word_counts <- tokenized_texts %>%
  anti_join(stop_words) %>% # remove stopwords
  count(ids, word, sort = TRUE) # count words (per split) and sort
View(word_counts)

# create document-term matrix
chapters_dtm <- word_counts %>%
  cast_dtm(ids, word, n)

# create the topic models
my_lda <- LDA(chapters_dtm, k = num_topics)

# explore words in topics
word_topics <- tidy(my_lda, matrix = "beta")

# top 20 words
top_words <- word_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 20) %>% 
  ungroup() %>%
  arrange(topic, -beta)

View(top_words)

# top 5 words collapsed
firstwords <- word_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 5) %>% 
  arrange(topic, -beta) %>%
  summarise(topwords = paste(term, collapse = " ")) %>%
  ungroup()

View(firstwords)

# Wordcloud visualization

# prepare the plot
p1 <- ggplot(
  top_words,
  aes(label = term, size = beta)) +
  geom_text_wordcloud_area() +
  scale_size_area(max_size = 20) +
  theme_minimal() +
  facet_wrap(~topic)

# show it
p1

# save it
ggsave(p1, filename = "Topics_wordcloud_Topicmodels.png", scale = 1.5)

### Alternative visualization (barcharts)

p2 <- top_words %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

# show it
p2

# save it
ggsave(p2, filename = "Topics_barchart_Topicmodels.png", scale = 2)

# explore topics in documents
topics_documents <- tidy(my_lda, matrix = "gamma")
topics_documents

# make tidy table into simple matrix
topics_documents_m <- dcast(data = topics_documents,
                                formula = document~topic,
                                fun.aggregate = sum,
                                value.var = "gamma")

my_rownames <- topics_documents_m$document
topics_documents_m$document <- NULL
topics_documents_m <- as.matrix(topics_documents_m)
rownames(topics_documents_m) <- my_rownames
colnames(topics_documents_m) <- firstwords$topwords

# visualize an heatmap and save it to a file
png(filename = "heatmap_Topicmodels.png", width = 4000, height = 4000)
heatmap(topics_documents_m, margins = c(25,25), cexRow = 2, cexCol = 2)
dev.off()

# simplify the heatmap by averaging gamma values per document/topic
groups_tmp <- strsplit(topics_documents$document, "_")
topics_documents$group <- sapply(groups_tmp, function(x) paste(x[1:3], collapse = "_"))

topics_documents <- topics_documents %>%
  group_by(group, topic) %>%
  summarise(gamma = mean(gamma))

# make tidy table into simple matrix
topics_documents_m <- dcast(data = topics_documents,
                            formula = group~topic,
                            fun.aggregate = sum,
                            value.var = "gamma")

my_rownames <- topics_documents_m$group
topics_documents_m$group <- NULL
topics_documents_m <- as.matrix(topics_documents_m)
rownames(topics_documents_m) <- my_rownames
colnames(topics_documents_m) <- firstwords$topwords

# visualize an heatmap and save it to a file
png(filename = "heatmap_simple_Topicmodels.png", width = 1000, height = 1000)
heatmap(topics_documents_m, margins = c(25,25), cexRow = 2, cexCol = 2)
dev.off()
