getOneDipTestValueYearsLessons <- function(rowName) {
  
  # Possible values of rowName are
  # "noLessons", "0-1yr", "1-2yrs", "2-4yrs", "4-6yrs", "6-10yrs", ">10yrs"

 df <- read.csv("../analysis/dipTestPValsYrsLessons.csv",row.names=1);
 value <- df[rowName,"pVals"]
 return(value)
}