genNoLessonsHist <- function() {

  outCounts <- read.csv("../analysis/noLessonsCounts.csv")

  tmp <- outCounts["noLessonsCounts"];
  df = tmp/sum(tmp);
  N = sum(tmp)

  library(ggplot2)
  
  ggplot(df, aes(x = seq_along(noLessonsCounts), y = noLessonsCounts)) +
    geom_col() +
    annotate("text", x = 4, y = 0.125, label = paste("N = ",format(N, big.mark = ","))) +
    scale_x_continuous(
      breaks = seq(1, 21, by = 2),
      labels = seq(0, 100, length.out = 11)
    ) +
  theme_minimal(base_size = 16) +
    theme(
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      panel.grid.major.x = element_line(color = "grey80", linewidth = 0.4),
      panel.grid.major.y = element_line(color = "grey80", linewidth = 0.4),
      panel.grid.minor   = element_blank()
    )+ ylab("Proportion of subjects") +
    xlab("% correct in major-minor categorization (MMC) task")
}