getOneDipTestValue <- function(row) {
  
  # Possible rows are
  # 1. Major-minor same-diff.
  # 2. Major-minor categ.
  # 3. 1v2
  # 4. 2v3
  # 5. 4v5
  # 6. 5v6
  # 7. 8v9
  # 8. 9v10
  # 9. 10v11
  
  df <- read.csv("../analysis/dipTestPValsAllTasksAllData.csv");
  
  return(df$pVals[row])
}