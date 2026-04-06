# ===============================================
#       Distance comparison: Mash vs SNPs
# ===============================================

# Set working directory
setwd("/media/joel/Lab/CIBiG_2025/stage_yam/R_analysis")

# Create main output directories
output_dir  <- "Mash_results/comparison"
dir.create(output_dir, showWarnings = FALSE)

library(reshape2)
library(vegan)
library(dendextend)    # tree comparison / tanglegram
library(ggplot2)       # optional plots


# Read sample IDs
sample_id <- read.table("Input_dir/comparison/sample_id.txt", stringsAsFactors = FALSE)

# Read distance matrices
pairwise_mat <- as.matrix(read.table("Input_dir/comparison/pairwise_dist.dist"))
allele_mat   <- as.matrix(read.table("Input_dir/comparison/allele_dist.mdist"))
ibs_mat      <- as.matrix(read.table("Input_dir/comparison/ibs_dist.mibs"))


# Assign names
rownames(pairwise_mat) <- colnames(pairwise_mat) <- sample_id$V1
rownames(allele_mat)   <- colnames(allele_mat)   <- sample_id$V1
rownames(ibs_mat)      <- colnames(ibs_mat)      <- sample_id$V1


# Import Mash distances
mash <- read.table("Input_dir/comparison/mash_dist_clean.tab", header = FALSE)
colnames(mash) <- c("Query","Ref", "mash_dist", "pvalue", "shared_hashes")
mash_mat <- acast(mash, Query ~ Ref, value.var = "mash_dist") # Cast to matrix

# Common set of individuals
common <- Reduce(intersect, list(
  rownames(mash_mat),
  rownames(allele_mat),
  rownames(pairwise_mat),
  rownames(ibs_mat)
))

# Subset all matrices consistently
mash_mat       <- mash_mat[common, common]
allele_mat    <- allele_mat[common, common]
pairwise_mat  <- pairwise_mat[common, common]
ibs_mat       <- ibs_mat[common, common]


# Convert to dist objects
mash_dist      <- as.dist(mash_mat)
dist_allele    <- as.dist(allele_mat)
dist_pairwise  <- as.dist(pairwise_mat)
dist_ibs       <- as.dist(ibs_mat)


# Mantel tests
mantel_result1 <- mantel(mash_dist, dist_allele, method = "pearson", permutations = 999)
mantel_result2 <- mantel(mash_dist, dist_pairwise, method = "pearson", permutations = 999)
mantel_result3 <- mantel(mash_dist, dist_ibs, method = "pearson", permutations = 999)


print(mantel_result1)
print(mantel_result2)
print(mantel_result3)


mantel_result1b <- mantel(mash_dist, dist_allele, 
                         method = "spearman", permutations = 999)
mantel_result2b <- mantel(mash_dist, dist_pairwise, 
                         method = "spearman", permutations = 999)
mantel_result3b <- mantel(mash_dist, dist_ibs, 
                         method = "spearman", permutations = 999)

print(mantel_result1b)
print(mantel_result2b)
print(mantel_result3b)

