my_data <- read.csv("~/Year 3B-Dissertation/gna_stats.csv")
my_data


kruskal.test(Density ~ Genotype, data = my_data)


###When p-value < 0.001, there is very strong evidence to suggest a difference between at
#least one pair of groups but which pairs? To find out do pairwise Wilcoxon signed
#rank comparisons for each pair of groups. 

#Bonferroni adjustment keeps type 1 error down

#pairwise.wilcox.test(Weeks_Sterile,Genotype,p.adj='bonferroni',exact=F)

pairwise.wilcox.test(my_data$Week_1, my_data$Genotype,
                     p.adjust.method = "bonferroni")


#Mann Whitney U test

wilcox.test(Strength ~ Treatment, data = my_data)

