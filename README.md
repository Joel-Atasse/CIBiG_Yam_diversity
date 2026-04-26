# CIBiG_Yam_diversity
This Git repository contains scripts, datasets, and analysis workflows used to investigate the genetic diversity of yam populations using Mash approach. 

The directory structure (generated with the tree command) is shown below:

.
├── Data
│   ├── Africrop
│   │   ├── fastq   
│   │   ├── fastq_renamed   
│   │   ├── logs   
│   │   ├── renamed_fastq
│   │   └── vcf
│   │       ├── check
│   │       ├── dist
│   │       ├── logs
│   │       └── mantel_test
│   ├── BFcrop
│   │   ├── fastq
│   │   ├── fastq_trim
│   │   ├── logs
│   │   ├── merge
│   │   └── merge_trim
│   └── ref
├── Mash_out
│   ├── distances
│   │   ├── dist_all
│   │   ├── k21s1000
│   │   └── k21s10000
│   ├── logs
│   ├── merged_reads
│   ├── ref
│   └── sketches
│       ├── k21s1000
│       ├── k21s10000
│       └── ref_sk│   
├── Metadata
│   ├── africrop_rename_SRA.csv
│   ├── SraAccList.txt
│   ├── sra_metadata.csv
│   ├── SRA_name.csv
│   └── test_renom_SRA.csv
├── QC_stat
│   ├── Africrop_stat
│   ├── BFcrop_merge_stat
│   ├── BFcrop_merge_trim_stat
│   ├── BFcrop_stat
│   ├── BFcrop_trim_stat
│   ├── logs
│   ├── R_map
│   └── Summary
├── Reads_QC
│   ├── Africrop
│   ├── BFcrop
│   ├── BFcrop_merge
│   ├── BFcrop_merge_trim
│   ├── BFcrop_trim
│   ├── logs
│   └── Web_all
└── Scripts

