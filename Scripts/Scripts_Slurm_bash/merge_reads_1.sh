#!/bin/bash
#SBATCH --job-name=merge_reads
#SBATCH --output=merge_reads_%j.out
#SBATCH --error=merge_reads_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --partition=normal


WORKDIR="/scratch/dansouk/yam_dir/Data/Africrop"
RDIR="$WORKDIR/renamed_fastq"
RESDIR="$WORKDIR/merged_reads"
LOGFILE="$WORKDIR/logs/merge.log"

mkdir -p $RESDIR

# Record start time
START_TIME=$(date +%s)

echo "Merge started at $(date)" | tee -a "$LOGFILE"

for R1 in ${RDIR}/*_R1.fastq.gz
do
    SAMPLE=$(basename "$R1" _R1.fastq.gz)
    R2="${RDIR}/${SAMPLE}_R2.fastq.gz"

    if [[ ! -f "$R2" ]]; then
        echo "Missing pair for $SAMPLE" | tee -a "$LOGFILE"
        continue
    fi

    echo "Merging $SAMPLE" | tee -a "$LOGFILE"
    cat "$R1" "$R2" > "$RESDIR/${SAMPLE}.fastq.gz"

done

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

