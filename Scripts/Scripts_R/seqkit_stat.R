# Set work directory
setwd("/media/joel/Lab/CIBiG_2025/stage_yam/R_analysis")

# Create main output directories
output_dir0  <- "QC_metric_stat"
output_dir1 <- "QC_metric_stat/Africrop"
dir.create(output_dir0, showWarnings = FALSE)
dir.create(output_dir1, showWarnings = FALSE)

# Load libraries
library(stringr)	# string/text manipulation.
library(dplyr)    	# data manipulation (cleaning, filtering, summarizing)
library(ggplot2)  	# data visualization 
library(ggrepel)  	# Prevents overlapping text in/ non-overlapping labels
library(gridExtra)  	# combine/arrange multiple plots into one figure
library(factoextra) 	# Visualization tools for multivariate analysis
library(GGally)     	# Extension of ggplot2/ ggpairs() → correlation matrix with scatterplots
library(kableExtra)  	# Used to make beautiful tables (for reports or HTML or PDF output)
library(readxl) 	# read Excel files

# Import files .tsv
stats_1 <- read.table("Input_dir/Summary/Afr.tsv", 
                      header = TRUE, sep = "\t", stringsAsFactors = FALSE)
stats_2 <- read.table("Input_dir/Summary/BF.tsv", 
                      header = TRUE, sep = "\t", stringsAsFactors = FALSE)
stats_3 <- read.table("Input_dir/Summary/BF_trim.tsv", 
                      header = TRUE, sep = "\t", stringsAsFactors = FALSE)
stats_4 <- read.table("Input_dir/Summary/BF_merge.tsv", 
                      header = TRUE, sep = "\t", stringsAsFactors = FALSE)
stats_5 <- read.table("Input_dir/Summary/BF_merge_trim.tsv", 
                      header = TRUE, sep = "\t", stringsAsFactors = FALSE)
