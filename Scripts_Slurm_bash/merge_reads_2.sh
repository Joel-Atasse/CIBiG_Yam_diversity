#!/bin/bash
#SBATCH --job-name=merge_BF
#SBATCH --output=merge2_%j.out
#SBATCH --error=merge2_reads_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --partition=normal


WORKDIR="/scratch/dansouk/yam_dir/Data/BFcrop"
RDIR="$WORKDIR/merge_trim"
RESDIR="$WORKDIR/merge_2"
LOGFILE="$WORKDIR/logs/merge_2.log"

mkdir -p $RESDIR

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

echo "Merge finished at $(date)" | tee -a "$LOGFILE"
