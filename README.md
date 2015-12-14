  library(tm)
  library(wordcloud)
  
  setwd("C:/Users/akorsako/Desktop/final/en_US")
  set.seed(6384)
  
  twitter_con <- file("en_US.twitter.txt", "r")
  news_con <- file("en_US.news.txt", "r")
  blog_con <- file("en_US.blogs.txt", "r")
  
  sample_data1 <- vector(mode="character")
  sample_data2 <- vector(mode="character")
  sample_data3 <- vector(mode="character")
  sample_data4 <- vector(mode="character")
  sample_data5 <- vector(mode="character")
  sample_data6 <- vector(mode="character")
  
  create_sample <- function(sd) {
    for (i in 1:10000) {
      if (rbinom(1, 1, 0.5))
        sd <- c(sd, readLines(twitter_con, 1))
    }
    
    for (i in 1:10000 ) {
      if (rbinom(1, 1, 0.5))
        sd <- c(sd, readLines(news_con, 1))
    }
    
    
    for (i in 1:10000 ) {
      if (rbinom(1, 1, 0.5))
        sd <- c(sd, readLines(blog_con, 1))
    }
    
    return(sd)
}

  clean_data <- function(sd) {
    sd<-iconv(sd, to="ASCII", sub = "")
    
    profanity <- read.csv("ShutterStock.csv", stringsAsFactors = FALSE)
    sd <- gsub(paste(profanity$word, collapse = "|"), "", sd, ignore.case=TRUE)
    
    return(sd)
  }

  tokenize_data <- function(sd) {
    text_corpus <- Corpus(VectorSource(sd), readerControl = list(language = "en"))
    text_corpus <- tm_map(text_corpus, removeNumbers)
    text_corpus <- tm_map(text_corpus, removePunctuation)
    text_corpus <- tm_map(text_corpus , stripWhitespace)
    text_corpus <- tm_map(text_corpus, tolower)
    text_corpus <- tm_map(text_corpus, PlainTextDocument)
    
    return(text_corpus)
  }
  
  create_termMatrix <- function(tc) {
    dtm <- DocumentTermMatrix(tc)
    
    return(dtm)
  }

  sample_data1 <- create_sample(sample_data1)
  sample_data2 <- create_sample(sample_data2)
  sample_data3 <- create_sample(sample_data3)
  sample_data4 <- create_sample(sample_data4)
  sample_data5 <- create_sample(sample_data5)
  sample_data6 <- create_sample(sample_data6)
  
  remove(blog_con)
  remove(twitter_con)
  remove(news_con)
  
  sample_data1 <- clean_data(sample_data1)
  sample_data2 <- clean_data(sample_data2)
  sample_data3 <- clean_data(sample_data3)
  sample_data4 <- clean_data(sample_data4)
  sample_data5 <- clean_data(sample_data5)
  sample_data6 <- clean_data(sample_data6)
  
  corp1 <- tokenize_data(sample_data1)
  corp2 <- tokenize_data(sample_data2)
  corp3 <- tokenize_data(sample_data3)
  corp4 <- tokenize_data(sample_data4)
  corp5 <- tokenize_data(sample_data5)
  corp6 <- tokenize_data(sample_data6) 

  dtm1 <- create_termMatrix(corp1)
  dtm2 <- create_termMatrix(corp2)
  dtm3 <- create_termMatrix(corp3)
  dtm4 <- create_termMatrix(corp4)
  dtm5 <- create_termMatrix(corp5)
  dtm6 <- create_termMatrix(corp6)

  par(mfrow=c(3,2)) 
  wordcloud(corp1, min.freq = 250, random.order = FALSE)
  wordcloud(corp2, min.freq = 250, random.order = FALSE)
  wordcloud(corp3, min.freq = 250, random.order = FALSE)
  wordcloud(corp4, min.freq = 250, random.order = FALSE)
  wordcloud(corp5, min.freq = 250, random.order = FALSE)
  wordcloud(corp6, min.freq = 250, random.order = FALSE)

  

  head(sort(colSums(as.matrix(dtm1)), decreasing=TRUE), 15)
  
  http://www.r-bloggers.com/visualizing-risky-words-part-2/
    
  termFreq <- sort(colSums(as.matrix(dtm1)), decreasing=TRUE)
  termFreq <-subset(termFreq, termFreq>=700)
  qplot(names(termFreq), termFreq, main="Term Frequencies",
        geom="bar", xlab="Terms", stat="identity") + coord_flip()  
  
  df <- data.frame(keyName=names(termFreq), value=termFreq, row.names=NULL, stringsAsFactors = FALSE)
  
  df$Pct <- df$value / sum(df$value)
  
  sum(df$value)
