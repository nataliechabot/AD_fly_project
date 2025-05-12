#climbing yes/no

# Create the observed data matrix
# Create the 2x2 contingency tables for each pair
qf2_vs_quas <- matrix(c(23, 7, 22, 8), nrow = 2, byrow = TRUE,
                      dimnames = list(Group = c("QF2", "QUAS"), Response = c("Yes", "No")))

qf2_vs_qq <- matrix(c(23, 7, 11, 19), nrow = 2, byrow = TRUE,
                    dimnames = list(Group = c("QF2", "QQ"), Response = c("Yes", "No")))

quas_vs_qq <- matrix(c(22, 8, 11, 19), nrow = 2, byrow = TRUE,
                     dimnames = list(Group = c("QUAS", "QQ"), Response = c("Yes", "No")))

# Run Fisher's exact test for each pair
test1 <- fisher.test(qf2_vs_quas)
test2 <- fisher.test(qf2_vs_qq)
test3 <- fisher.test(quas_vs_qq)

# Collect the raw p-values
raw_pvalues <- c(test1$p.value, test2$p.value, test3$p.value)

# Apply Bonferroni correction
adjusted_pvalues <- p.adjust(raw_pvalues, method = "bonferroni")

# Print results
cat("Pairwise Fisher's Exact Test Results (with Bonferroni adjustment):\n\n")
cat("1. QF2 vs QUAS:   p =", round(raw_pvalues[1], 4), " | adjusted p =", round(adjusted_pvalues[1], 4), "\n")
cat("2. QF2 vs QQ:     p =", round(raw_pvalues[2], 4), " | adjusted p =", round(adjusted_pvalues[2], 4), "\n")
cat("3. QUAS vs QQ:    p =", round(raw_pvalues[3], 4), " | adjusted p =", round(adjusted_pvalues[3], 4), "\n")
