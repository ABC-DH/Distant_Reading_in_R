### Sentiment analysis with R

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
# install.packages("syuzhet")
# install.packages("udpipe")
# install.packages("tidyverse")

# you can also install them by using the yellow warning above
# (...if it appears)

### 1. A "tidy" approach for SA

library(udpipe)
library(tidyverse)
library(syuzhet)

# process the text with udpipe
novel <- readLines('corpus_FR/my_french_text.txt')
text <-  paste(novel, collapse = "\n\n")
text_annotated <- udpipe(x = text, object = "french")
View(text_annotated)

# load the FEEL dictionary
load("resources/FEEL_fr.rda")
colnames(FEEL_fr) <- c("word", "value")

# now it's time to do sentiment analysis!
# with tidyverse, we can rapidly annotate the sentiment
text_annotated <- left_join(text_annotated, FEEL_fr, by = c("lemma" = "word"))
View(text_annotated)

# get overall values per sentence
sentences_annotated <- text_annotated %>%
  group_by(sentence_id) %>%
  summarize(sentiment = sum(value, na.rm = T))

View(sentences_annotated)

# Plot the sentiment
# with function for rolling plot (taken from https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R)
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


