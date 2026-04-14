getHistMean <- function(task) {

  # possible tasks are "samediff", "1v2", "2v3", "3v4", "4v5", "5v6", "8v9", "9v10", "10v11"
  # possible data sets are "new", "orig", "all"
  # rows defaults to the total number of possible values for the selected task.
  
  df <- read.csv("../analysis/allTaskHistsAllData.csv")
  
  if (task == "samediff") {
    taskName = task;
  } else {
    taskName = paste("task",task,sep = "");
  }
  
  vec <- df[[taskName]]
  if (taskName == "samediff") {
    N = 16
  } else {
    N = 20
  }
  
  nCorr <- 0:N
  vec = vec[1:(N+1)]
  
  p <- vec/sum(vec)
  meanNumCorrect = sum(p*nCorr)
  meanPropCorrect = meanNumCorrect/N
  return(meanPropCorrect)
}