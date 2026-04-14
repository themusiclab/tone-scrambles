getCountryTableData <- function() {
  
  tmp <- read.csv("../analysis/country20Histograms.csv")
  nStrings <- rep("", 20)
  pHighs <- rep(0, 20)
  for (k in 1:20){
    pHighs[k] <- round(10000*sum(tmp[18:21,k])/sum(tmp[,k]))/10000
    nStrings[k] <- format(sum(tmp[,k]), big.mark = ",")
  }
  tmp <- read.csv("../analysis/dataFor20CountryTable.csv")
  countryNames <- tmp$allNames;
  dips <- round(10000*tmp$allDipsFromData)/10000
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
  
  df <- data.frame(countryNames,nStrings,pHighs,dips,pStrings)
  colnames(df) <- c(
    "Country",
    "N",
    "85%-or-more",
    "dip",
    "dip-test-p"
  )
  return(df)
}