getSameDiffMinus3v4AvgLowPerformers <- function() {
  
  outCounts <- read.csv("../analysis/allTasksIndividualSubjsAllData.csv")
  task3v4 <- outCounts$task3v4
  samediff <- outCounts$samediff
  whichOnes <- task3v4 <= 0.75 & task3v4 >= 0.25 & samediff <=0.75 & samediff >= 0.25
  diffs <- 100*(samediff[whichOnes]-task3v4[whichOnes])
  out <- t.test(diffs)
  return(out)
}