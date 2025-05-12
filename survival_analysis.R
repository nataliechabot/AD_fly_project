##Cox hazard model


##### Survival analysis ####

#### FOR TREATMENT ####

# load packages

library(pacman)

pacman::p_load(survival, survminer, dplyr)



# import data

#data <- read.csv("~/Year 3B-Dissertation/survival_QF2_1.5.25.csv")
data <- read.csv("~/Year 3B-Dissertation/survival_QUAS_1.5.25.csv")
data



# mean survival for each treatment

summary_lifespan <- data %>%
  
  group_by(Treatment) %>% # group data by treatment
  
  summarise(mean = mean(Age_days), # gives the mean
            
            SD = sd(Age_days), # standard deviation
            
            n = n()) # sample size



summary_lifespan



# make some survival curves


fit_data <- survfit(Surv(Age_days, Status) ~ Treatment, data = data)

fit_data

#   plot the model

levels(as.factor(data$Treatment))

survival <- ggsurvplot(fit_data, data = data,
                       
                       font.x = 22,
                       
                       font.y = 22,
                       
                       font.tickslab = 22,
                       
                      palette = c("#00CED1","#00008B"),
                     # palette = c("#00ff00","#2e8b57"),
                     # palette = c("#FF69B4","#cd0000"),
                       
                       xlim = c(0,65),
                       
                       xlab = "Age (days)",
                       
                      legend = "right", legend.title = "Treatment",
                      legend.labs = c("Isolated", "Social"))
                     
                     





survival



cox <- coxph(Surv(Age_days, Status) ~ Treatment,
             
             data = data)


cox


###FOR GENOTYPE ###

# load packages

library(pacman)

pacman::p_load(survival, survminer, dplyr)



# import data

#data <- read.csv("~/OneDrive - University of East Anglia/UEA PostDoc/See Hear Smell Project/Experiment 2 - Social Age Effects on Male Lifespan/1. DATA/survival.csv")
  
data <- read.csv("~/Year 3B-Dissertation/survival.1.5.25.csv")

data



# mean survival for each treatment

summary_lifespan <- data %>%
  
  group_by(Genotype) %>% # group data by treatment
  
  summarise(mean = mean(Age_days), # gives the mean
            
            SD = sd(Age_days), # standard deviation
            
            n = n()) # sample size



summary_lifespan



# make some survival curves



fit_data <- survfit(Surv(Age_days, Status) ~ Genotype, data = data)

fit_data

#   plot the model

survival <- ggsurvplot(fit_data, data = data,
                       
                       font.x = 22,
                       
                       font.y = 22,
                       
                       font.tickslab = 22,
                       
                    
                       
                       
                       xlab = "Age (days)",
                       
                       legend = "right", legend.title = "Genotype",
                       
                       legend.labs = c("QF2-control", "AB42-expressed", "QUAS-control"))



survival



cox <- coxph(Surv(Age_days, Status) ~ Genotype,
             
             data = data)



cox
