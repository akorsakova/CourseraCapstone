# CourseraCapstone

library(tm)

setwd("C:/Users/akorsako/Desktop/final/en_US")
set.seed(6384)

twitter_con <- file("en_US.twitter.txt", "r")
news_con <- file("en_US.news.txt", "r")
blog_con <- file("en_US.blogs.txt", "r")

sample_data <- vector(mode="character")

for (i in 1:10000) {
  if (rbinom(1, 1, 0.5))
    sample_data <- c(sample_data, readLines(twitter_con, 1))
}
remove(twitter_con)

for (i in 1:10000 ) {
  if (rbinom(1, 1, 0.5))
    sample_data <- c(sample_data, readLines(news_con, 1))
}
remove(news_con)

for (i in 1:10000 ) {
  if (rbinom(1, 1, 0.5))
    sample_data <- c(sample_data, readLines(blog_con, 1))
}
remove(blog_con)

profanity <- read.csv("ShutterStock.csv", stringsAsFactors = FALSE)
clean_sample <- gsub(paste(profanity$word, collapse = "|"), "", sample_data, ignore.case=TRUE)


text_corpus <- Corpus(VectorSource(clean_sample), readerControl = list(language = "en"))
text_corpus <- tm_map(text_corpus, removeNumbers)
text_corpus <- tm_map(text_corpus, removePunctuation)
text_corpus <- tm_map(text_corpus , stripWhitespace)
text_corpus <- tm_map(text_corpus, tolower)

corpus_clean <- tm_map(text_corpus, PlainTextDocument)

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tdm <- TermDocumentMatrix(corpus_clean, control = list(tokenize = BigramTokenizer))

