getYrsTableData <- function() {
  tmp <- read.csv("../analysis/dipTestPValsYrsLessons.csv",row.names=1)
  dips <- round(10000*tmp$dips)/10000
  pVals <- tmp$pVals
  tmpH <- read.csv("../analysis/yrsLessonsHists.csv")
  nStrings <- rep("",7)
  allHighs <- rep(0,7)
  for (k in 1:7){
    nStrings[k] <- format(sum(tmpH[,k]), big.mark = ",")
    allHighs[k] = round(10000*sum(tmpH[18:21,k])/sum(tmpH[,k]))/10000
  }
  
  levelString <- c(
    "Never had lessons",
    "< 1 year",
    "1 to 2 years",
    "2 to 4 years",
    "4 to 6 years",
    "6 to 10 years",
    "> 10 years"
  )
  df <- data.frame(levelString,nStrings,allHighs,dips,pVals)
  colnames(df) <- c(
    "Years lessons",
    "N",
    "85%-or-more",
    "dip",
    "dip-test-p"
  )
  return(df)
}