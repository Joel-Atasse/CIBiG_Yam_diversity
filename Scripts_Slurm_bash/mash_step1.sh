#!/bin/bash
#SBATCH --job-name=mash1
#SBATCH --output=logs/mash1_k21s10000_%A_%a.out
#SBATCH --error=logs/mash1_k21s10000_%A_%a.err
#SBATCH --nodelist=node03
# deactivate SBATCH --time=48:00:00
#SBATCH --cpus-per-task=1
#  desactivate SBATCH --mem=32G
#SBATCH --partition=normal
#SBATCH --array=1-173%8

###############################################################################
#
# Mash pipeline steps:
#
#    1. Create Mash sketches
#    2. Combine sketches
#    3. Compute Mash distances
#
# Step 1 here
###############################################################################


# Variables
WORKDIR="/scratch/dansouk/yam_dir"
RESULT_DIR="$WORKDIR/Mash_out"
READ_DIR="$RESULT_DIR/merged_reads"
SKETCH_DIR="$RESULT_DIR/sketches/k21s10000"
DIST_DIR="$RESULT_DIR/distances/k21s10000"

KMER=21
SKETCH=10000


echo "========================================="
echo "Job ID    : $SLURM_JOB_ID"
echo "Node      : $SLURM_NODELIST"
echo "CPUs      : $SLURM_CPUS_PER_TASK"
echo "Tasks nb  : 8"
echo "Start     : $(date)"
echo "Input     : $READ_DIR"
echo "Output    : $SKETCH_DIR"
echo "========================================="


echo "Mash sketch started at: $(date)"

mkdir -p "$SKETCH_DIR" "$DIST_DIR"



# Load modules
module load bioinfo-wave
module load singularity/4.0.1
module load mash/2.3


# Sample list
FILES=($READ_DIR/*.fastq.gz)
SAMPLE=${FILES[$SLURM_ARRAY_TASK_ID-1]}
NM=$(basename "$SAMPLE" .fastq.gz)

# Run Mash sketch
mash sketch -r -m 2 -k "$KMER" -s "$SKETCH"  -o "$SKETCH_DIR/$NM" "$SAMPLE"

echo "Sketches creation finished at $(date)"


