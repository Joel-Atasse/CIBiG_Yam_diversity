#!/bin/bash
#SBATCH --job-name=mashref
#SBATCH --output=logs/mashref_%A_%a.out
#SBATCH --error=logs/mashref_%A_%a.err
#SBATCH --nodelist=node03
# deactivate SBATCH --time=48:00:00
#SBATCH --cpus-per-task=1
#  desactivate SBATCH --mem=32G
#SBATCH --partition=normal
#SBATCH --array=1-3

###############################################################################
#
# 		Creating sketch for reference genomes
#
###############################################################################


# Variables
WORKDIR="/scratch/dansouk/yam_dir"
RESULT_DIR="$WORKDIR/Mash_out"
SKETCH_DIR="$RESULT_DIR/sketches/ref_sk"
REF_1="$RESULT_DIR/ref/GCA_002260605.1_TDr96x99_v1.0.fasta_genomic.fna"
REF_2="$RESULT_DIR/ref/GCF_009730915.1_TDr96_F1_v2_PseudoChromosome.rev07_lg8_w22_25.fasta_genomic.fna"

KMER=21


echo "========================================="
echo "Job ID    : $SLURM_JOB_ID"
echo "Node      : $SLURM_NODELIST"
echo "CPUs      : $SLURM_CPUS_PER_TASK"
echo "Tasks nb  : 1"
echo "Start     : $(date)"
echo "Input_1   : $REF_1"
echo "Input_2   : $REF_2"
echo "Output    : $SKETCH_DIR"
echo "========================================="


echo "Mash sketch started at: $(date)"

mkdir -p "$SKETCH_DIR"


# Load modules
module load bioinfo-wave
module load singularity/4.0.1
module load mash/2.3


# Sketches sizes
SIZE=(1000 10000)
index=$((SLURM_ARRAY_TASK_ID - 1))
kz=${SIZE[$index]}


# Creating sketch for reference genome
mash sketch -k "$KMER" -s "$kz" -o "${SKETCH_DIR}/ref1_k21s$kz" "$REF_1"
mash sketch -k "$KMER" -s "$kz" -o "${SKETCH_DIR}/ref2_k21s$kz" "$REF_2"

