#!/bin/bash
#SBATCH --job-name=QCstat
#SBATCH --output=stat_%j.out
#SBATCH --error=stat_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --partition=normal


# Variables
WORKDIR="/scratch/dansouk/yam_dir"

RDIR_1="$WORKDIR/Data/Africrop/renamed_fastq"
RDIR_2="$WORKDIR/Data/BFcrop/fastq"
RDIR_3="$WORKDIR/Data/BFcrop/fastq_trim"
RDIR_4="$WORKDIR/Data/BFcrop/merge"
RDIR_5="$WORKDIR/Data/BFcrop/merge_trim"

RESDIR_1="$WORKDIR/QC_stat/Africrop_stat"
RESDIR_2="$WORKDIR/QC_stat/BFcrop_stat"
RESDIR_3="$WORKDIR/QC_stat/BFcrop_trim_stat"
RESDIR_4="$WORKDIR/QC_stat/BFcrop_merge_stat"
RESDIR_5="$WORKDIR/QC_stat/BFcrop_merge_trim_stat"

LOGDIR="$WORKDIR/QC_stat/logs"
mkdir -p "$LOGDIR"
LOGFILE="$LOGDIR/QCstat.log"


echo "QC statistics started at $(date)" | tee -a "$LOGFILE"

# Create output directories
mkdir  -p "$RESDIR_1" "$RESDIR_2" "$RESDIR_3" "$RESDIR_4" "$RESDIR_5"


# Load module
module load seqkit/2.11.0


# Input and output directory arrays
DIRS=("$RDIR_1" "$RDIR_2" "$RDIR_3" "$RDIR_4" "$RDIR_5")
OUTS=("$RESDIR_1" "$RESDIR_2" "$RESDIR_3" "$RESDIR_4" "$RESDIR_5")

for i in "${!DIRS[@]}"; do
    INDIR="${DIRS[$i]}"
    OUTDIR="${OUTS[$i]}"

    if [ ! -d "$INDIR" ]; then
        echo "Directory $INDIR not found, skipping" | tee -a "$LOGFILE"
        continue
    fi

    echo "Directory: $INDIR" | tee -a "$LOGFILE"
    cd "$INDIR"

    for FILE in "$INDIR"/*.fastq.gz; do
        [ -e "$FILE" ] || continue

        BASENAME=$(basename "$FILE" .fastq.gz)
        OUTFILE="${OUTDIR}/${BASENAME}_stats.tsv"

        seqkit stats -aT "$FILE" > "$OUTFILE" || echo "Failed $FILE" | tee -a "$LOGFILE"
	echo "Stat for $BASENAME from $INDIR achaved at $(date)" | tee -a "$LOGFILE"
    done
done

echo "All done at $(date)" | tee -a "$LOGFILE"

