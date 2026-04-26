
# Set working directory
setwd("CIBiG_2025/stage_yam/R_analysis")

# Create main output directories
output_dir  <- "Mash_results/comparison"
dir.create(output_dir, showWarnings = FALSE)

# Load libraries
library(ggplot2)
library(vegan)
library(reshape2)

# Import Mash distances
mash <- read.table("Input_dir/comparison/mash_dist_clean.tab", header = FALSE)
colnames(mash) <- c("Query","Ref", "mash_dist", "pvalue", "shared_hashes")
mash_mat <- acast(mash, Query ~ Ref, value.var = "mash_dist") # Cast to matrix

# Import SNP-based Jaccard distance
jaccard_mat <- read.csv("Input_dir/comparison/jaccard_distance_matrix.csv", 
                             row.names = 1, check.names = FALSE)
rownames(jaccard_mat) <- colnames(jaccard_mat) <- row.names(mash_mat)

# Convert distance matrices to matrices
mash_mat <- as.matrix(mash_dist)
snp_mat  <- as.matrix(snp_dist)

# Keep only upper triangle (avoid duplicates)
upper_idx <- upper.tri(mash_mat)

df <- data.frame(
  Mash = mash_mat[upper_idx],
  SNP  = jaccard_mat[upper_idx]
)

# Correlation analyses
pearson_cor  <- cor(df$Mash, df$SNP, method = "pearson")
spearman_cor <- cor(df$Mash, df$SNP, method = "spearman")

# Mantel test
mash_dist      <- as.dist(mash_mat)
jaccard_dist      <- as.dist(jaccard_mat)
mantel_res <- mantel(mash_dist, jaccard_dist, method = "pearson", permutations = 999)

# Format labels
label_text <- paste0(
  "Pearson r = ", round(pearson_cor, 3), "\n",
  "Spearman ρ = ", round(spearman_cor, 3), "\n",
  "Mantel r = ", round(mantel_res$statistic, 3), "\n",
  "p = ", signif(mantel_res$signif, 3)
)

label_text1 <- paste0(
  "Pearson r = ", round(pearson_cor, 3), "\n",
  "Mantel r = ", round(mantel_res$statistic, 3), "\n",
  "p = ", signif(mantel_res$signif, 3)
)

# Plot
p <- ggplot(df, aes(x = Mash, y = SNP)) +
  geom_point(color = "steelblue", alpha = 0.7, size = 1) +
  geom_smooth(method = "lm", se = TRUE, color = "red", fill = "grey80") +
  annotate(
    "text",
    x = max(df$Mash)*0.8,
    y = max(df$SNP)*0.6,
    label = label_text1,
    hjust = 0,
    size = 5
  ) +
  labs(
    title = "Correlation between Mash Distance and SNP-based Distance",
    x = "Mash Distance",
    y = "SNP-based Distance"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    panel.grid.minor = element_blank()
  )

# Show plot
print(p)

# Export (Save plots as PDF or PNG)
# ---------------------------------
ggsave(paste0(output_dir, "/Mash_vs_SNP_correlation_a.pdf"),
             plot = p, width = 10, height = 6, dpi = 300)

ggsave(paste0(output_dir, "/Mash_vs_SNP_correlation_a.png"), 
       plot = p, width = 8, height = 6, dpi = 300)

# All Done
