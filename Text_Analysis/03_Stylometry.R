### Stylometry with R

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
# install.packages("stylo")

# you can also install them by using the yellow warning above
# (...if it appears)

### 1. Delta Analysis

# call the "stylo" library
library(stylo)

# Stylo works by default on the files in the "corpus" folder inside the working directory
# if you are not there, it will ask you to reach that folder
# HOWEVER, it is always good practice to define the working directory from the beginning
# it can be done via the menu "Session" -> "Set Working Directory" -> "Choose Working Directory"
# in the menu, you will have to browse to the folder that contains the "corpus" folder (NOT to the "corpus" folder itself!)

# to use stylo, write this very simple command:
stylo()
# it has a user interface, so (for simple experiments) it does not require coding

# in the first panel (Input & Language), select: "plain text", "English (ALL)", and "Native encoding"
# Try different experiments:
# 100MFW min and max, 0 increment (features), CA with Classic and Cosine Delta (statistics)
# 2000MFW min and max, 0 increment (features), CA with Classic and Cosine Delta (statistics)
# 200-2000MFW, 200 increment (features), BCT with Classic and Cosine Delta (statistics)

# try also sampling, to see to which is the minimum amount of text for Delta to work 
# sampling: random; sample size: 5000
# sampling: random; sample size: 2000
# sampling: random; sample size: 1000
# sampling: random; sample size: 500

# also, note that each analysis has generated a .csv file that can be opened with Gephi (for network analysis)

# It can be useful to save the texts into R variables, so we can run multiple analyses on them without having to read them all the times

# First, select all files in the "corpus" folder
file_list <- list.files("corpus", full.names = T)
file_list

# read them all
all_texts <- lapply(file_list, readLines)

# tokenize them with stylo
all_texts_tokenized <- lapply(all_texts, function(x) txt.to.words.ext(x, corpus.lang = "English"))

# then add correct names to the different texts in the list
# (we can re-use the names saved in the file_list variable, by deleting the "corpus/" at the beginning)
names(all_texts_tokenized) <- gsub(pattern = "corpus/|.txt", replacement = "", file_list)

# now you can explore the list: each element contains one tokenized text
names(all_texts_tokenized)
head(all_texts_tokenized[[1]])
head(all_texts_tokenized[[2]])

# Now everything is ready to run stylo on the texts that we have saved in the R list
# We can even call stylo by deactivating the GUI, and setting all the features via R code
results_stylo <- stylo(gui = FALSE, 
                       corpus.lang="English", 
                       analysis.type="CA", 
                       mfw.min=2000, 
                       mfw.max=2000,
                       distance.measure="dist.wurzburg",
                       parsed.corpus = all_texts_tokenized)
# Note: the results of the analysis have been saved in a variable called "stylo_results"

# Explore
results_stylo$distance.table
# Note: the "$" simbol is used to see the sub-section in a structured variable

# see the name of the texts in the distance table
rownames(results_stylo$distance.table)

# see a portion of the distance table
# for example the one of the first text in our selection
results_stylo$distance.table[1,]

# which one is the "closest" text?
sort(results_stylo$distance.table[1,])

# see a table with the frequency of all words
results_stylo$frequencies.0.culling
# rows are the texts, columns the words

# produce a list of the most frequent words
colnames(results_stylo$frequencies.0.culling)

# which is the position in the table of the word "lights"
lights_position <- which(colnames(results_stylo$frequencies.0.culling) == "lights")

# which author uses "lights" more frequently?
sort(results_stylo$frequencies.0.culling[,lights_position], decreasing = T)

### Your Turn (1) - start

# Run the same analyses on a different corpus (e.g. in a different language)
# see for example this one for German: https://github.com/computationalstylistics/68_german_novels
# or this one for French: https://github.com/COST-ELTeC/ELTeC-fra/tree/master (for easy analysis, use the files in the "plain1" folder)
# or this one for Italian: https://github.com/COST-ELTeC/ELTeC-ita/tree/master (for easy analysis, use the files in the "orig" folder)

# remember that once downloaded the files, you need to change the working directory
# to a directory that contains "corpus" in itself

### Your Turn (1) - end


### 2. Zeta Analysis

# find the texts written by one author (e.g. Woolf)
Chosen_texts <- which(grepl("Woolf", names(all_texts_tokenized)))
Chosen_texts

# We use the "oppose" function, still in the "stylo" package,
# that looks for the most distinctive words.
# The method it uses is known as "Zeta Analysis"
# The corpus should be divided in two parts:
# A "primary set" where we have the texts of interest;
# A "secondary set" to be compared with

# Our primary set are the texts by Woolf
primary_set <- all_texts_tokenized[Chosen_texts]
# Our secondary set are the texts by all the others
secondary_set <- all_texts_tokenized[-Chosen_texts]

# now everything is ready to run an "oppose" analysis
oppose(primary.corpus = primary_set, secondary.corpus = secondary_set)
# in the graphical interface, you can leave things as they are
# please choose the "Words" visualization

### Your Turn (2) - start

# Run the same analyses on a different corpus
# or with different target author(s)


### Your Turn (2) - end
