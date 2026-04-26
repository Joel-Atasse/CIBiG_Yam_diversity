#!/bin/bash
#SBATCH --job-name=pd
#SBATCH --output=logs/pd_%j.out
#SBATCH --error=logs/pd_%j.err
#SBATCH --nodelist=node03
# deactivate SBATCH --time=48:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem=32G
#SBATCH --partition=normal
# deactivate SBATCH --array=1-173%2
#SBATCH --chdir=/scratch/dansouk/yam_dir/Data/Africrop/vcf/mantel_test


# Load R module
unset R_HOME

module load bioinfo-wave
module load R/4.5.1


R --version

# Run the R script
Rscript mantel_test.R

echo "=============================================="
