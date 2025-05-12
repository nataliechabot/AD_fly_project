#Do they climb?
#GLMM with Logistic Link Function

#upload data
did_climb_1.6_data <- read.csv("~/Year 3B-Dissertation/Wk1to6_controls.csv")

did_climb_1.6_data

#reshape to long-format

library(tidyr)
library(dplyr)

# Reshape wide to long
long_data <- did_climb_1.6_data %>%
  pivot_longer(cols = starts_with("Week"),
               names_to = "Week",
               values_to = "Climbed")

# Check result
head(long_data)




#GLMM -  did the fly climb (1/0)?
# Fixed effects: genotype, treatment, week, and their interactions
# Random effect: individual fly ID

library(lme4)


model <- glmer(Climbed ~ Genotype * Treatment * Week + 
                 (Week | Vial_ID), 
               family = binomial, 
               data = long_data)
summary(model)
# simplify

library(lme4)

model_simple <- glmer(Climbed ~ Genotype + Treatment + Week + 
                        (1 | Vial_ID), 
                      family = binomial, 
                      data = long_data)

summary(model_simple)

----------------------------
## I used this one for weeks 1-2 
#NB USE GLMER WHEN VIAL ID USED!!!!! ##
-----------------
library(lme4)
model_interact <- glmer(Climbed ~ Genotype * Treatment + Week + 
                          (1 | Vial_ID), 
                        family = binomial, 
                        data = long_data)

summary(model_interact)
#odds ratio
exp(fixef(model_simple))
exp(fixef(model_interact))


-------------------
# weeks 1-6 same thing -but week as factor!
library(lme4)

table(long_data$Week)
str(long_data$Week)

long_data$Week <- factor(long_data$Week)




model_week_factor <- glmer(
  Climbed ~ Genotype * Treatment + Week + (1 | Vial_ID),
  data = long_data,
  family = binomial
)

summary(model_week_factor)
exp(fixef(model_week_factor))


#GLM logistic regression model
#model_glm <- glm(Climbed ~ Genotype * Treatment + Week,
 #                family = binomial,
  #               data = long_data)
#summary(model_glm)


AIC(model_glm)

table(long_data$Week)
