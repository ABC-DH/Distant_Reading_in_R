### Pdf_to_txt_automatic

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
# install.packages("pdftools")

# you can also install them by using the yellow warning above
# (...if it appears)

library(pdftools)

# read the pdf files
my_files <- list.files("corpus_PDF", full.names = T)

# read files one by one and convert them to txt
for(my_file in my_files){
  
  # print the file name to be processed
  print(my_file)
  
  # read the pdf file to a R variable
  my_text <- pdf_text(pdf = my_file)

  # write it to text file (by just changing the extension of the orginal filename)
  cat(my_text, file = gsub(pattern = ".pdf", replacement = ".txt", x = my_file))
  
}

# Check "file_1.txt" and "file_2.txt" in the "corpus_PDF" folder
# Note that the result is quite dirty (a lot of spaces and newlines where they should not be...)
# Still, the files should be ok for running stylometric analyses and topic modeling (you just need to move them to the "corpus" folder)
