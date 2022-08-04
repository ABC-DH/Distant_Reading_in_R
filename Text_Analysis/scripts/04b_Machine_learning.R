### Machine learning with R

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("irr")
# install.packages("syuzhet")
# install.packages("e1071")
# install.packages("caret")

library(irr)

# find all files
all_tables <- list.files(path = "Machine_Learning_Files", pattern = "Group", full.names = T)

# divide them into the two groups
tablesA <- all_tables[which(grepl("A", all_tables))]
tablesB <- all_tables[which(grepl("B", all_tables))]

# iterate on all files to build just two tables
df_A <- data.frame()
df_B <- data.frame()
for(i in 1:length(tablesA)){
  
  df_A_tmp <- read.csv(tablesA[i], stringsAsFactors = F)
  df_A_tmp$annotator <- gsub("Machine_Learning_Files/GroupA_|.csv", "", tablesA[i])
  df_A <- rbind(df_A, df_A_tmp)
  
  df_B_tmp <- read.csv(tablesB[i], stringsAsFactors = F)
  df_B_tmp$annotator <- gsub("Machine_Learning_Files/GroupB_|.csv", "", tablesB[i])
  df_B <- rbind(df_B, df_B_tmp)
  
}

# re-establish annotation order
df_A <- df_A[order(df_A$...1),]
df_B <- df_B[order(df_B$...1),]

# check if there are errors
table(df_A$arousal)
table(df_B$arousal)

df_A[which(!df_A$arousal %in% c("H", "L")),]
df_B[which(!df_B$arousal %in% c("H", "L")),]

# save as .csv for (possible) corrections
write.csv(df_A, file = "Machine_Learning_Files/DatasetA.csv")
write.csv(df_B, file = "Machine_Learning_Files/DatasetB.csv")

# correct manually if needed

# read again
df_A <- read.csv("Machine_Learning_Files/DatasetA.csv", stringsAsFactors = F)
df_B <- read.csv("Machine_Learning_Files/DatasetB.csv", stringsAsFactors = F)

# join everything in a single dataframe
full_df <- cbind(df_A, df_B$arousal, df_B$annotator, stringsAsFactors = F)

# rename columns
full_df$X <- NULL
full_df$...1 <- NULL
colnames(full_df) <- c("text", "arousal_1", "annotator_1", "arousal_2", "annotator_2")

# inspect
View(full_df)

# find cases of disagreement
full_df$agreed <- full_df$arousal_1 == full_df$arousal_2

# calculate how many
length(which(!full_df$agreed))

# calculate inter-annotator agreement
kappa2(full_df[,c(2,4)])

# calculate IAA per annotator
all_annotators <- unique(c(full_df$annotator_1, full_df$annotator_2))
annotators_agreement <- numeric()

for(i in 1:length(all_annotators)){
  
  df_tmp <- full_df[which(full_df$annotator_1 == all_annotators[i] |
                            full_df$annotator_2 == all_annotators[i]),]
  annotators_agreement[i] <- kappa2(df_tmp[,c(2,4)])$value
  
}

# see the annotators agreement
names(annotators_agreement) <- all_annotators
annotators_agreement

# curate the data
full_df$curated <- ""

for(i in 1:length(full_df$agreed)){
  
  if(!full_df$agreed[i]){
    
    score_ann_1 <- annotators_agreement[which(names(annotators_agreement) == full_df$annotator_1[i])]
    score_ann_2 <- annotators_agreement[which(names(annotators_agreement) == full_df$annotator_2[i])]
    
    if(score_ann_1 > score_ann_2){
      
      full_df$curated[i] <- full_df$arousal_1[i]
      
    }else{
      
      full_df$curated[i] <- full_df$arousal_2[i]
      
    }
    
  }else{
    
    full_df$curated[i] <- full_df$arousal_1[i]
    
  }
  
}

# view result
View(full_df)

# all is ready for machine learning!

# first, we need to create embeddings
# we perform sentiment analysis using syuzhet
library(syuzhet)
library(e1071)
library(caret)

# analysis is performed via a loop that saves results incrementally in a dataframe
emotions_df <- get_nrc_sentiment(full_df$text[1])
for(i in 2:length(full_df$text)){
  
  emotions_df <- rbind(emotions_df, get_nrc_sentiment(full_df$text[i]))
  print(i)
  
}

# add annotation to dataframe
emotions_df$truth <- full_df$curated
View(emotions_df)

# split corpus into train and test
K <- 5
test_size <- trunc(length(emotions_df$truth)/K)

# create train and test
test <- emotions_df[1:test_size,]
train <- emotions_df[-(1:test_size),]

# extract and hide the true answer in the test set
true_answer <- test$truth
test$truth <- NULL

# then we train the model
model <- svm(train$truth~., train, type = "C")

# and we test it on the new data (test set)
res <- predict(model, newdata=test)

# compare results with true answer
final_results <- data.frame(true_answer, prediction = res)
View(final_results)

# get overall accuracy
length(which(final_results$true_answer == final_results$prediction)) / length(final_results$true_answer)

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
  
  return(report_df)
  
}

# call the function
report_df <- detailed_report(my_labels = unique(final_results$prediction), res = final_results$prediction, answer = final_results$true_answer)

# view the result
View(report_df)

# extra: see the importance of features
for(i in 1:length(test)){
  
  # delete the feature of interest
  train_tmp <- train[,-i]
  test_tmp <- test[,-i]
  
  # then we train the model
  model <- svm(train_tmp$truth~., train_tmp, type = "C")
  
  # and we test it on the new data (test set)
  res <- predict(model, newdata=test_tmp)
  
  # compare results with true answer
  final_results <- data.frame(true_answer, prediction = res)
  
  # call the function
  report_df_tmp <- detailed_report(my_labels = unique(final_results$prediction), res = final_results$prediction, answer = final_results$true_answer)
  
  # print the relevance
  cat(colnames(test)[i], "loss:", report_df$F1[4]-report_df_tmp$F1[4], "\n")
  
}
