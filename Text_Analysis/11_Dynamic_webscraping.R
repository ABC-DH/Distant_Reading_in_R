### Webscraping dynamic websites

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
# install.packages("RSelenium")
# install.packages("tidyverse")
# install.packages("rvest")

# you can also install them by using the yellow warning above
# (...if it appears)

# Before you start the script, you will need to install Docker on your machine (https://docs.docker.com/engine/install/)
# ...and create an image of a browser
# here I'm using "selenium/standalone-firefox:latest"

# libraries
library(RSelenium) 
library(tidyverse)
library(rvest)

# Define the remote driver
remDr <- remoteDriver(port = 4445L) 

# open web browser
remDr$open() 

# Navigate a URL
my_link <- "https://ct24.ceskatelevize.cz/rubrika/kultura-24"
remDr$navigate(my_link)

# Show a screenshot of the page
remDr$screenshot(display = TRUE)

# find and close the cookies banner
# use F12 in your browser to identify the correct xpath
pageblock <- remDr$findElements(using = 'xpath', '//button[@id="onetrust-accept-btn-handler"]')
pageblock[[1]]$clickElement()

# Show a screenshot of the page
remDr$screenshot(display = TRUE)

# find articles
articles <- remDr$findElements(using = 'xpath', '//div[@class="article-link"]')
length(articles)

# click on "more articles"
more_articles <- remDr$findElements(using = 'xpath', '//button[@class="btn-load-more"]')
more_articles[[1]]$clickElement()

# find articles (again)
articles <- remDr$findElements(using = 'xpath', '//div[@class="article-link"]')
length(articles)

# extract HTML of single articles to process it
articles.html <- lapply(articles, function(x){x$getElementAttribute("outerHTML")[[1]]})
articles.list <- lapply(articles.html, function(x){read_html(x)})

# extract links
links <- sapply(articles.list, function(x) x %>% html_nodes(xpath = "//a") %>% html_attr("href"))
links <- paste0("https://ct24.ceskatelevize.cz", links)
links

# titles
titles <- sapply(articles.list, function(x) x %>% html_nodes(xpath = "//h3") %>% html_text())
titles

