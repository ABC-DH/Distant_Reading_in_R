# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("syuzhet")

### 1. Basic Syuzhet analysis

# load the package
library(syuzhet) # you will have to do it every time you restart R

# read a text in the folder
# to read another text in the "corpus" folder, you have to change the title
# tip: you can help yourself by using the "Tab" key (autocomplete)
text <- readLines("corpus/Doyle_Study_1887.txt") 
# you might get a warning here (please disregard it!)

# as warnings in readLines are generally useless (and annoying), you might want to disable them
text <- readLines("corpus/Doyle_Study_1887.txt", warn = F)

# R reads the text line by line. To simplify Syuzhet's work, let's collapse it in a single string
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

# we can save the plot as a png file
png("my_simple_plot.png", height = 900, width = 1600, res = 100)
simple_plot(syuzhet_vector, title = "Sentiment arc")
dev.off()

# we can also look at the basic emotions (Plutchik)
syuzhet_emotions <- get_nrc_sentiment(sentences_vector)

# and visualize the result (in a matrix)
View(syuzhet_emotions)

# to have an overview, we can calculate the mean for each emotion (i.e. the columns of the matrix)
colMeans(syuzhet_emotions)

### 2. Opening the Syuzhet box

# download the sentiment dictionaries included in Syuzhet
download.file("https://github.com/mjockers/syuzhet/raw/master/R/sysdata.rda", destfile = "syuzhet_dict.RData")
load("syuzhet_dict.RData")

# let's explore them!
View(afinn)
View(syuzhet_dict)
# etc.

# let's test syuzhet on tough sentences
my_sentence <- "Well, he was like a potato!"
get_sentiment(my_sentence, method="syuzhet")

# give me one sentence!
my_sentence <- "..."
get_sentiment(my_sentence, method="syuzhet")

# the issue with repeated words
my_sentence <- "He was a happy man"
get_sentiment(my_sentence, method="syuzhet")

my_sentence <- "He was not only a happy man, he was also a happy potato"
get_sentiment(my_sentence, method="syuzhet")

# why is this happening? See here, line 168: https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R
sum(syuzhet_dict[which(syuzhet_dict$word %in% char_v), "value"])
# we'll get an error: so we need to find how 'char_v' was created
char_v <- unlist(strsplit(my_sentence, "[^A-Za-z']+"))
char_v

sum(syuzhet_dict[which(syuzhet_dict$word %in% char_v), "value"])

### 3. Towards the "tidy" approach

char_v

# start from creating a dataframe with the tokenized text
my_output <- data.frame(tokens = char_v, value = 0)
View(my_output)

# reverse the syuzhet procedure
# using a loop on the dictionary
for(i in 1:length(syuzhet_dict$word)){
  
  my_output$value[which(my_output$tokens == syuzhet_dict$word[i])] <- syuzhet_dict$value[i]
  
}

View(my_output)

# so now we can calculate the new sentiment value
sum(my_output$value)

### Your turn!!
# Suggested activities: 
# 1. Run the same analyses on a different text from the "corpus" folder
# 2. Try out syuzhet on tougher sentences

# Or... freely discuss about your doubts, try ideas, experiment, etc.