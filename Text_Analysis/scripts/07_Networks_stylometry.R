### Networks for stylometry

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before everything starts: check the working directory!

# required packages:
# install.packages("stylo")
# install.packages("networkD3")

# call the library
library(stylo)

# run the network function (you can keep features to default)
stylo.network()

# this will generate two files:
# Distant_Reading_in_R_Consensus_100-1000_MFWs_Culled_0__Classic Delta_C_0.5_EDGES.csv
# and
# Distant_Reading_in_R_Consensus_100-1000_MFWs_Culled_0__Classic Delta_C_0.5_NODES.csv
# which you can upload in Gephi!
