genMajorMinorSameDiffHist <- function() {

  outCounts <- read.csv("../analysis/allTaskHistsAllData.csv");
  tmp = outCounts$samediff[1:17];
  samediffHist = tmp/sum(tmp);
  df = data.frame(samediffHist);

  library(ggplot2)
  
  ggplot(df, aes(x = seq_along(samediffHist), y = samediffHist)) +
    geom_col() +
    annotate("text", x = 4, y = 0.125, label = paste("N = ",format(getNumSubjsInHist("samediff","all"), big.mark = ","))) +
    scale_x_continuous(
      breaks = seq(1, 17, by = 4),
      labels = seq(0, 100, length.out = 5)
    ) +
  theme_minimal(base_size = 20) +
    theme(
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major.x = element_line(color = "grey80", linewidth = 0.4),
      panel.grid.major.y = element_line(color = "grey80", linewidth = 0.4),
      panel.grid.minor   = element_blank()
    )  + ylab("Proportion of subjects") +
    xlab("% correct in major-minor same-different (MMSD) task")
}