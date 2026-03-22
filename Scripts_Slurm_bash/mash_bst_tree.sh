#!/bin/bash
#SBATCH --job-name=bst
#SBATCH --output=bst_tree_%j.out
#SBATCH --error=bst_tree_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --partition=normal


# Variables
WORKDIR="/scratch/dansouk/yam_dir"
READ_DIR="$WORKDIR/Mash_out/merged_reads"

TREE_DIR="$WORKDIR/Mash_out/mashtree_out"
LOGFILE="$WORKDIR/Mash_out/logs/bst_mashtree.log"

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

echo "$(date '+%F %T') | Running MashTree bootstrap with k=$k" | tee -a "$LOGFILE"

mashtree_bootstrap.pl \
        --numcpus "${SLURM_CPUS_PER_TASK:-4}" \
        --rep 1000 \
        "$READ_DIR"/*.fastq.gz \
        > "$TREE_DIR/bst_mashtree_k${k}.nwk" \
        2> "$TREE_DIR/bst_mashtree_k${k}.log" 


echo "$(date '+%F %T') | Tree generation completed" | tee -a "$LOGFILE"


# Record end time AFTER all merges finish
END_TIME=$(date +%s)

# Compute duration in seconds
DURATION=$((END_TIME - START_TIME))

# Convert to HH:MM:SS
HOURS=$((DURATION / 3600))
MINUTES=$(((DURATION % 3600) / 60))
SECONDS=$((DURATION % 60))

echo  | tee -a "$LOGFILE"
echo "Mashtree pipeline completed successfully at $(date)" | tee -a "$LOGFILE"
echo "Total duration: ${HOURS}h ${MINUTES}m ${SECONDS}s" | tee -a "$LOGFILE"










