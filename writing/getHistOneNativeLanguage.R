getHistOneNativeLanguage <- function(langName) {
  df <- read.csv("../analysis/nativeLangPlusTask3v4.csv")
  outHist <- rep(0, 21)
  p = (0:20)/20
  for (k in 1:21){
    whichOnes <- df$nativeLang==langName & df$task3v4==p[k]
    outHist[k]=sum(whichOnes)
  }
  outHist <- outHist/sum(outHist)
  return(outHist)
}