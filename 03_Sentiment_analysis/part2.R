# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("udpipe")
# install.packages("tidyverse")
# install.packages("syuzhet")

### 1. Enter UDpipe

library(udpipe)

novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, 
               collapse = "\n")
text_annotated <- udpipe(x = text, 
                 object = "english")
View(text_annotated)

# now it's time to do sentiment analysis!
text_annotated$sentiment <- 0 # initialize the value
download.file("https://github.com/mjockers/syuzhet/raw/master/R/sysdata.rda", destfile = "syuzhet_dict.RData")
load("syuzhet_dict.RData")

for(i in 1:length(syuzhet_dict$word)){
  
  text_annotated$sentiment[which(text_annotated$lemma == syuzhet_dict$word[i])] <- syuzhet_dict$value[i]
  
}

View(text_annotated)

### 2. Enter Tidyverse

library(tidyverse)

# faster sentiment annotation
text_annotated <- left_join(text_annotated, syuzhet_dict, by = c("lemma" = "word"))
View(text_annotated)

# get overall values per sentence
sentences_annotated <- text_annotated %>%
  group_by(sentence_id) %>%
  summarize(sentiment = sum(value, na.rm = T))

View(sentences_annotated)

### 3. Plot sentiment with tidyverse

library(syuzhet)

###function for rolling plot (taken from https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R)
rolling_plot <- function (raw_values, window = 0.1){
  wdw <- round(length(raw_values) * window)
  rolled <- rescale(zoo::rollmean(raw_values, k = wdw, fill = 0))
  half <- round(wdw/2)
  rolled[1:half] <- NA
  end <- length(rolled) - half
  rolled[end:length(rolled)] <- NA
  return(rolled)
}

# apply rolling function
sentences_annotated$rolled_sentiment <- rolling_plot(sentences_annotated$sentiment)
View(sentences_annotated)

# create index for percentage of book
sentences_annotated$book_percentage <- 1:length(sentences_annotated$sentence_id)/length(sentences_annotated$sentence_id)*100
View(sentences_annotated)

p1 <- ggplot(data = sentences_annotated) +
  geom_line(mapping = aes(x = book_percentage, y = rolled_sentiment)) +
  ggtitle("my sentiment arc") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(minor_breaks = seq(0,100,5), breaks = seq(0,100,10))
p1  

### 4. Multi-dimensional SA (with SentiArt)
# info: https://github.com/matinho13/SentiArt

# read SentiArt dictionary
sentiart <- read.csv("resources/SentiArt.csv", stringsAsFactors = F)
View(sentiart)

# note: Sentiart includes values per word (not lemma) in lowercase, so we need to lowercase the tokens in our text and perform the analysis on them
text_annotated$token_lower <- tolower(text_annotated$token)

# use left_join to add multiple annotations at once
text_annotated <- left_join(text_annotated, sentiart, by = c("token_lower" = "word")) 

# possible issue: the annotation of stopwords!
# workaround: use the POS tags to limit the analysis
sentiart_POS_sel <- c("NOUN", "VERB", "ADV", "ADJ")
text_annotated$token_lower[which(!text_annotated$upos %in% sentiart_POS_sel)] <- NA
text_annotated <- left_join(text_annotated, sentiart, by = c("token_lower" = "word")) 

View(text_annotated)

### Your turn!!
# Suggested activities: 
# 1. Run the same analyses on different texts with different syuzhet dictionaries

### -------------- Tip
# the NRC dictionary has a different format: you will need to convert it
my_sentiment <- "joy"
my_language <- "english"
my_nrc <- nrc[nrc$lang == my_language & nrc$sentiment == my_sentiment,]
### --------------

# 2. Work on different languages
# e.g. take one French text from here: https://www.gutenberg.org/browse/languages/fr
# or Italian: https://www.liberliber.it/online/
# or German: https://www.projekt-gutenberg.org/

### -------------- Tip
# easy solution is to pick up a different language in NRC, but as it was Google translated, this is not ideal
# better find a dictionary that was developed specifically for that language (but you will have to adapt it to a format similar to sentiArt above) and apply the updipe procedure as above
# see for example the FEEL emotion lexicon for French: http://advanse.lirmm.fr/feel.php
# for multiple languages, see also these ones: https://github.com/opener-project/public-sentiment-lexicons/tree/master/propagation_lexicons
# (...but they will need a bit of adaptation)
### --------------

# 3. Think about a possible rule to manage valence shifters

### -------------- Tip
# A very nice package that does valence shifters: https://github.com/trinker/sentimentr
# ...but it works just for English: https://github.com/trinker/sentimentr/issues/74
### --------------

# Or... freely discuss about your doubts, try ideas, experiment, etc.

