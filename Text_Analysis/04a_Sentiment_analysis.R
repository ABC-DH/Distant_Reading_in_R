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

### 1. Basic Syuzhet analysis

# load the package
library(syuzhet) # you will have to do it every time you restart R

# read a text in the folder
text <- readLines("corpus/Doyle_Study_1887.txt")

# collapse it in a single string
text <- paste(text, collapse = "\n")

# here Syuzhet comes into action: it splits the text into sentences
sentences_vector <- get_sentences(text)

# ...and calulates the sentiment for each sentence
syuzhet_vector <- get_sentiment(sentences_vector, method="syuzhet")

# let's visualize the results
syuzhet_vector

# put them in a graph
plot(
  syuzhet_vector, 
  type="l", 
  main="Sentiment Arc", 
  xlab = "Narrative Time", 
  ylab= "Emotional Valence"
)

# ...it is still too noisy: we'll need to use some filters
simple_plot(syuzhet_vector, title = "Sentiment arc")
# here you might get an error: please make the plot area the highest possible

# we can save the plot as a png file
png("my_simple_plot.png", height = 900, width = 1600, res = 150)
simple_plot(syuzhet_vector, title = "Sentiment arc")
dev.off()

# we can also look at the basic emotions (Plutchik)
syuzhet_emotions <- get_nrc_sentiment(sentences_vector)

# and visualize the result (in a matrix)
View(syuzhet_emotions)

# to have an overview, we can calculate the mean for each emotion (i.e. the columns of the matrix)
colMeans(syuzhet_emotions)

### Your Turn (1) - start

# run the same analysis on a different text


### Your Turn (1) - end


### 2. Opening the Syuzhet box

# download the sentiment dictionaries included in Syuzhet
afinn_dict <- get_sentiment_dictionary("afinn")
syuzhet_dict <- get_sentiment_dictionary("syuzhet")
nrc_dict_eng <- get_sentiment_dictionary("nrc")
nrc_dict_deu <- get_sentiment_dictionary("nrc", language = "german")

# let's explore them!
View(afinn_dict)
View(syuzhet_dict)
View(nrc_dict_eng)
View(nrc_dict_deu)

# let's test syuzhet on tough sentences
my_sentence <- "I was not that happy"
get_sentiment(my_sentence, method="syuzhet")
get_sentiment(my_sentence, method="afinn")
get_sentiment(my_sentence, method="nrc")

my_sentence <- "Well, he was like a potato!"
get_sentiment(my_sentence, method="syuzhet")
get_sentiment(my_sentence, method="afinn")
get_sentiment(my_sentence, method="nrc")

# the issue with repeated words
my_sentence <- "He was a happy man"
get_sentiment(my_sentence, method="syuzhet")

my_sentence <- "He was not only a happy man, he was also a happy potato"
get_sentiment(my_sentence, method="syuzhet")

### Your Turn (2) - start

# try other sentences!
my_sentence <- "..."
get_sentiment(my_sentence, method="...", language = "...")


### Your Turn (2) - end

### 3. A "tidy" approach for SA

library(udpipe)
library(tidyverse)

# process the text with udpipe
novel <- readLines('corpus/Doyle_Study_1887.txt')
text <-  paste(novel, collapse = "\n\n")
text_annotated <- udpipe(x = text, object = "english")
View(text_annotated)

# now it's time to do sentiment analysis!
# with tidyverse, we can rapidly annotate the sentiment
text_annotated <- left_join(text_annotated, syuzhet_dict, by = c("lemma" = "word"))
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

### Your Turn (3) - start

# run the same analysis on a different text


### Your Turn (3) - end


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

### Your Turn (4) - start

# plot the sentiment arc of fear for the text we just analyzed



### Your Turn (4) - end
