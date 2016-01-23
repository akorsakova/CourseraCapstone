#Time to create Ngrams
df<-data.frame(text=unlist(sapply(corp1, `[`, "content")), stringsAsFactors=F)

one_ngram <- NGramTokenizer(df, Weka_control(min = 1, max = 1, delimiters = " \\r\\n\\t.,;:\"()?!"))
two_ngram <- NGramTokenizer(df, Weka_control(min = 2, max = 2, delimiters = " \\r\\n\\t.,;:\"()?!"))
three_ngram <- NGramTokenizer(df, Weka_control(min = 3, max = 3, delimiters = " \\r\\n\\t.,;:\"()?!"))
four_ngram <- NGramTokenizer(df, Weka_control(min = 4, max = 4, delimiters = " \\r\\n\\t.,;:\"()?!"))

#creating frequency tables
df_one <- as.data.frame(table(one_ngram))
df_two <- as.data.frame(table(two_ngram))
df_three <- as.data.frame(table(three_ngram))
df_four <- as.data.frame(table(four_ngram))

#pruning the ngrams for counts greater than or equal to three, 2 four 4-grams as the drop in size is drastic
#df_one <- subset(arrange(df_one, desc(Freq)), Freq >= 3) 
#df_two <- subset(arrange(df_two, desc(Freq)), Freq >= 3)
#df_three <- subset(arrange(df_three, desc(Freq)), Freq >= 3)
#df_four <- subset(arrange(df_four, desc(Freq)), Freq >= 2)

#spilling up ngrams and adding individual words to the data frame
temp1 <- data.frame(do.call('rbind', strsplit(as.character(df_two$two_ngram),' ',fixed=TRUE)))
df_two["fw"] <- temp1$X1
df_two["sw"] <- temp1$X2

temp1 <- data.frame(do.call('rbind', strsplit(as.character(df_three$three_ngram),' ',fixed=TRUE)))
df_three["fw"] <- temp1$X1
df_three["sw"] <- temp1$X2
df_three["tw"] <- temp1$X3

temp1 <- data.frame(do.call('rbind', strsplit(as.character(df_four$four_ngram),' ',fixed=TRUE)))
df_four["fw"] <- temp1$X1
df_four["sw"] <- temp1$X2
df_four["tw"] <- temp1$X3
df_four["ftw"] <- temp1$X4

rm(temp1)
gc()

save(df_four, file = 'ngram4.RData')
save(df_three, file = 'ngram3.RData')
save(df_two, file = 'ngram2.RData')
save(df_one, file = 'ngram1.RData')

