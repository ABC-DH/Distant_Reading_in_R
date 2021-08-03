# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("syuzhet")
# install.packages("e1071")
# install.packages("caret")

# load the packages
# remember that you will have to do it every time you restart R
library(syuzhet) 
library(e1071)
library(caret)

# Define variables
len_split <- 5000 # length of the split texts (they will be the actual documents to work on)

# Prepare the corpus
tm_corpus <- list()
my_texts <- character()
file_list <- list.files("corpus", full.names = T)
# let's just add one info: author's gender
gender <- c(rep("F", 3), rep("M", 6), rep("F", 3))

# First loop: read files and tokenize them (in the easiest way)
for(i in 1:length(file_list)){
  
  # read text
  loaded_file <- readLines(file_list[i])
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
  tokenized_text_split[length(tokenized_text_split)-1] <- c(tokenized_text_split[length(tokenized_text_split)-1], tokenized_text_split[length(tokenized_text_split)])
  tokenized_text_split <- tokenized_text_split[-length(tokenized_text_split)]
  # then collapse back the split texts into a single string 
  tokenized_text_split <- unlist(lapply(tokenized_text_split, function(x) paste(x, collapse = " ")))
  # finally we perform a loop on the split texts to incrementally save all in just one variable 
  for(n in 1:length(tokenized_text_split)){
    # put to lowercase
    my_texts[counter] <- tolower(tokenized_text_split[n])
    # assign names
    names(my_texts)[counter] <- paste(gender[i], names(tm_corpus)[i], n, sep = "_")
    # increase the counter (started as 1 from outside the loop)
    counter <- counter+1
  }
  print(i)
}

names(my_texts)

# we perform sentiment analysis using syuzhet
# analysis is performed via a loop that saves results incrementally in a dataframe
emotions_df <- get_nrc_sentiment(my_texts[1])
for(i in 2:length(my_texts)){
  
  emotions_df <- rbind(emotions_df, get_nrc_sentiment(my_texts[i]))
  print(i)
  
}

# define gender for each segment
gender <- strsplit(names(my_texts), "_")
gender <- unlist(lapply(gender, function(x) x[1]))
gender

# add to dataframe
emotions_df$truth <- gender
View(emotions_df)

# split corpus into train and test
K <- 10
test_size <- trunc(length(emotions_df$truth)/K)

# make randomized selection (so that test won't be just the first/last passages)
set.seed(123458) # we set a seed to make the random selection repeatable
full_selection <- sample(1:length(emotions_df$truth), replace = F) # randomized selection

# create train and test
test <- emotions_df[full_selection[1:test_size],]
train <- emotions_df[full_selection[-(1:test_size)],]

# extract and hide the true answer in the test set
true_gender <- test$truth
test$truth <- NULL

# then we train the model
model <- svm(train$truth~., train, type = "C")

# and we test it on the new data (test set)
res <- predict(model, newdata=test)

# compare results with true answer
final_results <- data.frame(true_gender, prediction = res)
View(final_results)

# get overall accuracy
length(which(final_results$true_gender == final_results$prediction)) / length(final_results$true_gender)

# more professional view of results
# let's use a pre-compiled function for doing it!
detailed_report <- function(my_labels, res, answer){
  
  report_df <- data.frame(precision = numeric(), recall = numeric(), F1 = numeric(), support = numeric())
  
  for(n in 1:length(my_labels)){
    
    results_tmp <- confusionMatrix(res, reference = answer, mode = "prec_recall", positive = as.character(my_labels[n]))
    if(length(my_labels) > 2){
      report_df[my_labels[n],] <- c(results_tmp$byClass[paste("Class:", my_labels[n]),]["Precision"], results_tmp$byClass[paste("Class:", my_labels[n]),]["Recall"], results_tmp$byClass[paste("Class:", my_labels[n]),]["F1"],length(which(answer == my_labels[n])))
    }else{
      report_df[as.character(my_labels[n]),] <- c(results_tmp$byClass["Precision"], results_tmp$byClass["Recall"], results_tmp$byClass["F1"],length(which(answer == my_labels[n])))
    }
  }
  
  report_df["accuracy",] <- c(NA,NA,length(which(res==answer))/length(answer),length(answer))
  report_df["macro",] <- c(mean(report_df[1:length(my_labels),1]),
                           mean(report_df[1:length(my_labels),2]),
                           mean(report_df[1:length(my_labels),3]),
                           length(answer))
  precision_weighted <- 0
  recall_weighted <- 0
  F1_weighted <- 0
  for(n in 1:length(my_labels)){
    precision_weighted <- precision_weighted + (report_df[n,1]*report_df[n,4])
    recall_weighted <- recall_weighted + (report_df[n,2]*report_df[n,4])
    F1_weighted <- F1_weighted + (report_df[n,3]*report_df[n,4])
  }
  precision_weighted <- precision_weighted/length(answer)
  recall_weighted <- recall_weighted/length(answer)
  F1_weighted <- F1_weighted/length(answer)
  
  report_df["weighted",] <- c(precision_weighted,
                              recall_weighted,
                              F1_weighted,
                              length(answer))
  
  View(report_df)
  
}

detailed_report(my_labels = unique(final_results$prediction), res = final_results$prediction, answer = final_results$true_gender)