# Rename
name_1 <- c("A3009_R1","A3009_R2","A3085_R1","A3085_R2","A420_R1","A420_R2",
            "A467_R1","A467_R2","A5045_R1","A5045_R2","A5047_R1","A5047_R2",
            "A5048_R1","A5048_R2","A5059_R1","A5059_R2","A5061_R1","A5061_R2",
            "A5066_R1","A5066_R2","A5067_R1","A5067_R2","A5068_R1","A5068_R2",
            "A52_R1","A52_R2","A537_R1","A537_R2","A5497_R1","A5497_R2",
            "A5498_R1","A5498_R2","A5499_R1","A5499_R2","A5689_R1","A5689_R2",
            "A5690_R1","A5690_R2","A5691_R1","A5691_R2","A5693_R1","A5693_R2",
            "A5694_R1","A5694_R2","A5695_R1","A5695_R2","A5696_R1","A5696_R2",
            "A5697_R1","A5697_R2","A5699_R1","A5699_R2","A5700_R1","A5700_R2",
            "A5701_R1","A5701_R2","A5702_R1","A5702_R2","A5703_R1","A5703_R2",
            "A5704_R1","A5704_R2","A5705_R1","A5705_R2","A62_R1","A62_R2",
            "A67_R1","A67_R2","CR3586_R1","CR3586_R2","CR3725_R1","CR3725_R2",
            "CR4003_R1","CR4003_R2","CR4229_R1","CR4229_R2","CR4275_R1","CR4275_R2",
            "CR4583_R1","CR4583_R2","CR4818_R1","CR4818_R2","CR4923_R1","CR4923_R2",
            "CR4941_R1","CR4941_R2","CR4950_R1","CR4950_R2","CR4952_R1","CR4952_R2",
            "CR4963_R1","CR4963_R2","CR4965_R1","CR4965_R2","CR4967_R1","CR4967_R2",
            "CR4969_R1","CR4969_R2","CR4980_R1","CR4980_R2","CR4987_R1","CR4987_R2",
            "CR4990_R1","CR4990_R2","CR4991_R1","CR4991_R2","CR5003_R1","CR5003_R2",
            "CR5005_R1","CR5005_R2","CR5014_R1","CR5014_R2","CR5018_R1","CR5018_R2",
            "CR5029_R1","CR5029_R2","CR5031_R1","CR5031_R2","CR5036_R1","CR5036_R2",
            "CR5097_R1","CR5097_R2","CR5099_R1","CR5099_R2","CR5111_R1","CR5111_R2",
            "CR5118_R1","CR5118_R2","CR5120_R1","CR5120_R2","CR5345_R1","CR5345_R2",
            "CR5346_R1","CR5346_R2","CR5348_R1","CR5348_R2","CR5353_R1","CR5353_R2",
            "CR5387_R1","CR5387_R2","CR5390_R1","CR5390_R2","CR5392_R1","CR5392_R2",
            "CR5456_R1","CR5456_R2","CR5457_R1","CR5457_R2","CR5458_R1","CR5458_R2",
            "CR5461_R1","CR5461_R2","CR5462_R1","CR5462_R2","CR5465_R1","CR5465_R2",
            "CR5467_R1","CR5467_R2","CR5468_R1","CR5468_R2","CR5477_R1","CR5477_R2",
            "CR5478_R1","CR5478_R2","CR5489_R1","CR5489_R2","CR5517_R1","CR5517_R2",
            "CR5522_R1","CR5522_R2","CR5523_R1","CR5523_R2","CR5525_R1","CR5525_R2",
            "CR5526_R1","CR5526_R2","CR5527_R1","CR5527_R2","CR5533_R1","CR5533_R2",
            "CR5537_R1","CR5537_R2","CR5540_R1","CR5540_R2","CR5543_R1","CR5543_R2",
            "CR5546_R1","CR5546_R2","CR5553_R1","CR5553_R2","CR5555_R1","CR5555_R2",
            "CR5558_R1","CR5558_R2","CR5565_R1","CR5565_R2","CR5567_R1","CR5567_R2",
            "CR5573_R1","CR5573_R2","CR5574_R1","CR5574_R2","CR5583_R1","CR5583_R2",
            "CR5591_R1","CR5591_R2","CR5599_R1","CR5599_R2","CR5602_R1","CR5602_R2",
            "CR5615_R1","CR5615_R2","CR5639_R1","CR5639_R2","CR5663_R1","CR5663_R2",
            "CR5682_R1","CR5682_R2","CR629_R1","CR629_R2","CR668_R1","CR668_R2",
            "CR685_R1","CR685_R2","CR694_R1","CR694_R2","CR702_R1","CR702_R2",
            "CR703_R1","CR703_R2","CR833_R1","CR833_R2","CR837_R1","CR837_R2",
            "CR844_R1","CR844_R2","CR849_R1","CR849_R2","CR869_R1","CR869_R2",
            "P2990_R1","P2990_R2","P323_R1","P323_R2","P424_R1","P424_R2",
            "P425_R1","P425_R2","P457_R1","P457_R2","P462_R1","P462_R2",
            "P464_R1","P464_R2","P4917_R1","P4917_R2","P4918_R1","P4918_R2",
            "P4919_R1","P4919_R2","P4920_R1","P4920_R2","P4921_R1","P4921_R2",
            "P4928_R1","P4928_R2","P4936_R1","P4936_R2","P4937_R1","P4937_R2",
            "P5318_R1","P5318_R2","P5344_R1","P5344_R2","P5350_R1","P5350_R2",
            "P5358_R1","P5358_R2","P5369_R1","P5369_R2","P5378_R1","P5378_R2",
            "P5381_R1","P5381_R2","P5404_R1","P5404_R2","P5413_R1","P5413_R2",
            "P5417_R1","P5417_R2","P5420_R1","P5420_R2","P5424_R1","P5424_R2",
            "P5427_R1","P5427_R2","P5430_R1","P5430_R2","P5434_R1","P5434_R2",
            "P5438_R1","P5438_R2","P5441_R1","P5441_R2","P5448_R1","P5448_R2",
            "P5472_R1","P5472_R2","P5483_R1","P5483_R2","P5708_R1","P5708_R2",
            "P5710_R1","P5710_R2","P5713_R1","P5713_R2","P5716_R1","P5716_R2",
            "P5717_R1","P5717_R2","P5720_R1","P5720_R2","P5723_R1","P5723_R2",
            "P5728_R1","P5728_R2","P5729_R1","P5729_R2","P5746_R1","P5746_R2",
            "P599_R1","P599_R2","P624_R1","P624_R2")


