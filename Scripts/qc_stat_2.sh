#!/bin/bash
#SBATCH --job-name=QCstat
#SBATCH --output=/scratch/dansouk/yam_dir/QC_stat/logs/stat_%j.out
#SBATCH --error=/scratch/dansouk/yam_dir/QC_stat/logs/stat_%j.err
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
LOGFILE="$LOGDIR/QCstat2.log"


echo "QC statistics started at $(date)" | tee -a "$LOGFILE"

# Create output directories
mkdir  -p "$RESDIR_1" "$RESDIR_2" "$RESDIR_3" "$RESDIR_4" "$RESDIR_5"


# Load module
module load seqkit/2.11.0
module load seqkit/2.11.0 || { echo "Failed to load seqkit" | tee -a "$LOGFILE"; exit 1; }


# Input and output directory arrays
DIRS=("$RDIR_2" "$RDIR_4")
OUTS=("$RESDIR_2" "$RESDIR_4")


for i in "${!DIRS[@]}"; do
    INDIR="${DIRS[$i]}"
    OUTDIR="${OUTS[$i]}"

    if [ ! -d "$INDIR" ]; then
        echo "Directory $INDIR not found, skipping" | tee -a "$LOGFILE"
        continue
    fi

    echo "Processing directory: $INDIR" | tee -a "$LOGFILE"
    cd "$INDIR"

    for FILE in "$INDIR"/*.fq.gz; do
        [ -e "$FILE" ] || continue

        BASENAME=$(basename "$FILE" .fq.gz)
        OUTFILE="${OUTDIR}/${BASENAME}_stats.tsv"

        seqkit stats -aT "$FILE" > "$OUTFILE" || echo "Failed $FILE" | tee -a "$LOGFILE"
	echo "Processing $BASENAME from $INDIR achaved at $(date)" | tee -a "$LOGFILE"
    done
done

echo "All done at $(date)" | tee -a "$LOGFILE"
