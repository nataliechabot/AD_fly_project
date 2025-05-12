# Data for each experimental group (Isolated vs Social)
# Format: c(Yes, No)
# For QF2-control Isolated vs Social
isolated_qf2 <- c(13, 2)  # Yes, No for Isolated
social_qf2 <- c(10, 5)    # Yes, No for Social

# For QUAS-control Isolated vs Social
isolated_quas <- c(9, 6)  # Yes, No for Isolated
social_quas <- c(13, 2)   # Yes, No for Social

# For Aβ42 Isolated vs Social
isolated_ab42 <- c(9, 6)  # Yes, No for Isolated
social_ab42 <- c(2, 13)   # Yes, No for Social

# Function to perform Fisher's Exact Test
perform_fisher_test <- function(isolated, social) {
  table <- matrix(c(isolated, social), nrow = 2, byrow = TRUE)
  result <- fisher.test(table)
  return(result$p.value)
}

# Perform Fisher's Exact Test for each group
p_value_qf2 <- perform_fisher_test(isolated_qf2, social_qf2)
p_value_quas <- perform_fisher_test(isolated_quas, social_quas)
p_value_ab42 <- perform_fisher_test(isolated_ab42, social_ab42)

# Print the results
cat("Fisher's Exact Test p-value for QF2-control:", p_value_qf2, "\n")
cat("Fisher's Exact Test p-value for QUAS-control:", p_value_quas, "\n")
cat("Fisher's Exact Test p-value for Aβ42:", p_value_ab42, "\n")
