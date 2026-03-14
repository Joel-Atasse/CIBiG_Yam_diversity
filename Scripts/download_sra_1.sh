#!/bin/bash

#########################################################
# Script: download_sra.sh
# Description: Download SRA archives and convert to FASTQ
#########################################################

# -------- HELP FUNCTION --------
usage() {
    echo "Usage: $0 <output_dir> <accession_file>"
    echo
    echo "Arguments:"
    echo "  output_dir       Directory where downloads and logs will be stored"
    echo "  accession_file   File containing SRA accessions (one per line)"
    echo
    echo "Example:"
    echo "  $0 results_sra sra_list.txt"
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
    echo "Error: Input file '$SRA_FILE' not found"
    exit 1
fi

# -------- PARAMETERS --------
THREADS=8

# -------- DIRECTORIES --------
SRADIR=${OUTDIR}/sra
FQDIR=${OUTDIR}/fastq
TMPDIR=${OUTDIR}/tmp
LOGDIR=${OUTDIR}/logs

mkdir -p "$SRADIR" "$FQDIR" "$TMPDIR" "$LOGDIR"

LOGFILE=${LOGDIR}/download.log
SUCCESSFILE=${LOGDIR}/success.log
ERRORFILE=${LOGDIR}/error.log

echo "===================================" | tee -a "$LOGFILE"
echo "SRA Download started: $(date)" | tee -a "$LOGFILE"
echo "Input file: $SRA_FILE" | tee -a "$LOGFILE"
echo "===================================" | tee -a "$LOGFILE"

# -------- LOOP --------
while read -r SRA
do

    [ -z "$SRA" ] && continue

    echo "Processing $SRA" | tee -a "$LOGFILE"

    # Download
    if prefetch "$SRA" --output-directory "$SRADIR" >> "$LOGFILE" 2>&1
    then

        # Convert to FASTQ
        fasterq-dump "$SRADIR/$SRA/$SRA.sra" \
            --threads "$THREADS" \
            --split-files \
            --outdir "$FQDIR" \
            --temp "$TMPDIR" \
            --mem 8G \
            --progress >> "$LOGFILE" 2>&1

        # Compress
        gzip -f "$FQDIR"/${SRA}*.fastq

        # Verify output
        if ls "$FQDIR"/${SRA}*.fastq.gz 1> /dev/null 2>&1
        then
            ls "$FQDIR"/${SRA}*.fastq.gz >> "$SUCCESSFILE"
            echo "SUCCESS: $SRA completed at $(date)" | tee -a "$LOGFILE"
        else
            echo "ERROR: No FASTQ produced for $SRA" >> "$ERRORFILE"
        fi

        # Cleanup SRA file
        rm -f "$SRADIR/$SRA/$SRA.sra"

    else
        echo "ERROR downloading $SRA at $(date)" >> "$ERRORFILE"
    fi

done < "$SRA_FILE"


echo "Cleaning temporary files..." | tee -a "$LOGFILE"
rm -rf "$TMPDIR"

echo "Pipeline completed successfully at $(date)" | tee -a "$LOGFILE"

echo "===================================" | tee -a "$LOGFILE"
echo "Download finished: $(date)" | tee -a "$LOGFILE"
echo "===================================" | tee -a "$LOGFILE"

