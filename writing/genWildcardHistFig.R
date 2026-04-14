genWildcardHistFig <- function() {

  outCounts <- read.csv("../analysis/allTaskHistsAllData.csv");

  tmp <- outCounts[["task1v2"]];
  v12 = tmp/sum(tmp);
  tmp <- outCounts[["task2v3"]];
  v23 = tmp/sum(tmp);
  tmp <- outCounts[["task4v5"]];
  v45 = tmp/sum(tmp);
  tmp <- outCounts[["task5v6"]];
  v56 = tmp/sum(tmp);
  tmp <- outCounts[["task8v9"]];
  v89 = tmp/sum(tmp);
  tmp <- outCounts[["task9v10"]];
  v910 = tmp/sum(tmp);
  tmp <- outCounts[["task10v11"]];
  v1011 = tmp/sum(tmp);

  probs <- list(
    v12,v23,v45,v56,v89,v910,v1011
  )
  library(ggplot2)
  
  df <- do.call(
    rbind,
    lapply(seq_along(probs), function(i) {
      data.frame(
        value = 5*(0:20),
        prob  = probs[[i]],
        dist  = factor(i)
      )
    })
  )
  
  labels <- c(
    paste("1v2-task: N = ",format(getNumSubjsInHist("1v2","all"), big.mark = ",")), 
    paste("2v3-task: N = ",format(getNumSubjsInHist("2v3","all"), big.mark = ",")), 
    paste("4v5-task: N = ",format(getNumSubjsInHist("4v5","all"), big.mark = ",")),
    paste("5v6-task: N = ",format(getNumSubjsInHist("5v6","all"), big.mark = ",")),
    paste("8v9-task: N = ",format(getNumSubjsInHist("8v9","all"), big.mark = ",")),
    paste("9v10-task: N = ",format(getNumSubjsInHist("9v10","all"), big.mark = ",")),
    paste("10v11-task: N = ",format(getNumSubjsInHist("10v11","all"), big.mark = ","))
  )
  df$dist <- factor(df$dist, labels = labels)
  
  ggplot(df, aes(x = value, y = prob)) +
    geom_col() +
    facet_wrap(~ dist, ncol = 2) +
    labs(
      x = "% correct",
      y = "Proportion of subjects",
      title = "Wildcard task distributions of %-correct"
    ) +
    theme_minimal(base_size = 18)
}