name_2 <- c("CR5858_L5_R1","CR5858_L5_R2","CR5858_L6_R1","CR5858_L6_R2",
            "CR5858_L8_R1","CR5858_L8_R2","CR5859_L5_R1","CR5859_L5_R2",
            "CR5859_L6_R1","CR5859_L6_R2","CR5859_L8_R1","CR5859_L8_R2",
            "CR5860_L5_R1","CR5860_L5_R2","CR5860_L6_R1","CR5860_L6_R2",
            "CR5860_L8_R1","CR5860_L8_R2","CR5861_L5_R1","CR5861_L5_R2",
            "CR5861_L6_R1","CR5861_L6_R2","CR5861_L8_R1","CR5861_L8_R2",
            "CR5862_L5_R1","CR5862_L5_R2","CR5862_L6_R1","CR5862_L6_R2",
            "CR5862_L8_R1","CR5862_L8_R2","CR5863_L5_R1","CR5863_L5_R2",
            "CR5863_L6_R1","CR5863_L6_R2","CR5863_L8_R1","CR5863_L8_R2"
)
name_3 <- name_2

name_4 <- c("CR5858_R1","CR5858_R2","CR5859_R1","CR5859_R2","CR5860_R1",
            "CR5860_R2","CR5861_R1","CR5861_R2","CR5862_R1","CR5862_R2",
            "CR5863_R1","CR5863_R2"
)
name_5 <- name_4

# Color: R1, R2
col_1= c("R1" = "yellow3", "R2" = "steelblue2")
col_2= c("R1" = "slateblue", "R2" = "orange")
col_3= c("R1" = "lightblue4", "R2" = "lightcoral")
col_4= c("R1" = "lightgreen", "R2" = "steelblue")
col_5= c("R1" = "lightgoldenrod3", "R2" = "lightsalmon2")

# Color:  Sample
cl_1= "yellow3"
cl_2= "slateblue"
cl_3= "lightblue4"
cl_4= "lightgreen"
cl_5= "lightgoldenrod3"

# Output directories
output_dir_1  <- paste0(output_dir1, "/all_yam")
output_dir_2  <- paste0(output_dir0, "/BFcrop") 
output_dir_3  <- paste0(output_dir0, "/BRcrop_trim") 
output_dir_4  <- paste0(output_dir0, "/BFcrop_merge") 
output_dir_5  <- paste0(output_dir0, "/BFcrop_merge_trim") 


# ----------------------------  Perform Analysis  ---------------------------- #

