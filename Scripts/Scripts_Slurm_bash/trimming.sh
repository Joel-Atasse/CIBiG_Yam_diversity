#!/bin/bash
#SBATCH --job-name=trim
#SBATCH --output=trim_%j.out
#SBATCH --error=trim_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --partition=normal

# Record start time
START_TIME=$(date +%s)
echo "Trimming begining at $(date)" | tee -a "$LOGFILE"
echo >> "$LOGFILE"

# Variables
WORKDIR="/scratch/dansouk/yam_dir/Data/BFcrop"
RDIR_1="$WORKDIR/fastq"
RESDIR_1="$WORKDIR/fastq_trim"
RDIR_2="$WORKDIR/merge"
RESDIR_2="$WORKDIR/merge_trim"
LOGFILE="$WORKDIR/logs/trim.log"

ADAPT_R1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
ADAPT_R2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

mkdir -p "$RESDIR_1" "$RESDIR_2"

# Load module
module load cutadapt/4.5


# Raw data
cd "$RDIR_1"
for sample in $(ls -1 *.fq.gz | cut -d_ -f1-2); do

  echo "Process for $SAMPLE started at $(date)" | tee -a "$LOGFILE"

  cutadapt \
    -a "$ADAPT_R1" \
    -A "$ADAPT_R2" \
    -q 30,30 \
    -m 35 \
    -o "$RESDIR_1/${sample}_R1.fastq.gz" \
    -p "$RESDIR_1/${sample}_R2.fastq.gz" \
    "$RDIR_1/${sample}_R1.fq.gz" \
    "$RDIR_1/${sample}_R2.fq.gz" \
    --cores 16
    echo "Process for $SAMPLE ended at $(date)" | tee -a "$LOGFILE"
done

echo >> "$LOGFILE"

# Merge data
cd "$RDIR_2"
for sample in $(ls -1 *.fq.gz | cut -d_ -f1); do

  echo "Process for $SAMPLE started at $(date)" | tee -a "$LOGFILE"

  cutadapt \
    -a "$ADAPT_R1" \
    -A "$ADAPT_R2" \
    -q 30,30 \
    -m 35 \
    -o "$RESDIR_2/${sample}_R1.fastq.gz" \
    -p "$RESDIR_2/${sample}_R2.fastq.gz" \
    "$RDIR_2/${sample}_R1.fq.gz" \
    "$RDIR_2/${sample}_R2.fq.gz" \
    --cores 16
    echo "Process for $SAMPLE ended at $(date)" | tee -a "$LOGFILE"
done

echo >> "$LOGFILE"


# Record end time AFTER all merges finish
END_TIME=$(date +%s)


# Compute duration in seconds
DURATION=$((END_TIME - START_TIME))

# Convert to HH:MM:SS
HOURS=$((DURATION / 3600))
MINUTES=$(((DURATION % 3600) / 60))
SECONDS=$((DURATION % 60))

echo "Merge finished at $(date)" | tee -a "$LOGFILE"
echo "Total duration: ${HOURS}h ${MINUTES}m ${SECONDS}s" | tee -a "$LOGFILE"


