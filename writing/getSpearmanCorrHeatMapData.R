getSpearmanCorrHeatMapData <- function() {
  
  outCounts <- read.csv("../analysis/heatMapCounts.csv");

  tmp <- cbind(outCounts[, 5], outCounts[, 1:4], outCounts[, 6])
  heatMap = t(tmp);

  N = sum(heatMap);
  rank <- numeric();
  score <- numeric();
  for (x in 1:6) {
    for (y in 1:21) {
      rank = c(rank,rep(x,heatMap[x,y]))
      score = c(score,rep(y,heatMap[x,y]))
    }
  }
  correlation = cor(rank, score, method = "spearman")
  return(correlation)
}

