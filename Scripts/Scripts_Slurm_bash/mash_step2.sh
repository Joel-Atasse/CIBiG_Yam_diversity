#!/bin/bash
#SBATCH --job-name=mash2
#SBATCH --output=logs/mash2k21s10000_%A_%a.out
#SBATCH --error=logs/mash2_k21s10000_%A_%a.err
#SBATCH --nodelist=node03
# deactivate SBATCH --time=48:00:00
#SBATCH --cpus-per-task=8
# desactivate SBATCH --mem=32G
#SBATCH --partition=normal
# deactivate SBATCH --array=1-2

###############################################################################
#
# Mash pipeline steps
#
#    1. Create Mash sketches
#    2. Combine sketches
#    3. Compute Mash distances
#
# Steps 2 & 3 here
###############################################################################


# Variables
# Variables
WORKDIR="/scratch/dansouk/yam_dir"
RESULT_DIR="$WORKDIR/Mash_out"
READ_DIR="$RESULT_DIR/merged_reads"
SKETCH_DIR="$RESULT_DIR/sketches/k21s10000"
DIST_DIR="$RESULT_DIR/distances/k21s10000"



echo "========================================="
echo "Job ID    : $SLURM_JOB_ID"
echo "Node      : $SLURM_NODELIST"
echo "CPUs      : $SLURM_CPUS_PER_TASK"
echo "Start     : $(date)"
echo "Input     : $READ_DIR"
echo "Output    : $DIST_DIR"
echo "========================================="


echo "Mash pipeline part 2 started at: $(date)"

mkdir -p "$SKETCH_DIR" "$DIST_DIR"

# Load modules
module load bioinfo-wave
module load singularity/4.0.1
module load mash/2.3


# Combine sketches
echo "Combining sketches..."

# If combined file exist delete
COMBINED_MSH="${SKETCH_DIR}/all.msh"
[ -f "$COMBINED_MSH" ] && rm "$COMBINED_MSH"

mash paste "$COMBINED_MSH" "$SKETCH_DIR"/*.msh

echo "Sketch combination completed at $(date)"
echo


# Compute pairwise distances
echo "Computing pairwise Mash distances..."

mash dist -p "$SLURM_CPUS_PER_TASK" "$COMBINED_MSH" "$COMBINED_MSH" > "$DIST_DIR/mash_distances.tab"

echo "Distance calculation completed at $(date)"
echo
echo "=============Mash pipeline completed successfully ================"













