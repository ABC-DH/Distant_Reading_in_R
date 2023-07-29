### Hands-on (read srt files)

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# IMPORTANT NOTE: this script works on all the files with ".srt" extension
# in the "hands_on_files" folder. You can delete the sample file there
# and substitute it with your own.

# here we read our .srt files
my_srt_files <- list.files(path = "hands_on_files", pattern = ".srt", full.names = T)
  
# we then loop on their content
for(i in 1:length(my_srt_files)){
  
  my_srt <- readLines(my_srt_files[i])
  
  # remove minutes indications
  my_srt <- my_srt[-which(grepl("-->", my_srt))]
  
  # remove counters
  my_srt <- my_srt[-which(!is.na(as.numeric(my_srt)))]
  
  # and write the content line by line into the "corpus" folder
  my_filename <- gsub("hands_on_files/", "corpus/", my_srt_files[i])
  my_filename <- gsub(".srt", ".txt", my_filename)
  
  cat(my_srt, sep = "\n", file = my_filename)
  
}

# this script will create a series of .txt files in the "corpus" folder,
# on which you can apply all the others scripts presented in the workshop
