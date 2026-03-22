#!/bin/bash
#SBATCH --job-name=tree
#SBATCH --output=tree_%j.out
#SBATCH --error=tree_%j.err
#SBATCH --cpus-per-task=24
#SBATCH --mem=32G
#SBATCH --partition=short


# Variables
WORKDIR="/scratch/dansouk/yam_dir"
READ_DIR="$WORKDIR/Mash_out/merged_reads"
REF_GENOME1="$WORKDIR/Mash_out/ref/GCA_002260605.1_TDr96x99_v1.0.fasta_genomic.fna"
REF_GENOME2="$WORKDIR/Mash_out/ref/GCF_009730915.1_TDr96_F1_v2_PseudoChromosome.rev07_lg8_w22_25.fasta_genomic.fna"

TREE_DIR="$WORKDIR/Mash_out/mashtree_out"
LOGFILE="$RESULT_DIR/logs/mashtree.log"

mkdir -p "$TREE_DIR"


#KMER=21
#SKETCH=1000000
#MIN_KMER=2

# Record start time
START_TIME=$(date +%s)


echo "Mashtree pipeline started: $(date)" | tee -a "$LOGFILE"
echo | tee -a "$LOGFILE"

mkdir -p "$TREE_DIR"

# Load modules
module load bioinfo-wave
module load singularity/4.0.1
module load mash/2.3
module load mashtree/1.4.6

# Build tree

# Using default parameters
echo "Building Mashtree phylogeny_Only reads at $(date)" | tee -a "$LOGFILE"
mashtree --mindepth 0 --numcpus "${SLURM_CPUS_PER_TASK:-24}" "$READ_DIR"/*.fastq.gz \
    > "$TREE_DIR/mashtree.nwk"
echo "Building completed at...$(date)" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"


echo "Building Mashtree phylogeny_Only reads at $(date)" | tee -a "$LOGFILE"
mashtree --mindepth 0 --numcpus "${SLURM_CPUS_PER_TASK:-24}" -E "$READ_DIR"/*.fastq.gz \
    > "$TREE_DIR/mashtree_E.nwk"
echo "Building completed at...$(date)" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"


echo "Building Mashtree phylogeny_Reads with ref1 at $(date)" | tee -a "$LOGFILE"
mashtree --mindepth 0 --numcpus "${SLURM_CPUS_PER_TASK:-24}" "$READ_DIR"/*.fastq.gz "$REF_GENOME1" \
    > "$TREE_DIR/mashtree_ref1.nwk"
echo "Building completed at...$(date)" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"


echo "Building Mashtree phylogeny_Reads with ref1 at $(date)" | tee -a "$LOGFILE"
mashtree --mindepth 0 --numcpus "${SLURM_CPUS_PER_TASK:-24}" "$READ_DIR"/*.fastq.gz "$REF_GENOME2" \
    > "$TREE_DIR/mashtree_ref2.nwk"
echo "Building completed at...$(date)" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"

echo "All done at...$(date)" | tee -a "$LOGFILE"


# Record end time AFTER all merges finish
END_TIME=$(date +%s)

# Compute duration in seconds
DURATION=$((END_TIME - START_TIME))

# Convert to HH:MM:SS
HOURS=$((DURATION / 3600))
MINUTES=$(((DURATION % 3600) / 60))
SECONDS=$((DURATION % 60))

echo "Total duration: ${HOURS}h ${MINUTES}m ${SECONDS}s" | tee -a "$LOGFILE"