for (i in 1:5) {
  
  stats <- get(paste0("stats_", i))
  name <- get(paste0("name_", i))
  kol <- get(paste0("col_", i))
  kl <- get(paste0("cl_", i))
  output_dir <- get(paste0("output_dir_", i))
  
  out_prefix <- "stat"
  dir.create(output_dir, showWarnings = FALSE)
  
  row.names(stats) <- name
  stats$file <- row.names(stats)
  colnames(stats) <- c("sample","format","type","num_seqs","sum_len",
                       "min_len","avg_len", "max_len", "Q1","Q2","Q3",
                       "sum_gap","N50","N50_num","Q20","Q30","AvgQual",
                       "GC","sum_n")
  
  # Compute Sequence Depth/genome size (584.2 Mb_TDr96_F1_v2)
  genome_size <- 584200000  

  # Compute depth
  stats$depth <- stats$sum_len / genome_size

  # QC Summary Table
  tab_1 <- stats %>%
    summarise(
      n_samples = n(),
      mean_reads = mean(num_seqs),
      sd_reads   = sd(num_seqs),
      cv_reads   = sd_reads / mean_reads,
      mean_bases = mean(sum_len),
      mean_len   = mean(avg_len),
      mean_depth = mean(depth),
    ) 

  tab_2 <- stats %>%
    select(sample, num_seqs, sum_len, min_len,avg_len,max_len,
           N50, Q20, Q30, AvgQual, GC, depth) %>%
    arrange(desc(num_seqs)) 

  # Outlier Detection (Z-score)
  stats <- stats %>%
    mutate(
      z_reads = as.numeric(scale(num_seqs)),
      z_bases = as.numeric(scale(sum_len)),
      outlier = ifelse(abs(z_reads) > 2 | abs(z_bases) > 2, "Yes", "No")
      )

  stats <- stats %>%
    mutate(read_type = ifelse(grepl("_R1", sample), "R1", "R2")) %>%
    group_by(read_type)

  stats %>%
    mutate(read_type = ifelse(grepl("_1", sample), "1", "2")) %>%
    group_by(read_type) 

  # Save tables
  write.csv(tab_1,
            file = file.path(output_dir, paste0(out_prefix, "_summary_1.csv")),
            row.names = FALSE)
  write.csv(tab_2,
            file = file.path(output_dir, paste0(out_prefix, "_summary_2.csv")),
            row.names = FALSE)
  write.csv(stats,
            file = file.path(output_dir, paste0(out_prefix, "_detailed.csv")),
            row.names = FALSE)

  # -------------------------Plots ------------------------------------------- #

  # Barplot: Total Reads per Sample by Read Type

  p1 <- ggplot(stats, aes(x = reorder(sample, num_seqs), 
                          y = num_seqs/1e6, fill = read_type)) +
    geom_bar(stat = "identity", width = 0.99,  color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    scale_fill_manual(values = kol) +
    labs(title = "Number of Reads per Sample",
         x = "Sample",
         y = "Number of reads (1e6)",
         fill = "Read type")
  
  p2 <- ggplot(stats, aes(x = reorder(sample, sum_len), 
                          y = sum_len/1e9, fill = read_type)) +
    geom_bar(stat = "identity", width = 0.99,  color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    scale_fill_manual(values = kol) +
    labs(title = "Number of bases per Sample",
         x = "Sample",
         y = "Number of bases (1e9)",
         fill = "Read type")
  
  p3 <- ggplot(stats, aes(x = reorder(sample, depth), 
                          y = depth, fill = read_type)) +
    geom_bar(stat = "identity", width = 0.99,  color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    scale_fill_manual(values = kol) +
    labs(title = "Depth per Sample",
         x = "Sample",
         y = "Depth (Coverage) ",
         fill = "Read type")
  

  # Histogram
  p4 <- ggplot(stats, aes(x = num_seqs/1e6, fill = read_type)) +
    geom_histogram(bins = 20, alpha = 0.8, position = "dodge", color = "black") +
    theme_minimal() +
    scale_fill_manual(values = kol) +  
    labs(title = "Distribution of Number of Sequences (R1 vs R2)",
         x = "Number of sequences (1e6)",
         y = "Count of Samples",
         fill = "Read Type")
  
  p5 <- ggplot(stats, aes(x = sum_len/1e9, fill = read_type)) +
    geom_histogram(bins = 20, alpha = 0.8, position = "dodge", color = "black") +
    theme_minimal() +
    scale_fill_manual(values = kol) +
    labs(title = "Distribution of Number of Bases (R1 vs R2)",
         x = "Number of bases (1e9)",
         y = "Count of Samples",
         fill = "Read Type")
  
  p6 <- ggplot(stats, aes(x = AvgQual, fill = read_type)) +
    geom_histogram(bins = 10, alpha = 0.8, position = "dodge", color = "black") +
    theme_minimal() +
    scale_fill_manual(values = kol) +
    labs(title = "Distribution of average quality (R1 vs R2)",
         x = "Quality score",
         y = "Average quality score",
         fill = "Read Type")
  
  p7 <- ggplot(stats, aes(x = depth, fill = read_type)) +
    geom_histogram(bins = 15, alpha = 0.8, position = "dodge", color = "black") +
    theme_minimal() +
    scale_fill_manual(values = kol) +
    labs(title = "Distribution of Sequence depth (R1 vs R2)",
         x = "Coverage",
         y = "Count of Samples",
         fill = "Read Type")

  # Lst of plots
  plots_list <- list(p1=p1, p2=p2, p3=p3, p4=p4, p5=p5, p6=p6, p7=p7)
  
  # Loop to save each plot
  for (name in names(plots_list)) {
    filename <- file.path(output_dir, paste0("plot", "_", name, ".png"))
    
    png(filename = filename, width = 1200, height = 800, res = 150)
    print(plots_list[[name]])  # print the ggplot object
    dev.off()
  }
  
  # ------------------- Summaryze by sample -----------------------------
  summary <- stats %>%
    mutate(Sample = sub("_R[12].*", "", sample)) %>%
    group_by(Sample) %>%
    summarise(
      read_pairs = first(num_seqs),
      total_reads = sum(num_seqs),
      total_bases = sum(sum_len),
      Depth = sum(sum_len)/genome_size
    )
  
  # Save tables
  write.csv(summary,
            file = file.path(output_dir, 
                             paste0(out_prefix, "_summary_per_sample.csv")),
            row.names = FALSE)
  
  p1a <- ggplot(summary, aes(x = reorder(Sample, total_reads), 
                             y = total_reads/1e6)) +
    geom_bar(stat = "identity", width = 0.99,  fill = kl, color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    labs(title = "Number of Reads per Sample",
         x = "Sample",
         y = "Number of reads (1e6)")
  
  p2a <- ggplot(summary, aes(x = reorder(Sample, total_bases), 
                             y = total_bases/1e9)) +
    geom_bar(stat = "identity", width = 0.99, fill = kl,  color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    labs(title = "Number of bases per Sample",
         x = "Sample",
         y = "Number of bases (1e9)")
  #, fill = read_type 
  p3a <- ggplot(summary, aes(x = reorder(Sample, Depth), y = Depth)) +
    geom_bar(stat = "identity", width = 0.99,  fill = kl, color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    labs(title = "Depth per Sample",
         x = "Sample",
         y = "Depth (Coverage)")
  
  
  # Histogram
  p4a <- ggplot(summary, aes(x = total_reads/1e6)) +
    geom_histogram(bins = 50, alpha = 0.8, position = "dodge", 
                   fill = kl, color = "black") +
    theme_minimal() +
    labs(title = "Distribution of Number of Sequences",
         x = "Number of sequences (1e6)",
         y = "Count of Samples")
  
  p5a <- ggplot(summary, aes(x = total_bases/1e9)) +
    geom_histogram(bins = 50, alpha = 0.8, position = "dodge", 
                   fill = kl, color = "black") +
    theme_minimal() +
    labs(title = "Distribution of Number of Bases",
         x = "Number of bases (1e9)",
         y = "Count of Samples")
  
  p6a <- ggplot(summary, aes(x = Depth)) +
    geom_histogram(bins = 20, alpha = 0.8, position = "dodge",
                   fill = kl, color = "black") +
    theme_minimal() +
    labs(title = "Distribution of depth",
         x = "Depth",
         y = "Count of sample")
  
  
  # Lst of plots
  plots_list <- list(p1=p1a, p2=p2a, p3=p3a, p4=p4a, p5=p5a, p6=p6a)
  
  # Loop to save each plot
  for (name in names(plots_list)) {
    filename <- file.path(output_dir, paste0("sample_plot", "_", name, ".png"))
    
    png(filename = filename, width = 1200, height = 800, res = 150)
    print(plots_list[[name]])  # print the ggplot object
    dev.off()
  }
  
}


# ----------------------- Stat per Species ------------------------- #

# 1. Import files .tsv
stat_1 <- read_xlsx("Input_dir/Summary/QC_summary.xlsx", sheet = 6)
stat_2 <- read_xlsx("Input_dir/Summary/QC_summary.xlsx", sheet = 7)
stat_3 <- read_xlsx("Input_dir/Summary/QC_summary.xlsx", sheet = 8)

# Color
col_1= "plum3"
col_2= "navajowhite2"
col_3= "olivedrab3"

# Output directories
output_dir_1  <- paste0(output_dir1, "/abissinica")
output_dir_2  <- paste0(output_dir1, "/praehensilis")
output_dir_3  <- paste0(output_dir1, "/rotundata")


for (i in 1:3) {
  stat <- get(paste0("stat_", i))
  kol <- get(paste0("col_", i))
  output_dir <- get(paste0("output_dir_", i))
  
  out_prefix <- "plot"
  dir.create(output_dir, showWarnings = FALSE)
  
  # Barplot: Total Reads per Sample by Read Type
  
  p1 <- ggplot(stat, aes(x = reorder(Sample, Read), y = Read/1e6)) +
    geom_bar(stat = "identity", width = 0.99,  fill = kol, color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    labs(title = "Number of Reads per Sample",
         x = "Sample",
         y = "Number of reads (1e6)")
  
  p2 <- ggplot(stat, aes(x = reorder(Sample, Base), y = Base/1e9)) +
    geom_bar(stat = "identity", width = 0.99, fill = kol,  color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    labs(title = "Number of bases per Sample",
         x = "Sample",
         y = "Number of bases (1e9)")
  #, fill = read_type 
  p3 <- ggplot(stat, aes(x = reorder(Sample, Depth), y = Depth)) +
    geom_bar(stat = "identity", width = 0.99,  fill = kol, color = "black") +
    coord_flip() +
    theme_minimal(base_size = 12) +
    labs(title = "Depth per Sample",
         x = "Sample",
         y = "Depth (Coverage)")
  
  
  # Histogram
  p4 <- ggplot(stat, aes(x = Read/1e6)) +
    geom_histogram(bins = 50, alpha = 0.8, position = "dodge", 
                   fill = kol, color = "black") +
    theme_minimal() +
    labs(title = "Distribution of Number of Sequences",
         x = "Number of sequences (1e6)",
         y = "Count of Samples")
  
  p5 <- ggplot(stat, aes(x = Base/1e9)) +
    geom_histogram(bins = 50, alpha = 0.8, position = "dodge", 
                   fill = kol, color = "black") +
    theme_minimal() +
    labs(title = "Distribution of Number of Bases",
         x = "Number of bases (1e9)",
         y = "Count of Samples")
  
  p6 <- ggplot(stat, aes(x = Depth)) +
    geom_histogram(bins = 20, alpha = 0.8, position = "dodge",
                   fill = kol, color = "black") +
    theme_minimal() +
    labs(title = "Distribution of depth",
         x = "Depth",
         y = "Count of sample")
  
  
  # Lst of plots
  plots_list <- list(p1=p1, p2=p2, p3=p3, p4=p4, p5=p5, p6=p6)
  
  # Loop to save each plot
  for (name in names(plots_list)) {
    filename <- file.path(output_dir, paste0("plot", "_", name, ".png"))
    
    png(filename = filename, width = 1200, height = 800, res = 150)
    print(plots_list[[name]])  # print the ggplot object
    dev.off()
  }
}
