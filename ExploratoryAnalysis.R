#getting some info on the data files
blogs <- readLines("en_US.blogs.txt")
news <- readLines("en_US.news.txt")
twitter <- readLines("en_US.twitter.txt")

#size of each file
file.info("en_US.blogs.txt")$size / 1024^2
file.info("en_US.news.txt")$size / 1024^2
file.info("en_US.twitter.txt")$size / 1024^2

#length of each file
length(blogs)
length(news)
length(twitter)

stri_stats_latex(blogs)
stri_stats_latex(news)
stri_stats_latex(twitter)

#longest entry
max(nchar(blogs))
max(nchar(news))
max(nchar(twitter))

#removing the large character vectors
rm(blogs)
rm(news)
rm(twitter)

#Exploratory Analysis
corp1_wo_stopwords <- tokenize_data_rm_stopwords(sample_data1)


#creation of the document term matricies
dtm1 <- create_termMatrix(corp1) 
dtm1_wo_stopwords <- create_termMatrix(corp1_wo_stopwords) 

#wordcloud graphs
layout(matrix(c(1, 2, 3, 4), nrow=2),heights=c(2,2))
plot.new()
text(x=0.5, y=0.9, "Wordcloud with Stopwords")
plot.new()
text(x=0.5, y=0.9, "Wordcloud without Stopwords")
wordcloud(corp1, min.freq = 350, scale=c(5,0.5), random.order = FALSE, colors=brewer.pal(6, "Dark2"))    
wordcloud(corp1_wo_stopwords, min.freq = 150, scale=c(5,0.5), random.order = FALSE, colors=brewer.pal(6, "Paired")) 


gc()


#Find the morst frequent words in the Document Text Matrix
head(sort(colSums(as.matrix(dtm1)), decreasing=TRUE), 15)
termFreq <- sort(colSums(as.matrix(dtm1)), decreasing=TRUE) 
termFreq <-subset(termFreq, termFreq>=1250) 

#Find the morst frequent words in the Document Text Matrix - without Stopwords
head(sort(colSums(as.matrix(dtm1_wo_stopwords)), decreasing=TRUE), 15)
termFreq_wo_stopwrods <- sort(colSums(as.matrix(dtm1_wo_stopwords)), decreasing=TRUE) 
termFreq_wo_stopwrods <-subset(termFreq_wo_stopwrods, termFreq_wo_stopwrods>=531) 

termFreq
termFreq_wo_stopwrods

one_word_df <- data.frame(word=names(termFreq), freq=termFreq)   
one_word_wo_stopwords_df <- data.frame(word=names(termFreq_wo_stopwrods), freq=termFreq_wo_stopwrods)   

p <- ggplot(one_word_df, aes(reorder(word, freq), freq))    
p <- p + geom_bar(stat="identity", fill="lightgreen", colour="darkgreen")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p <- p + labs(title = "Top 20 Words with Stopwords")
p <- p + ylab("Frequency")  + xlab("Word")
p

q <- ggplot(one_word_wo_stopwords_df, aes(reorder(word, freq), freq))   
q <- q + geom_bar(stat="identity", fill="lightblue", colour="darkblue")      
q <- q + theme(axis.text.x=element_text(angle=45, hjust=1))   
q <- q + labs(title = "Top 20 Words without Stopwords")
q <- q + ylab("Frequency")  + xlab("Word")
q   

---------------------------------------------------------------------------------------------
  
  gc()

#Time to create Ngrams
df<-data.frame(text=unlist(sapply(corp1, `[`, "content")), stringsAsFactors=F)
df_wo_stopwords<-data.frame(text=unlist(sapply(corp1_wo_stopwords, `[`, "content")), stringsAsFactors=F)

#Creating 2 and 3-grams
one_ngram <- NGramTokenizer(df, Weka_control(min = 1, max = 1, delimiters = " \\r\\n\\t.,;:\"()?!"))
two_ngram <- NGramTokenizer(df, Weka_control(min = 2, max = 2, delimiters = " \\r\\n\\t.,;:\"()?!"))
three_ngram <- NGramTokenizer(df, Weka_control(min = 3, max = 3, delimiters = " \\r\\n\\t.,;:\"()?!"))

#Gathering the most frequently used ngrams
df_two <- as.data.frame(table(two_ngram))
df_two <- subset(arrange(df_two, desc(Freq)), Freq >= 340)
df_three <- as.data.frame(table(three_ngram))
df_three <- subset(arrange(df_three, desc(Freq)), Freq >= 46)

#plotting most frequenly used words
p <- ggplot(df_two, aes(reorder(two_ngram, Freq), Freq))    
p <- p + geom_bar(stat="identity", fill="pink", colour="red")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p <- p + labs(title = "Top 20 2-grams")
p <- p + ylab("Frequency")  + xlab("Word")
p

q <- ggplot(df_three, aes(reorder(three_ngram, Freq), Freq))   
q <- q + geom_bar(stat="identity", fill="white", colour="purple")      
q <- q + theme(axis.text.x=element_text(angle=45, hjust=1))   
q <- q + labs(title = "Top 20 3-grams")
q <- q + ylab("Frequency")  + xlab("Word")
q   

#Get the frequencies for each word
termFreq <- sort(colSums(as.matrix(dtm1)), decreasing=TRUE) 
one_word_freq <- data.frame(word=names(termFreq), freq=termFreq)   

#This function will assist us in getting the number of words needed 
#to get to the required percentage
get_num_words <- function(pct_needed) { 
  i = 1
  pct = 0
  while (pct <= pct_needed){
    pct = pct + (one_word_freq$freq[i]/sum(one_word_freq$freq) * 100)
    i = i + 1
  }
  return(i)
}

#create new dataframe with first row
df_perc_freq <- data.frame(get_num_words(10))
f <- 20

while (f<100) {
  df_perc_freq <- rbind(df_perc_freq, get_num_words(f))
  f <- f+ 10
}

df_perc_freq <- cbind(df_perc_freq, c(10,20,30,40,50,60,70,80,90))
colnames(df_perc_freq) <- c("numWords", "Pct")


q <- qplot(df_perc_freq$Pct,df_perc_freq$numWords, geom=c("line","point"))
q <- q <- q + labs(title = "Number of Unique Words Needed to Cover all Instances")
q <- q + ylab("Number of Words") + xlab("Percent") 
q <- q + scale_x_continuous(breaks=c(10,20,30,40,50,60,70,80,90))
q <- q + geom_text(aes(label=df_perc_freq$numWords), hjust=1, vjust=-1)
q