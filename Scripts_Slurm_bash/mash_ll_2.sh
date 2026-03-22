#!/bin/bash
#SBATCH --job-name=ms25ref2
#SBATCH --output=map_%A_%a.out
#SBATCH --error=map_%A_%a.err
#SBATCH --cpus-per-task=6
#SBATCH --mem=32G
#SBATCH --partition=normal


# VARIABLES
WORKDIR="/scratch/dansouk/yam_dir"
READ_DIR="$WORKDIR/Mash_out/merged_reads"
REF_GENOME="$WORKDIR/Mash_out/ref/GCF_009730915.1_TDr96_F1_v2_PseudoChromosome.rev07_lg8_w22_25.fasta_genomic.fna"

RESULT_DIR="$WORKDIR/Mash_out"
SKETCH_DIR="$RESULT_DIR/sketch_k25s1M_ref2"
DIST_DIR="$RESULT_DIR/distance_k25s1M_ref2"
LOGFILE="$RESULT_DIR/logs/mash_out_ref2_k25s1M.log"

KMER=25
SKETCH=1000000
MIN_KMER=2


echo "Mash pipeline started: $(date)" | tee -a "$LOGFILE"

mkdir -p "$SKETCH_DIR" "$DIST_DIR"

# Load modules
module load bioinfo-wave
module load singularity/4.0.1
module load mash/2.3


# Creating sketch for sample reads in parallel mode using backgroud jobs
echo "Creating Mash sketches for reads..." | tee -a "$LOGFILE"

MAX_JOBS="${SLURM_CPUS_PER_TASK:-6}" # Use CPUs allocated by SLURM as max jobs
CURRENT_JOBS=0

for FQ in "$READ_DIR"/*.fastq.gz; do
    SAMPLE=$(basename "$FQ" .fastq.gz)
    echo "$(date '+%F %T') | Creating Mash sketch for sample: $SAMPLE" | tee -a "$LOGFILE"
    
    # Run sketch in background
    mash sketch -k "$KMER" -s "$SKETCH" -m "$MIN_KMER" \
        -o "${SKETCH_DIR}/${SAMPLE}" -r "$FQ" &
    
    # If reach the max parallel jobs, wait for all to finish
    CURRENT_JOBS=$((CURRENT_JOBS + 1))        
    if [ "$CURRENT_JOBS" -ge "$MAX_JOBS" ]; then
        wait
        CURRENT_JOBS=0
    fi
done


# Wait for any remaining jobs before next steps
wait
echo "$(date '+%F %T') | Read sketches completed" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"


# Creating sketch for reference genome
echo "Creating Mash sketch for reference genome..." | tee -a "$LOGFILE"
mash sketch -k "$KMER" -s "$SKETCH" -o "${SKETCH_DIR}/reference" "$REF_GENOME"
echo "$(date '+%F %T') | Reference genome sketch completed" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"


# Combine sketches (reads + reference)
echo "Combining sketches..." | tee -a "$LOGFILE"

COMBINED_MSH="${SKETCH_DIR}/all.msh"
[ -f "$COMBINED_MSH" ] && rm "$COMBINED_MSH"

mash paste "$COMBINED_MSH" "$SKETCH_DIR"/*.msh
echo "$(date '+%F %T') | Sketch combination completed" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"


# Compute pairwise distances
echo "Computing pairwise Mash distances..." | tee -a "$LOGFILE"
mash dist -p "${SLURM_CPUS_PER_TASK:-6}" "$COMBINED_MSH" "$COMBINED_MSH" \
    > "$DIST_DIR/mash_distances.tab"
echo "$(date '+%F %T') | Distance calculation completed" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"


# Build triangle matrix
echo "Building Mash triangle matrix..." | tee -a "$LOGFILE"
mash triangle "$COMBINED_MSH" > "$DIST_DIR/mash_triangle.txt"

echo "$(date '+%F %T') | Triangle matrix completed" | tee -a "$LOGFILE"
echo  | tee -a "$LOGFILE"
echo "Mash pipeline completed successfully at $(date)" | tee -a "$LOGFILE"
















