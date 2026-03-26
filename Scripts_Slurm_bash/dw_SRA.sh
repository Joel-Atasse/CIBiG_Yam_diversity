#!/bin/bash
#SBATCH --job-name=dwSRA
#SBATCH --output=logs/dwSRA_%A_%a.out
#SBATCH --error=logs/dwSRA_%A_%a.err
#SBATCH --nodelist=node03
# deactivate SBATCH --time=48:00:00
#SBATCH --cpus-per-task=3
#SBATCH --mem=32G
#SBATCH --partition=normal
#SBATCH --array=1-4%2


# =====================================================================================
#
#	 This script takes two arguments, download SRA archive and convert to FASTQ
#
# =====================================================================================


# Load modules
module load bioinfo-wave
module load sratoolkit/3.0.1

# Help
usage() {
    echo " ====================== WARNING ====================="
    echo
    echo  "Argument missing ..."
    echo
    echo  "USAGE: $0 <output_dir> <accession_file>"
    echo
    echo "====================================================="
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
MEMORY=16G

SRADIR=${OUTDIR}/sra
FQDIR=${OUTDIR}/fastq
TMPDIR=${OUTDIR}/tmp
LOGDIR=${OUTDIR}/logs

mkdir -p "$SRADIR" "$FQDIR" "$TMPDIR" "$LOGDIR"

#LOGFILE=${LOGDIR}/download.log
SUCCESSFILE=${LOGDIR}/success.log
ERRORFILE=${LOGDIR}/error.log


echo "===== SRA Download started: $(date) ====="


# Record start time
START_TIME=$(date +%s)


# Get SRA accession list
mapfile -t FILES < "$SRAFILE"		# readarray, -t reads each line into the array 
f=${FILES[$SLURM_ARRAY_TASK_ID-1]}


if prefetch "$f" --output-directory "$SRADIR"; then
        TMP_SAMPLE=${TMPDIR}/${f}
        mkdir -p "$TMP_SAMPLE"

	fasterq-dump "$SRADIR/$f/$f.sra" \
		--threads "$SLURM_CPUS_PER_TASK" \
        	--split-files \
        	--outdir "$FQDIR" \
        	--temp "$TMP_SAMPLE" \
        	--mem "$MEMORY" \
        	--progress 

	# Compress
	gzip -f "$FQDIR"/${f}*.fastq

	if ls "$FQDIR"/${f}*.fastq.gz; then
        	ls "$FQDIR"/${f}*.fastq.gz >> "$SUCCESSFILE"
	        echo "Success: $f completed at $(date)"
 
        else
	        echo "Error: No FASTQ produced for $f" >> "$ERRORFILE"
        fi

	# Remove  SRA file to free space
	rm -f "$SRADIR/$f/$f.sra"
	rm -rf "$TMP_SAMPLE"

else
	echo "Error downloading $f at $(date)" >> "$ERRORFILE"
fi

echo "All done at $(date)"
