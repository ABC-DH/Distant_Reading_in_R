# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("udpipe")
# install.packages("tidyverse")
# install.packages("igraph")
# install.packages("ggraph")
# install.packages("word2vec")

library(udpipe)
library(tidyverse)

### 1.
### Word co-occurrences
# annotate the novel
novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, 
               collapse = "\n")
result <- udpipe(x = text, 
                 object = "english")

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

### The result can be easily visualised using the ggraph R package which can visualise the word network.
library(igraph)
library(ggraph)

# nouns and adjectives
wordnetwork <- head(cooc1, 50)

wordnetwork <- graph_from_data_frame(wordnetwork)

ggraph(wordnetwork, 
       layout = "fr") +
  geom_edge_link(aes(width = cooc, 
                     edge_alpha = cooc), 
                 edge_colour = "pink") +
  geom_node_text(aes(label = name), 
                 col = "darkgreen", 
                 size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  theme(legend.position = "none") +
  labs(title = "Cooccurrences within sentence", 
       subtitle = "Nouns & Adjective")

# nouns / adjectives which follow one another
wordnetwork <- head(cooc2, 25)

wordnetwork <- graph_from_data_frame(wordnetwork)

ggraph(wordnetwork, 
       layout = "fr") +
  geom_edge_link(aes(width = cooc, 
                     edge_alpha = cooc),
                 edge_colour = "red") +
  geom_node_text(aes(label = name), 
                 col = "darkgreen", 
                 size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  labs(title = "Words following one another", 
       subtitle = "Nouns & Adjective")

### 2.
### A slightly more sophistocated approach (using correlation instead of co-occurrence)

# create a provisional dataframe with just nouns and adjectives
result_tmp <- subset(result, upos %in% c("NOUN", "ADJ"))

# create a document-term frequency table (taking as documents the sentence unique identifiers)
dtf <- document_term_frequencies(result_tmp, 
                                 document = "sentence_id", 
                                 term = "lemma")
dtf

# create a document-term matrix
dtm <- document_term_matrix(dtf)
dtm

# just to see inside the object, we can convert it to a matrix (but careful, it is a huge object!)
my_dtm <- as.matrix(dtm)
View(my_dtm)

# keep working on the previous object (not easily readable, but much lighter)
# remove words that appear less than five times
dtm <- dtm_remove_lowfreq(dtm, 
                          minfreq = 5)

# just to see inside the object, we can convert it to a matrix (but careful, it is a huge object!)
my_dtm <- as.matrix(dtm)
View(my_dtm)

# then we can calculate correlations (i.e., the similarity between the sparse vectors that represent each word)
termcorrelations <- dtm_cor(dtm)
# for more info on what correlation is: https://en.wikipedia.org/wiki/Pearson_correlation_coefficient

# to make the object explorable, we convert it into a co-occurrence table (even if it is not co-occurrence!)
y <- as_cooccurrence(termcorrelations)

# we exclude correlations below 0.2 (and then put the table in a decreasing order)
y <- subset(y, term1 < term2 & abs(cooc) > 0.2)
y <- y[order(abs(y$cooc), decreasing = TRUE), ]

View(y)

### 3.
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

# Suggested activities: 
# 1. Run the same analyses on a different text from the "corpus" folder (or your own texts, even in different languages...)
# 2. Run slightly different analyses by modifying a bit the code 

# Or... freely discuss about your doubts, try ideas, experiment, etc.