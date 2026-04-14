genHeatMap <- function() {
  outCounts <- read.csv("../analysis/heatMapCounts.csv");

  tmp <- cbind(outCounts[, 5], outCounts[, 1:4], outCounts[, 6])
  heatMap = t(tmp);

  colormapBlueYellow <- colorRampPalette(c("navy", "red", "gold"))
  pal <- colormapBlueYellow(231)

  y = 1:21;
  x = c(0,1,2,4,6,10,11);
  z = heatMap;
  image(
    x,
    y,
    z,
    col = pal,
    xlab = "Years of music lessons",
    ylab = "Major-minor categorization (MMC) task %-correct",
    axes = FALSE
  )
  
  axis(
    side = 1,
    at = c(0, 1, 2, 4, 6, 10),
    labels = c(0, 1, 2, 4, 6, 10)
  )

  axis(
    side = 2,
    at = seq(1, 21, by = 2),
    labels = 10*(0:10),
    las = 1
  )

  box()  # frame around the plot
  abline(v = c(0, 1, 2, 4, 6, 10), col = gray(0.5))
  abline(h = (2:21) - 0.5, col = gray(0.5))
  # heatMapCounts <- heatMap[, c(1, 2, 3, 5, 7, 11)]
  heatMapCounts = t(heatMap)
  
  xCounts <- matrix(
    rep(c(0.5, 1.5, 3, 5, 8, 10.5), each = nrow(heatMapCounts)),
    nrow = nrow(heatMapCounts),
    ncol = 6
  )

  yCounts <- matrix(
    rep(1:nrow(heatMapCounts), times = 6),
    nrow = nrow(heatMapCounts),
    ncol = 6
  )

  max_val <- max(heatMapCounts)
  text_col_num <- 1 - round(heatMapCounts / max_val)

  text_col_num[text_col_num < 0] <- 0
  text_col_num[text_col_num > 1] <- 1

  text_col <- gray(text_col_num)

  text(
    x = as.vector(xCounts),
    y = as.vector(yCounts),
    labels = as.character(as.vector(heatMapCounts)),
    col = as.vector(text_col),
    cex = 1.0  # roughly fontsize ~ 16
  )
}

