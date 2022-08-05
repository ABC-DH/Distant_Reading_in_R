### Hands-on with R

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
# install.packages("syuzhet")

### 1. Wiktor's latin analysis

library(udpipe)
library(tidyverse)
library(syuzhet)

# process latin text
text <- "Ego sum felix sicut annuum"
text_annotated <- udpipe(x = text, object = "latin")

# get lating dictionary
nrc_dict_lat <- get_sentiment_dictionary("nrc", language = "latin")

# convert to multiple column table
nrc_dict_lat_wide <- pivot_wider(nrc_dict_lat, names_from = sentiment, values_from = value) 

# warning! check issue
View(nrc_dict_lat_wide)

# multiple entries
nrc_dict_lat %>% filter(word == "ingenium")

# better abort!!!

# chose a better dictionary
# see this paper: https://aclanthology.org/2020.lrec-1.376.pdf
latin_dict <- read.csv("resources/LatinAffectusv2.tsv", sep = "\t")

# annotate the text with that dictionary
text_annotated <- left_join(text_annotated, latin_dict, by = c("lemma" = "lemma"))
View(text_annotated)

### 2. Maria's multiple plots

library(udpipe)
library(tidyverse)
library(syuzhet)

# function for rolling plot (taken from https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R)
rolling_plot <- function (raw_values, window = 0.1){
  wdw <- round(length(raw_values) * window)
  rolled <- rescale(zoo::rollmean(raw_values, k = wdw, fill = 0))
  half <- round(wdw/2)
  rolled[1:half] <- NA
  end <- length(rolled) - half
  rolled[end:length(rolled)] <- NA
  return(rolled)
}

# get dictionary
syuzhet_dict <- get_sentiment_dictionary("syuzhet")

# process the first text with udpipe
novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, collapse = "\n\n")
text_annotated <- udpipe(x = text, object = "english")

# now it's time to do sentiment analysis!
# with tidyverse, we can rapidly annotate the sentiment
text_annotated <- left_join(text_annotated, syuzhet_dict, by = c("lemma" = "word"))

# get overall values per sentence
sentences_annotated <- text_annotated %>%
  group_by(sentence_id, sentence) %>%
  summarize(sentiment = sum(value, na.rm = T))

# apply rolling function
sentences_annotated$rolled_sentiment <- rolling_plot(sentences_annotated$sentiment)

# create index for percentage of book
sentences_annotated$book_percentage <- 1:length(sentences_annotated$sentence_id)/length(sentences_annotated$sentence_id)*100

# create a full df
sentences_annotated$text <- "A Study in Scarlet"
sentences_annotated_all <- sentences_annotated

# process the second text with udpipe
novel <- readLines('corpus/Doyle_Hound_1902.txt')
text <-  paste(novel, collapse = "\n\n")
text_annotated <- udpipe(x = text, object = "english")

# now it's time to do sentiment analysis!
# with tidyverse, we can rapidly annotate the sentiment
text_annotated <- left_join(text_annotated, syuzhet_dict, by = c("lemma" = "word"))

# get overall values per sentence
sentences_annotated <- text_annotated %>%
  group_by(sentence_id, sentence) %>%
  summarize(sentiment = sum(value, na.rm = T))

# apply rolling function
sentences_annotated$rolled_sentiment <- rolling_plot(sentences_annotated$sentiment)

# create index for percentage of book
sentences_annotated$book_percentage <- 1:length(sentences_annotated$sentence_id)/length(sentences_annotated$sentence_id)*100

# add to full df
sentences_annotated$text <- "The Hound of the Baskervilles"
sentences_annotated_all <- rbind(sentences_annotated_all, sentences_annotated)

p1 <- ggplot(data = sentences_annotated_all) +
  geom_line(mapping = aes(x = book_percentage, y = rolled_sentiment, color = text)) +
  ggtitle("my sentiment arc") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(minor_breaks = seq(0,100,5), breaks = seq(0,100,10))
p1  


### 3. Silvia's fear graph

library(udpipe)
library(tidyverse)

# function for rolling plot (taken from https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R)
rolling_plot <- function (raw_values, window = 0.1){
  wdw <- round(length(raw_values) * window)
  rolled <- rescale(zoo::rollmean(raw_values, k = wdw, fill = 0))
  half <- round(wdw/2)
  rolled[1:half] <- NA
  end <- length(rolled) - half
  rolled[end:length(rolled)] <- NA
  return(rolled)
}

# process the text with udpipe
novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, collapse = "\n\n")
text_annotated <- udpipe(x = text, object = "english")
View(text_annotated)

# read SentiArt dictionary
sentiart <- read.csv("resources/SentiArt.csv", stringsAsFactors = F)
View(sentiart)

# note: Sentiart includes values per word (not lemma) in lowercase, so we need to lowercase the tokens in our text and perform the analysis on them
text_annotated$token_lower <- tolower(text_annotated$token)

# possible issue: the annotation of stopwords!
# workaround: use the POS tags to limit the analysis
sentiart_POS_sel <- c("NOUN", "VERB", "ADV", "ADJ")
text_annotated$token_lower[which(!text_annotated$upos %in% sentiart_POS_sel)] <- NA
text_annotated <- left_join(text_annotated, sentiart, by = c("token_lower" = "word")) 

View(text_annotated)

# plot the sentiment arc of fear for the text we just analyzed
sentences_annotated <- text_annotated %>%
  group_by(sentence_id, sentence) %>%
  summarize(fear = sum(fear_z, na.rm = T))

# use rolling plot function
sentences_annotated$rolled_sentiment <- rolling_plot(sentences_annotated$fear)
View(sentences_annotated)

# create index for percentage of book
sentences_annotated$book_percentage <- 1:length(sentences_annotated$sentence_id)/length(sentences_annotated$sentence_id)*100
View(sentences_annotated)

# visualize graph
p1 <- ggplot(data = sentences_annotated) +
  geom_line(mapping = aes(x = book_percentage, y = rolled_sentiment)) +
  ggtitle("my fear arc") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(minor_breaks = seq(0,100,5), breaks = seq(0,100,10))
p1  