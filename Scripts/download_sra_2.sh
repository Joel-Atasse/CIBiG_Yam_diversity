#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err
#SBATCH --array=1-167%10

#########################################################
# Script: download_sra_array.sh
# Description: Parallel SRA download + FASTQ conversion
#########################################################


# -------- HELP FUNCTION --------
usage() {
    echo
    echo "Usage: sbatch download_sra_array.sh <output_dir> <accession_file>"
    echo
    echo "Arguments:"
    echo "  output_dir       Directory for downloads and outputs"
    echo "  accession_file   File containing SRA accessions"
    echo
    echo "Example:"
    echo "  sbatch download_sra_array.sh results sra_list.txt"
    echo
    exit 1
}

# -------- CHECK ARGUMENTS --------
if [ "$#" -ne 2 ]; then
    usage
fi

OUTDIR=$1
SRA_FILE=$2

# -------- CHECK INPUT FILE --------
if [ ! -f "$SRA_FILE" ]; then
    echo "Error: accession file not found: $SRA_FILE"
    exit 1
fi

# -------- PARAMETERS --------
THREADS=${SLURM_CPUS_PER_TASK:-8}

# -------- DIRECTORIES --------
SRADIR=${OUTDIR}/sra
FQDIR=${OUTDIR}/fastq
TMPDIR=${OUTDIR}/tmp
LOGDIR=${OUTDIR}/logs

mkdir -p "$SRADIR" "$FQDIR" "$TMPDIR" "$LOGDIR"

LOGFILE=${LOGDIR}/download.log


# -------- SELECT ACCESSION FOR THIS TASK --------
SRA=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SRA_FILE")

if [ -z "$SRA" ]; then
    echo "No accession found for task ${SLURM_ARRAY_TASK_ID}"
    exit 1
fi

echo "===================================" | tee -a "$LOGFILE"
echo "Task ID: $SLURM_ARRAY_TASK_ID" | tee -a "$LOGFILE"
echo "Processing: $SRA" | tee -a "$LOGFILE"
echo "Node: $(hostname)" | tee -a "$LOGFILE"
echo "Start time: $(date)" | tee -a "$LOGFILE"


# -------- MODULE ----------
module load sratoolkit/3.0.1



# -------- DOWNLOAD --------
if prefetch "$SRA" --output-directory "$SRADIR" >> "$LOGFILE" 2>&1
then

    # -------- CONVERT TO FASTQ --------
    fasterq-dump "$SRADIR/$SRA/$SRA.sra" \
        --threads "$THREADS" \
        --split-files \
        --outdir "$FQDIR" \
        --temp "$TMPDIR" \
        --mem 16G \
        --progress >> "$LOGFILE" 2>&1

    # -------- COMPRESS FASTQ --------
    pigz -p "$THREADS" "$FQDIR"/${SRA}*.fastq

    # -------- VERIFY --------
    if ls "$FQDIR"/${SRA}*.fastq.gz 1> /dev/null 2>&1
    then
        echo "SUCCESS: $SRA completed at $(date)" | tee -a "$LOGFILE"
    else
        echo "ERROR: FASTQ not produced for $SRA" | tee -a "$LOGFILE"
    fi

    # -------- CLEANUP --------
    rm -f "$SRADIR/$SRA/$SRA.sra"

else
    echo "ERROR downloading $SRA" | tee -a "$LOGFILE"
fi


echo "Cleaning temporary files..." | tee -a "$LOGFILE"
rm -rf "$TMPDIR"

echo "Finished $SRA at $(date)" | tee -a "$LOGFILE"



