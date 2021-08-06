# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("stylo")

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

### It can be useful to save the texts into R variables, so we can run multiple analyses on them without having to read them all the times

# First, select all files in the "corpus" folder
file_list <- list.files("corpus", full.names = T)
file_list
### then prepare an empty list for the texts 
my_texts <- list()
### and run a loop on all the files
for(i in 1:length(file_list)){
  # read text (for .txt files)
  if(grepl(pattern = ".txt", x = file_list[i])){
    loaded_file <- readLines(file_list[i], warn = F)
    loaded_file <- paste(loaded_file, collapse = "\n")
  }
  # in case it is an xml file, let's delete the markup
  if(grepl(pattern = ".xml", x = file_list[i])){
    loaded_file <- scan(file_list[i], what = "char", encoding = "utf-8", sep = "\n", quiet = TRUE)
    loaded_file <- delete.markup(loaded_file, markup.type = "xml")
  }
  # If we want to run stylo on the texts, we need to "tokenize" them (i.e. split them into single words)
  # There is a function in the "stylo" package that does it:
  my_texts[[i]] <- stylo::txt.to.words.ext(loaded_file, corpus.lang = "English")
  # then add correct names to the different texts in the list
  # (we can re-use the names saved in the list_files variable, by deleting the "corpus/" at the beginning)
  names(my_texts)[i] <- gsub(pattern = "corpus/|.txt|.xml", replacement = "", x = file_list[i])
  # print progress
  print(i)
}

# now you can explore the list: each element contains one tokenized text
names(my_texts)
head(my_texts[[1]])
head(my_texts[[2]])

### Now everything is ready to run stylo on the texts that we have saved in the R list
### We can even call stylo by deactivating the GUI, and setting all the features via R code
results_stylo <- stylo(gui = FALSE, 
      corpus.lang="English", 
      analysis.type="CA", 
      mfw.min=2000, 
      mfw.max=2000,
      distance.measure="dist.wurzburg",
      parsed.corpus = my_texts)
# Note: the results of the analysis have been saved in a variable called "stylo_results"

### 3. Explore
results_stylo$distance.table
# Note: the "$" simbol is used to see the sub-section in a structured variable

### see the name of the texts in the distance table
rownames(results_stylo$distance.table)

### see a portion of the distance table
### for example the one of the first text in our selection
results_stylo$distance.table[1,]

### which one is the "closest" text?
sort(results_stylo$distance.table[1,])

### see a table with the frequency of all words
results_stylo$frequencies.0.culling
# rows are the texts, columns the words

### produce a list of the most frequent words
colnames(results_stylo$frequencies.0.culling)

### which is the position in the table of the word "lights"
lights_position <- which(colnames(results_stylo$frequencies.0.culling) == "lights")

### which author uses "lights" more frequently?
sort(results_stylo$frequencies.0.culling[,lights_position], decreasing = T)

### Your turn!!
# Suggested activities: 
# 1. Run the same analyses on a different corpus (e.g. in a different language)
# see for example the corpora available here: https://github.com/computationalstylistics?tab=repositories
# or this for French: https://github.com/COST-ELTeC/ELTeC-fra/tree/master/plain1
# or this for Italian: https://github.com/COST-ELTeC/ELTeC-ita/tree/master/level1

### -------------- Tip
# you can explore the ELTeC repository for more languages: 
# my suggestion it to use just "level1" or "plain1" corpora
# careful because you might find XML files, not TXT (no big issue, as you will notice that stylo can take XML as an input)
# also: the names of the files might have to be changed, as stylo requires this format: Author_title_anything.else 

# here is a script for the italian ELTeC corpus, which you can reuse or adapt
my_corpus <- list.files("ELTeC-ita/level1", pattern = ".xml", full.names = T)
my_titles <- list.files("ELTeC-ita/level1", pattern = ".xml", full.names = F)

unlink("corpus", recursive = T) # careful, because this function will delete your "corpus" folder and all its files!!
dir.create("corpus")

newNames <- strsplit(my_titles, "_|\\.")
newNames <- unlist(lapply(newNames, function(x) paste(x[2], "_", x[1], ".xml", sep = "")))
file.copy(from = my_corpus, to = "corpus")
file.rename(from = file.path("corpus", my_titles), to = file.path("corpus", newNames))

### --------------

# Or... freely discuss about your doubts, try ideas, experiment, etc.
