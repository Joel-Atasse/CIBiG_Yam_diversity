#!/bin/bash
#SBATCH --job-name=mhref2
#SBATCH --output=logs/mhref2_%A_%a.out
#SBATCH --error=logs/mhref2_%A_%a.err
#SBATCH --nodelist=node03
# deactivate SBATCH --time=48:00:00
#SBATCH --cpus-per-task=4
# desactivate SBATCH --mem=32G
#SBATCH --partition=normal
#SBATCH --array=1-3

#################################################
#
# Mash pipeline including reference genomes:
#    -  Combine sketches
#    -  Compute Mash distances
#
#################################################


# Variables
WORKDIR="/scratch/dansouk/yam_dir"
RESULT_DIR="$WORKDIR/Mash_out"
SKETCH_DIR="$RESULT_DIR/sketches"
DIST_DIR="$RESULT_DIR/distances/dist_all"


echo "========================================="
echo "Job ID    : $SLURM_JOB_ID"
echo "Node      : $SLURM_NODELIST"
echo "CPUs      : $SLURM_CPUS_PER_TASK"
echo "Start     : $(date)"
echo "Output    : $DIST_DIR"
echo "========================================="


echo "Mash pipeline part 2 started at: $(date)"

mkdir -p "$DIST_DIR"

# Load modules
module load bioinfo-wave
module load singularity/4.0.1
module load mash/2.3


# Sketches sizes
SIZE=(1000 10000)
index=$((SLURM_ARRAY_TASK_ID - 1))
kz=${SIZE[$index]}



# Copy reference sketches to $SKETCH_DIR
cp "$SKETCH_DIR/ref_sk/ref1_k21s$kz.msh" "$SKETCH_DIR/k21s$kz"/
cp "$SKETCH_DIR/ref_sk/ref2_k21s$kz.msh" "$SKETCH_DIR/k21s$kz"/


# Combine sketches
echo "Combine sketches..."


# If combined file exist delete
COMBINED_MSH="$SKETCH_DIR/k21s$kz/ref_reads.msh"
[ -f "$COMBINED_MSH" ] && rm "$COMBINED_MSH"

mash paste "$COMBINED_MSH" "$SKETCH_DIR/k21s$kz"/*.msh


# Compute pairwise distances
mash dist -p "$SLURM_CPUS_PER_TASK" "$COMBINED_MSH" "$COMBINED_MSH" > "$DIST_DIR/dist_ReadRef_k21s$kz.tab"


# Remove ref1 sketche from  $SKETCH_DIR/$k21s$kr
rm "$SKETCH_DIR/k21s$kz/ref1_k21s$kz.msh"
rm "$SKETCH_DIR/k21s$kz/ref2_k21s$kz.msh"



















