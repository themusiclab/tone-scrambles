getNativeLanguageTableData <- function() {
  
  tmp <- read.csv("../analysis/NativeLang20Histograms.csv")
  nStrings <- rep("", 20)
  pHighs <- rep(0, 20)
  for (k in 1:20){
    pHighs[k] <- round(10000*sum(tmp[18:21,k])/sum(tmp[,k]))/10000
    nStrings[k] <- format(sum(tmp[,k]), big.mark = ",")
  }
  tmp <- read.csv("../analysis/dataFor20NativeLangTable.csv")
  pStrings <- rep("", 20)
  for (k in 1:20){
    if (tmp$allPs[k]==0){
      pStrings[k] = "<0.0001"
    } else if (tmp$allPs[k]==1) {
      pStrings[k] = ">0.9999"
    } else {
      pStrings[k] = sprintf("%0.4f",tmp$allPs[k])
    }
  }
  
  allDips <- round(10000*tmp$allDipsFromData)/10000
  allNames <- tmp$allNames
  df <- data.frame(allNames,nStrings,pHighs,allDips,pStrings)
  
  colnames(df) <- c(
    "Native language",
    "N",
    "85%-or-more",
    "dip",
    "dip-test-p"
  )
  return(df)
}

