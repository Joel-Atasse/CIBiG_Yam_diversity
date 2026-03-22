#!/bin/bash
#SBATCH --job-name=sra_dwl_ll
#SBATCH --output=sra_dwl_%j.out
#SBATCH --error=sra_dwl_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=12
#SBATCH --mem=64G
#SBATCH --partition=short


# ----------------------------------------------------------------------------
# This script takes two arguments, download SRA archive and convert to FASTQ
# ----------------------------------------------------------------------------


# Load modules
module load bioinfo-wave
module load sratoolkit/3.0.1


# Help
usage() {
    echo "Warning: Argument missing ............."
    echo "Usage: $0 <output_dir> <accession_file>"
    exit 1
}


# Input check
if [ "$#" -ne 2 ]; then
    usage
fi


# Assign arguments and check
OUTDIR=$1
SRAFILE=$2

if [ ! -f "$SRAFILE" ]; then
    echo "Error: Input file '$SRAFILE' not found"
    exit 1
fi


# Variables
THREADS=3
MEMORY=8G

SRADIR=${OUTDIR}/sra
FQDIR=${OUTDIR}/fastq
TMPDIR=${OUTDIR}/tmp
LOGDIR=${OUTDIR}/logs

mkdir -p "$SRADIR" "$FQDIR" "$TMPDIR" "$LOGDIR"

LOGFILE=${LOGDIR}/download.log
SUCCESSFILE=${LOGDIR}/success.log
ERRORFILE=${LOGDIR}/error.log


echo "===== SRA Download started: $(date) =====" | tee -a "$LOGFILE"


# Record start time
START_TIME=$(date +%s)


MAX_JOBS=4

while read -r f; do

{
    echo "Archive $f" | tee -a "$LOGFILE"

    if prefetch "$f" --output-directory "$SRADIR" >> "$LOGFILE" 2>&1
    then

        TMP_SAMPLE=${TMPDIR}/${f}
        mkdir -p "$TMP_SAMPLE"

        fasterq-dump "$SRADIR/$f/$f.sra" \
            --threads "$THREADS" \
            --split-files \
            --outdir "$FQDIR" \
            --temp "$TMP_SAMPLE" \
            --mem "$MEMORY" \
            --progress >> "$LOGFILE" 2>&1

        # Compress
        gzip -f "$FQDIR"/${f}*.fastq

        if ls "$FQDIR"/${f}*.fastq.gz 1> /dev/null 2>&1
        then
            ls "$FQDIR"/${f}*.fastq.gz >> "$SUCCESSFILE"
            echo "Success: $f completed at $(date)" >> "$LOGFILE"
        else
            echo "Error: No FASTQ produced for $f" >> "$ERRORFILE"
        fi

        # Remove  SRA file to free space
        rm -f "$SRADIR/$f/$f.sra"
        rm -rf "$TMP_SAMPLE"

    else
        echo "Error downloading $f at $(date)" >> "$ERRORFILE"
    fi

} &

# Limit number of parallel jobs
while [ "$(jobs -r | wc -l)" -ge "$MAX_JOBS" ]; do
    sleep 2
done

done < "$SRAFILE"

wait
