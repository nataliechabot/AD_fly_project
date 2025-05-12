## Test for normality ##
  
  
  data <- read.csv("~/Year 3B-Dissertation/gna_stats.csv")
  
  data
  
#Shapiro Wilk test (good for small sample sizes) is a test of normality!
  
  library(dplyr)
  
# Apply Shapiro-Wilk test for each group
  
 # df <- read.csv("~/Year 3B-Dissertation/gna_stats.csv" )
  
  df <- data
  df %>%
    group_by(Treatment, Genotype) %>%
    summarise(
      p_value = shapiro.test(Density)$p.value,
      W_statistic = shapiro.test(Density)$statistic
    )
#QQ plots
 # save model
  
  mod <- aov(Time ~ Genotype * Treatment,
             data = data
  )
  
  # method 1
  plot(mod, which = 2)
  
  #method 2
  library(car)
  #test residuals
  shapiro.test(residuals(mod))
  
  qqPlot(mod$residuals,
         id = FALSE # remove point identification
  )
  
  
  