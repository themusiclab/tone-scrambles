genLanguageClassFig <- function() {
  
  outCounts <- read.csv("../analysis/languageClassHists.csv")

  tonalCounts <- outCounts[["tonal"]]
  tonal <- tonalCounts/sum(tonalCounts)
  pitchAccentedCounts <- outCounts[["pitch.accented"]]
  pitchAccented <- pitchAccentedCounts/sum(pitchAccentedCounts)
  otherCounts <- outCounts[["other"]]
  other <- otherCounts/sum(otherCounts)

  probs <- list(
    tonal,pitchAccented,other
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
  
  highP <- rep("",3);
  highP[1] <- sprintf(" %0.4f",sum(tonalCounts[18:21])/sum(tonalCounts));
  highP[2] <- sprintf(" %0.4f",sum(pitchAccentedCounts[18:21])/sum(pitchAccentedCounts));
  highP[3] <- sprintf(" %0.4f",sum(otherCounts[18:21])/sum(otherCounts));
  labels <- c(
    paste("tonal: N =",format(sum(tonalCounts), big.mark = ","),"\n85%-or-more =",highP[1]), 
    paste("pitch-accented: N =",format(sum(pitchAccentedCounts), big.mark = ","),"\n85%-or-more =",highP[2]), 
    paste("other: N =",format(sum(otherCounts), big.mark = ","),"\n85%-or-more =",highP[3])
  )
  df$dist <- factor(df$dist, labels = labels)
  
  ggplot(df, aes(x = value, y = prob)) +
    geom_col() +
    facet_wrap(~ dist, ncol = 2) +
    labs(
      x = "% correct in major-minor categorization (MMC) task",
      y = "Proportion of subjects",
      title = "Distributions of MMC-task %-correct for different language classes"
    ) +
    theme_minimal(base_size = 18)
}