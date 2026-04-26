# load labraries
library(data.table)
library(reshape2)
library(vegan)

cat("\n========== Begining ==========\n")

# Load data
cat("Load genotype matrix ...\n")
geno <- fread("Calling_ALL_Rotundata_Allc05_reordered_geno.raw", header=TRUE, data.table=FALSE)

# Convert to binary (presence/absence)
## Skip the first 6 columns (metadata from PLINK .raw files) and Keeps only genotype columns
cat("Convert to binary ...\n")
geno_bin <- (geno[,7:ncol(geno)] > 0) * 1


# Compute Jaccard distance matrix using Pairwide deletion
cat("Compute Jaccard distance ...\n")
dist_jaccard <- vegdist(geno_bin, method="jaccard", binary = T, na.rm = TRUE)

# Save Jaccard distances
cat("Save Jaccard distance ...\n")
write.csv(dist_jaccard, file = file.path("jaccard_dist.csv"), row.names = TRUE)



# Convert to matrix and save
dist_jaccard_mat <- as.matrix(dist_jaccard)
write.csv(dist_jaccard_mat, "jaccard_distance_matrix.csv", row.names = TRUE)


# Import Mash distances
cat("Convert mash to mat and dist ...\n")
mash <- read.table("mash_dist_clean.tab", header = FALSE)
colnames(mash) <- c("Query","Ref", "mash_dist", "pvalue", "shared_hashes")
mash_mat <- acast(mash, Query ~ Ref, value.var = "mash_dist") # Casts long table into a matrix

# Convert to dist objects
mash_dist <- as.dist(mash_mat)


# Mantel tests
cat("Mantel test ...\n")
mantel_result_1 <- mantel(mash_dist, dist_jaccard, method = "pearson", permutations = 999)
mantel_result_2 <- mantel(mash_dist, dist_jaccard, method = "spearman", permutations = 999)


cat("===== Result_1 =======\n")
print(mantel_result_1)
cat("===== Result_2 =======\n")
print(mantel_result_2)


cat("=========  Missing data ===========\n")
# SNP missing data
#  summary
out <- capture.output(table(is.na(geno_bin)))
writeLines(out, "missing_summary.txt")

# List all

cat("===== Missind data Summary =====\n")
res <- list(
  total_missing = sum(is.na(geno_bin)),
  pct_missing = mean(is.na(geno_bin)) * 100,
  missing_per_ind = rowSums(is.na(geno_bin)),
  pct_missing_per_ind = rowMeans(is.na(geno_bin)) * 100,
  missing_per_snp = colSums(is.na(geno_bin)),
  pct_missing_per_snp = colMeans(is.na(geno_bin)) * 100
)

print(res)


cat ("========== Done ==========")











