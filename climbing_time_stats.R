#upload data
my_data <- read.csv("~/Year 3B-Dissertation/climbing_time_all_NA.csv")

my_data

#reshape to long-format

library(tidyr)
library(dplyr)

# Reshape wide to long
long_data <- my_data %>%
  pivot_longer(cols = starts_with("Week"),
               names_to = "Week",
               values_to = "Climb")

# Check result
head(long_data)
install.packages("rstatix")
library(rstatix)
#ANOVA TEST
res.aov <- anova_test(
    data = long_data, dv = Climbed, wid =Vial.ID,
    between = c(Genotype, Treatment), within = Week)


#Mixed model

install.packages("lmerTest")
library(lmerTest)

library(lme4)

model <- lmer(Climbed ~ Genotype * Treatment * Week + 
                 (1 | Vial.ID), 
               data = long_data)

summary(model)

anova(model)

model_2 <- lmer(Climbed ~ Genotype * Treatment * Week + 
                (1 | Vial.ID), 
              data = long_data)
summary(model_2)
anova(model_2)


install.packages("emmeans")
library(emmeans)
emm_genotype <- emmeans(model_2, ~Genotype)
emm_genotype

#Residual
res <- residuals(model_2)
hist(res)
qqnorm(res)

qqline(res)
shapiro.test(res)

fit <- fitted(model_2)
plot(fit,res)

#aim bootstrap - can relax normality
install.packages("afex")
library(afex)
model_afex <- mixed(Climbed ~ Week * Genotype * Treatment + (1 | vial.id), data = long_data, method = "KR") # Kenward-Roger
summary(model_afex)

# Or using parametric bootstrap (can be time-consuming)
model_afex_pb <- mixed(Climbed ~ Week * Genotype * Treatment + (1 | Vial.ID), data = long_data, method = "PB", args_test = list(nboot = 1000))
summary(model_afex_pb)

