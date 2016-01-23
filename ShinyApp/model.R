load(file="./data/ngram1.RData")
load(file="./data/ngram2.RData")
load(file="./data/ngram3.RData")
load(file="./data/ngram4.RData")

predict_word <- function(userInputString) {
  
  str <- userInputString
  
  #split string and  only take the last three workds if length > 3
  str_split <- do.call('rbind', strsplit(as.character(str),' ',fixed=TRUE))
  
  if (length(str_split) == 2) {
    str_split <- cbind("<unk>", str_split)
  } else if (length(str_split) == 1) {
    str_split <- cbind("<unk>", "<unk>", str_split)
  }else if (length(str_split) > 3) {
    start <- length(str_split)-2
    end <- length(str_split)
    str_split <- str_split[start:end]
    str_split <- cbind(str_split[1], str_split[2], str_split[3])
    str <- paste(str_split[1], str_split[2], str_split[3])
  }
  
  #Maximum Likelihood Estimation with stupid backoff if 4-gram not found
  if (nrow(subset(df_four, fw == tolower(str_split[1]) & sw == tolower(str_split[2]) & tw == tolower(str_split[3]))) > 0) {
    results <- subset(df_four, fw == tolower(str_split[1]) & sw == tolower(str_split[2]) & tw == tolower(str_split[3]) )
    denom <- subset(df_three, three_ngram == tolower(str))$Freq
    results["prob"] <- round(results$Freq/denom,3)
    results <- head(results[order(-results$prob),],3)
    results <- subset(results, select= c(ftw,prob))
    colnames(results)<-c("Prediction", "Probability")
    
  } else if (nrow(subset(df_three,  fw == tolower(str_split[2]) & sw == tolower(str_split[3]))) > 0){
    denom <- subset(df_two, two_ngram == tolower(paste(str_split[2],str_split[3])))$Freq
    results <- subset(df_three,  fw == tolower(str_split[2]) & sw == tolower(str_split[3]))
    results["prob"] <- round(results$Freq/denom*0.4,3)
    
    denom <- subset(df_one, one_ngram == tolower(str_split[3]))$Freq
    results1 <- subset(df_two,  fw == tolower(str_split[3]))
    results1["prob"] <- round(results1$Freq/denom*0.4*0.4,3) 
    names(results1)[1]<-paste("three_ngram")
    colnames(results1)<-c("three_ngram", "Freq", "sw","tw", "prob")
    results1["fw"] <- "<unk>"
    
    results <- rbind(results, results1)
    rm(results1)
    results <- head(results[order(-results$prob),],3)
    results <- subset(results, select= c(tw, prob))
    colnames(results)<-c("Prediction", "Probability")
    
  } else if (nrow(subset(df_two,  fw == tolower(str_split[3]))) > 0) {
    results <- subset(df_two,  fw == tolower(str_split[3]))
    denom <- subset(df_one, one_ngram == tolower(str_split[3]))$Freq
    results["prob"] <- round(results$Freq/denom,3)
    results <- head(results[order(-results$prob),],3)
    results <- subset(results, select= c(sw, prob))
    colnames(results)<-c("Prediction", "Probability")
    
  } else results <- "the"
  
  return(results)
  
}

