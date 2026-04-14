genMajorMinorCategorizationHist <- function() {

  outCounts <- read.csv("../analysis/allTaskHistsAllData.csv");

  tmp <- outCounts["task3v4"];
  df = tmp/sum(tmp);

  library(ggplot2)
  
  ggplot(df, aes(x = seq_along(task3v4), y = task3v4)) +
    geom_col() +
    annotate("text", x = 4, y = 0.1, label = paste("N = ",format(getNumSubjsInHist("3v4","all"), big.mark = ","))) +
    scale_x_continuous(
      breaks = seq(1, 21, by = 2),
      labels = seq(0, 100, length.out = 11)
    ) +
  theme_minimal(base_size = 20) +
    theme(
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major.x = element_line(color = "grey80", linewidth = 0.4),
      panel.grid.major.y = element_line(color = "grey80", linewidth = 0.4),
      panel.grid.minor   = element_blank()
    )+ ylab("Proportion of subjects") +
    xlab("% correct in major-minor categorization (MMC) task")
}