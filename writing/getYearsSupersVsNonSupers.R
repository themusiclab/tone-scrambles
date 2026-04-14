getYearsSupersVsNonSupers <- function() {
 
  outCounts <- read.csv("../analysis/heatMapCounts.csv");

  tmp <- cbind(outCounts[, 5], outCounts[, 1:4], outCounts[, 6])
  heatMap <- t(tmp);
  y <- c(0.5,1.5,3,5,8,11)
  pSuper <- colSums(tmp[20:21, ])
  nSupers <- sum(pSuper)
  pSuper <- pSuper/nSupers
  pNonSuper <- colSums(tmp[1:14, ])
  nNonSupers <- sum(pNonSuper)
  pNonSuper <- pNonSuper/nNonSupers
  meanSuper <- sum(y*pSuper)
  meanNonSuper <- sum(y*pNonSuper)
  nSupersWithMoreThan10Years <- sum(tmp[20:21, 6])
  out <- data.frame(meanSuper,nSupers,meanNonSuper,nNonSupers,nSupersWithMoreThan10Years)
}

