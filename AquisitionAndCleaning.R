  Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_66')
  gc()
  library(tm)
  library(wordcloud)
  library(RWeka)
  library(ggplot2)
  library(dplyr)
  library(qdap)
  
  setwd("D:/DataScienceCertification/Capstone/final/en_US") 
  set.seed(6384)
  
  sample_data1 <- vector(mode="character") 
  
  #This function will read 10,000 lines from each of the 3 English files 
  #and randomly select approximately 5k records from each, concatenating the three samples togehter
  create_sample <- function(sd, sample_size) { 
    for (i in 1:sample_size) { 
      if (rbinom(1, 1, 0.5)) 
        sd <- c(sd, readLines(twitter_con, 1)) 
    }
    
    for (i in 1:sample_size ) {
      if (rbinom(1, 1, 0.5))
        sd <- c(sd, readLines(news_con, 1))
    }
    
    
    for (i in 1:sample_size ) {
      if (rbinom(1, 1, 0.5))
        sd <- c(sd, readLines(blog_con, 1))
    }
    return(sd)
  }
  
  #This function changes the encoding of our sample to ASCII as well loads a 
  #profanity list from Shutterstock and uses it to clean our sample 
  clean_data <- function(sd) { 
    sd<-iconv(sd, to="ASCII", sub = "")
    
    profanity <- read.csv("ShutterStock.csv", stringsAsFactors = FALSE)
    sd <- gsub(paste(profanity$word, collapse = "|"), "", sd, ignore.case=TRUE)
    
    return(sd)
  }
  
  #This function tokenizes the sample data into a text corpus and further cleanses, removing numbers
  #whitespace, capitalization, and multiple white spaces
  tokenize_data <- function(sd) { 
    text_corpus <- Corpus(VectorSource(sd), readerControl = list(language = "en")) 
    
    text_corpus <- tm_map(text_corpus, removeNumbers) 
    text_corpus <- tm_map(text_corpus, removePunctuation) 
    text_corpus <- tm_map(text_corpus , stripWhitespace) 
    text_corpus <- tm_map(text_corpus, tolower) 
    text_corpus <- tm_map(text_corpus, PlainTextDocument)
    
    return(text_corpus)
  }
  
  #This function performs the same functionality as tokenize_data, with the exception of one 
  #extra step - to remove stop words
  tokenize_data_rm_stopwords <- function(sd) { 
    text_corpus <- Corpus(VectorSource(sd), readerControl = list(language = "en")) 
    text_corpus <- tm_map(text_corpus, removeNumbers) 
    text_corpus <- tm_map(text_corpus, removePunctuation) 
    text_corpus <- tm_map(text_corpus , stripWhitespace) 
    text_corpus <- tm_map(text_corpus, tolower) 
    text_corpus <- tm_map(text_corpus, PlainTextDocument)
    text_corpus <- tm_map(text_corpus, removeWords, stopwords("english"))   
    
    return(text_corpus)
  }
  
  #This function creates a Document Term Matrix
  create_termMatrix <- function(tc) { 
    dtm <- DocumentTermMatrix(tc)
    return(dtm)
  }

  #setting up the connections
  twitter_con <- file("en_US.twitter.txt", "r") 
  news_con <- file("en_US.news.txt", "r") 
  blog_con <- file("en_US.blogs.txt", "r")
  
  #creating the sample dataset
  sample_data1 <- create_sample(sample_data1, 40000)
  
  #removing the connections
  remove(blog_con) 
  remove(twitter_con) 
  remove(news_con)
  
  #data cleaning
  sample_data1 <- clean_data(sample_data1) 
  
  #data tokenization
  corp1 <- tokenize_data(sample_data1) 
  
  