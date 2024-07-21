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
novel <- readLines('corpus_GR/my_greek_text.txt')
text <-  paste(novel, collapse = "\n\n")
text_annotated <- udpipe(x = text, object = "greek")
View(text_annotated)

# load the greek dictionary
greek_dict <- read.csv("resources/greek-sentiment-lexicon-master/greek_sentiment_lexicon.tsv", sep = "\t")
View(greek_dict)
# as explained in the documentation, the table contains emotion annotations by multiple annotators
# one simple solution is to calculate the mean for a given emotion

# choose an emotion to focus on
my_emotion <- "Anger"

# Function to calculate row means for columns matching a given string
row_means_for_columns <- function(dataframe, pattern) {
  # Identify the columns matching the pattern
  selected_cols <- grep(pattern, colnames(dataframe), value = TRUE)
  
  # Subset the dataframe
  subset_df <- dataframe[, selected_cols]
  
  # Convert columns to numeric
  subset_df[] <- lapply(subset_df, as.numeric)
  
  # Calculate row means
  row_means <- rowMeans(subset_df, na.rm = TRUE)
  
  return(row_means)
}

my_emotion_mean <- row_means_for_columns(greek_dict, my_emotion)

# let's reconstruct the dictionary by using the info extracted
greek_dict_emotion <- data.frame(word = greek_dict$Term,
                                 value = my_emotion_mean)

# now it's time to do sentiment analysis!
# with tidyverse, we can rapidly annotate the sentiment
text_annotated <- left_join(text_annotated, greek_dict_emotion, by = c("lemma" = "word"), relationship = "many-to-many")
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


