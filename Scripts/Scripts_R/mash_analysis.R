# ==========================================
#             Mash distance analysis
# ==========================================

# Load packages
library(ape)      # Phylogenetics, evolutionary analysis, and distance-based trees
library(ggplot2)	# Data visualization, customizable scientific plots
library(ggrepel)	# Prevents overlapping labels in ggplot2
library(ggtree)		# Phylogenetic tree visualization built on ggplot2
library(pheatmap)	# Create clustered heatmaps
library(dplyr)		# Data manipulation
library(reshape2)	# Transform data between wide and long format
library(readxl)		# Read Excel files (.xlsx)
library(RColorBrewer)	# Scientific color palettes

# Set working directory
setwd("/media/joel/Lab/CIBiG_2025/stage_yam/R_analysis")

# Create main output directories
output_dir  <- "Mash_results/k21s1000"
dir.create(output_dir, showWarnings = FALSE)

# 1. Load Mash distance matrix
mash <- read.table("Input_dir/distances_mash/k21s1000/mash_dist_clean.tab", 
                   header=FALSE)
colnames(mash) <- c("Query","Ref","Distance","Pvalue","SharedHashes")

## Export
write.csv(mash,
          file = file.path(output_dir, "dist.csv"), row.names = FALSE)

## Take distance column
distances <- mash$Distance
png(paste0(output_dir,"/dist.png"), width=800, height=600)
hist(distances,
     breaks=50,
     col="springgreen2",
     border="plum",
     main="Distribution of Mash Distances",
     xlab="Mash Distance",
     ylab="Frequency")
dev.off()

## Casts long table into a matrix
mash_mat <- acast(mash, Query ~ Ref, value.var="Distance")

## Ensure matrix is symmetric
mash_mat[lower.tri(mash_mat)] <- t(mash_mat)[lower.tri(mash_mat)]

## Convert to dist object
mash_dist <- as.dist(mash_mat)

## Get Sample name
samples <- rownames(mash_mat)


# 2. Import Assignation groups
pop_assign <- read_xlsx("Input_dir/africrop.xlsx", sheet = 3)


# 3. PCoA (Principal Coordinates Analysis)
pcoa <- pcoa(mash_dist)
var_explained <- pcoa$values$Relative_eig * 100
pcoa_df <- as.data.frame(pcoa$vectors[,1:2])
pcoa_df$Sample <- rownames(pcoa_df)
colnames(pcoa_df)[1:2] <- c("Axis.1", "Axis.2")

pcoa_df$`Field Cluster` <- factor(pop_assign$`Field identification`)
pcoa_df$`Field & Country Cluster` <- factor(pop_assign$Field_Country)
pcoa_df$`Assignment Cluster` <- factor(pop_assign$`Population assignment`)


# 4. PCoA plots with clusters
pcoa_plot2a <- ggplot(pcoa_df, aes(Axis.1, Axis.2, color = `Field Cluster`)) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = Sample), size = 3) +
  stat_ellipse(level = 0.95) +
  xlab(paste0("PCoA1 (", round(var_explained[1], 2), "%)")) +
  ylab(paste0("PCoA2 (", round(var_explained[2], 2), "%)")) +
  theme_minimal() +
  scale_color_brewer(palette = "Set2")

pcoa_plot2b <- ggplot(pcoa_df, aes(Axis.1, Axis.2, color = `Field & Country Cluster`)) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = Sample), size = 3) +
  stat_ellipse(level = 0.95) +
  xlab(paste0("PCoA1 (", round(var_explained[1], 2), "%)")) +
  ylab(paste0("PCoA2 (", round(var_explained[2], 2), "%)")) +
  theme_minimal() +
  scale_color_brewer(palette = "Set2")

pcoa_plot2c <- ggplot(pcoa_df, aes(Axis.1, Axis.2, color = `Assignment Cluster`)) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = Sample), size = 3) +
  stat_ellipse(level = 0.95) +
  xlab(paste0("PCoA1 (", round(var_explained[1], 2), "%)")) +
  ylab(paste0("PCoA2 (", round(var_explained[2], 2), "%)")) +
  theme_minimal() +
  scale_color_brewer(palette = "Set2")


# 5. Neighbor-Joining tree colored by clusters
tree <- nj(mash_dist)
tip_colors1 <- setNames(as.character(pcoa_df$`Field & Country Cluster`), samples)
tip_colors2 <- setNames(as.character(pcoa_df$`Assignment Cluster`), samples)

tree_plot1 <- ggtree(tree, layout="circular") +
  geom_tiplab(aes(color = tip_colors1[.data$label]), size=2) +
  scale_color_brewer(palette="Set2") +
  ggtitle("Mash NJ Tree colored by Fiels & Country clusters") +
  theme(legend.position="right")

tree_plot2 <- ggtree(tree, layout="circular") +
  geom_tiplab(aes(color = tip_colors2[.data$label]), size=2) +
  scale_color_brewer(palette="Set2") +
  ggtitle("Mash NJ Tree colored by Assignment clusters") +
  theme(legend.position="right")


------------------------------------------------------------------------

# Save plots
ggsave(paste0(output_dir,"/pcoa_2a.png"),
       plot = pcoa_plot2a, width = 10, height = 6, dpi = 300)
ggsave(paste0(output_dir,"/pcoa_2b.png"),
       plot = pcoa_plot2b, width = 10, height = 6, dpi = 300)
ggsave(paste0(output_dir,"/pcoa_2c.png"), 
       plot = pcoa_plot2c, width = 10, height = 6, dpi = 300)

ggsave(paste0(output_dir,"/nj_1.pdf"), 
       tree_plot1, width = 20, height = 20)
ggsave(paste0(output_dir,"/nj_2.pdf"), 
       tree_plot2, width = 20, height = 20)

ggsave(paste0(output_dir,"/heatmap_1.png"),
       plot = heatmap1, width = 10, height = 6, dpi = 300)
ggsave(paste0(output_dir,"/heatmap_2.png"),
       plot = heatmap2, width = 10, height = 6, dpi = 300)




# ======================== Mash distance with ref ==============================

# Create main output directories
output_dir  <- "Mash_results/ReadRef"
dir.create(output_dir, showWarnings = FALSE)

# Load Mash distance matrix
mash <- read.table("Input_dir/distances_mash/dist_all/distReadRefk21s10000_clean.tab", 
                   header=FALSE)
colnames(mash) <- c("Query","Ref","Distance","Pvalue","SharedHashes")

# Change ref sample 
mash$Query[mash$Query == "GCF_009730915.1_TDr96_F1_v2_PseudoChromosome.rev07_lg8_w22_25.fasta_genomic.fna"] <- "TDr96_F1_v2"
mash$Ref[mash$Ref == "GCF_009730915.1_TDr96_F1_v2_PseudoChromosome.rev07_lg8_w22_25.fasta_genomic.fna"] <- "TDr96_F1_v2"
mash$Query[mash$Query == "GCA_002260605.1_TDr96x99_v1.0.fasta_genomic.fna"] <- "TDr96x99_v1"
mash$Ref[mash$Ref == "GCA_002260605.1_TDr96x99_v1.0.fasta_genomic.fna"] <- "TDr96x99_v1"

# Export
write.csv(mash,
          file = file.path(output_dir, "distRefk21s10000.csv"), row.names = FALSE)

