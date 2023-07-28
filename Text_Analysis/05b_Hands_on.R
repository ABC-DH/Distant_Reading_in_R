### Hands-on (NLP extra)

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
# install.packages("tidytext")

library(udpipe)
library(tidyverse)
library(tidytext)

### 1. 
### Upos comparisons

# get names of all files in new corpus
all_files <- list.files("corpus_short", full.names = T)

# read them and assign names
texts <- lapply(all_files, readLines) 
names(texts) <- gsub("corpus_short/|.txt", "", all_files)

# use udpipe to annotate them all
texts_annotated <- lapply(texts, function(my_text) udpipe(x = my_text, object = "english"))

# result is a list, we need to convert it to a dataframe
texts_annotated <- bind_rows(texts_annotated, .id = "document")

# calculate stats: n_tokens and n_upos per document
stats <- texts_annotated %>%
  group_by(document) %>%
  mutate(n_tokens = n()) %>%
  ungroup() %>%
  group_by(document, upos, n_tokens) %>%
  summarise(freq = n())

# calculate relative frequencies (divide n_upos per n_tokens)
stats$rel_freq <- stats$freq/stats$n_tokens

# plot results with wrap
ggplot(data = stats, mapping = aes(x = upos, y = rel_freq)) +
  geom_bar(stat = "identity", fill = "cadetblue") +
  facet_wrap(~document) +
  labs(title = "UPOS (Universal Parts of Speech)\nfrequency of occurrence")

# plot results with dodge
ggplot(data = stats, mapping = aes(x = upos, y = rel_freq, fill = document)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "UPOS (Universal Parts of Speech)\nfrequency of occurrence")

### 2. 
### Noun comparisons

# focus analysis on nouns
texts_annotated_red <- subset(texts_annotated, 
                upos %in% c("NOUN")) 

# calculate stats for nouns
stats <- texts_annotated_red %>%
  group_by(document) %>%
  mutate(n_tokens = n()) %>%
  ungroup() %>%
  group_by(document, token, n_tokens) %>%
  summarise(freq = n())

# calculate relative frequency
stats$rel_freq <- stats$freq/stats$n_tokens

# reduce dataset to the 10 most frequent nouns per document
stats <- stats %>%
  group_by(document) %>%
  slice_max(rel_freq, n = 10) %>% 
  ungroup() %>%
  arrange(document, -rel_freq)

# print plot 
stats %>%
  mutate(term = reorder_within(token, rel_freq, document)) %>%
  ggplot(aes(rel_freq, term, fill = factor(document))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ document, scales = "free") +
  scale_y_reordered()

### 3. 
### Word trends

# define words to check
words_to_check <- c("man", "tea")

# add year information to dataset
year_tmp <- strsplit(texts_annotated$document, "_")
texts_annotated$year <- as.numeric(sapply(year_tmp, function(x) x[3]))

# plot frequency per year
texts_annotated %>%
  group_by(year) %>%
  summarise(count = sum(token %in% words_to_check)) %>%
  ggplot(mapping = aes(year, count)) +
  geom_line() +
  ggtitle(paste("Occurrences of", paste(words_to_check, collapse = " and ")))

