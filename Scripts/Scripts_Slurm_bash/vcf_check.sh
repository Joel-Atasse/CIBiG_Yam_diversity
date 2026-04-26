#!/bin/bash
#SBATCH --job-name=check
#SBATCH --output=logs/ck_%j.out
#SBATCH --error=logs/ck_%j.err
#SBATCH --nodelist=node03
# deactivate SBATCH --time=48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --partition=normal
# deactivate SBATCH --array=1-173%2
#SBATCH --chdir=/scratch/dansouk/yam_dir/Data/Africrop/vcf


# Variables
OUT_DIR="/scratch/dansouk/yam_dir/Data/Africrop/vcf/check"





# Load modules
module load bioinfo-wave
module load bcftools/1.18


# Compare variants number:
echo "========== Variants number in Calling_ALL_Rotundata_Allc05.vcf =========="
bcftools view -H Calling_ALL_Rotundata_Allc05.vcf | wc -l

echo
echo "========== Variants number in Calling_ALL_Rotundata_Allc05_reordered.vcf =========="
bcftools view -H Calling_ALL_Rotundata_Allc05_reordered.vcf | wc -l

echo
echo
# Compare chromosome-position-reference-alternate fields:
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' Calling_ALL_Rotundata_Allc05.vcf > "$OUT_DIR"/original_sites.txt
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' Calling_ALL_Rotundata_Allc05_reordered.vcf > "$OUT_DIR"/reordered_sites.txt

diff original_sites.txt reordered_sites.txt > "$OUT_DIR"/diff_position.txt

# Compare headers (except for the sample line):
bcftools view -h Calling_ALL_Rotundata_Allc05.vcf | grep '^##' > "$OUT_DIR"/original_header.txt
bcftools view -h Calling_ALL_Rotundata_Allc05_reordered.vcf | grep '^##' > "$OUT_DIR"/reordered_header.txt

diff original_header.txt reordered_header.txt > "$OUT_DIR"/diff_header.txt

echo
echo

# Compare a few variant lines before and after in order to confirm if genotype data were stayed attached to the correct samples:
echo "========== Variants in Calling_ALL_Rotundata_Allc05.vcf =========="
bcftools view Calling_ALL_Rotundata_Allc05.vcf | grep -v '^#' | head

echo
echo "========== Variants in Calling_ALL_Rotundata_Allc05_reordered.vcf =========="
bcftools view Calling_ALL_Rotundata_Allc05_reordered.vcf | grep -v '^#' | head


