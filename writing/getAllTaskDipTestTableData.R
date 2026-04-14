getAllTaskDipTestTableData <- function() {
  
  outCounts <- read.csv("../analysis/allTaskHistsAllData.csv")
  pHigh <- rep(0,9)
  nStrings <- rep("",9)
  for (k in 1:8){
    pHigh[k] <- sum(outCounts[18:21,k+1])/sum(outCounts[,k+1])
    nStrings[k] <- format(sum(outCounts[,k+1]), big.mark = ",")
  }
  pHigh[9] <- sum(outCounts$samediff[15:17])/sum(outCounts$samediff[1:17])
  nStrings[9] <- format(sum(outCounts$samediff[1:17]), big.mark = ",")
  pHigh <- round(10000*pHigh)/10000
  
  tmp <- read.csv("../analysis/dipTestPValsAllTasksAllData.csv")
  dips <- round(10000*tmp$dips)/10000
  dips <- c(dips[2:9],dips[1])
  pVals <- c(tmp$pVals[2:9],tmp$pVals[1])
  
  
  taskName <- c("1v2","2v3","MMC (3v4)","4v5","5v6","8v9","9v10","10v11","MMSD")
  
  df <- data.frame(taskName,nStrings,pHigh,dips,pVals)
  
  colnames(df) <- c(
    "Task",
    "N",
    "85%-or-more",
    "dip",
    "dip-test-p"
  )
  return(df)
}