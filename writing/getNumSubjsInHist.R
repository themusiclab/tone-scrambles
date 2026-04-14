getNumSubjsInHist <- function(task,dataSet,rows=NaN) {

  # possible tasks are "samediff", "1v2", "2v3", "3v4", "4v5", "5v6", "8v9", "9v10", "10v11"
  # possible data sets are "new", "orig", "all"
  # rows defaults to the total number of possible values for the selected task.
  
  # Read the CSV
  if (dataSet == "all") {
    df <- read.csv("../analysis/allTaskHistsAllData.csv")
  } else if (dataSet == "new") {
    df <- read.csv("../analysis/allTaskHistsNew.csv")
  } else {
    df <- read.csv("../analysis/allTaskHistsOrig.csv")
  }
  if (task == "samediff") {
    taskName = task;
  } else {
    taskName = paste("task",task,sep = "");
  }
  
  if (any(is.nan(rows))) {
    N = sum(df[[taskName]],na.rm = TRUE)
  } else {
    vec = df[[taskName]]
    N = sum(vec[rows],na.rm = TRUE)
  }
  return(N)
}