#!/bin/bash
#SBATCH --job-name=QC
#SBATCH --output=qc_%j.out
#SBATCH --error=qc_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --partition=normal


WORKDIR="/scratch/dansouk/yam_dir"

RDIR_1="$WORKDIR/Data/Africrop/renamed_fastq"
RDIR_2="$WORKDIR/Data/BFcrop/fastq"
RDIR_3="$WORKDIR/Data/BFcrop/fastq_trim"
RDIR_4="$WORKDIR/Data/BFcrop/merge"
RDIR_5="$WORKDIR/Data/BFcrop/merge_trim"

OUTDIR_1="$WORKDIR/Reads_QC/Africrop"
OUTDIR_2="$WORKDIR/Reads_QC/BFcrop"
OUTDIR_3="$WORKDIR/Reads_QC/BFcrop_trim"
OUTDIR_4="$WORKDIR/Reads_QC/BFcrop_merge"
OUTDIR_5="$WORKDIR/Reads_QC/BFcrop_merge_trim"

WEB="$WORKDIR/Reads_QC/Web_all"
LOG="$WORKDIR/Reads_QC/logs/qc.log"
TRHEADS=16

echo "===== Pipeline started: $(date) =====" | tee -a "$LOG"


mkdir -p "$OUTDIR_1" "$OUTDIR_2" "$OUTDIR_3" "$OUTDIR_4" "$OUTDIR_5" "$WEB"


inputs=("$RDIR_1" "$RDIR_2" "$RDIR_3" "$RDIR_4" "$RDIR_5")
outputs=("$OUTDIR_1" "$OUTDIR_2" "$OUTDIR_3" "$OUTDIR_4" "$OUTDIR_5")
names=("Africrop" "BFcrop" "BFcrop_trim" "BFcrop_merge" "BFcrop_merge_trim")


# Load module
module load FastQC/0.12.1
module load MultiQC/1.9

for i in "${!inputs[@]}"
do
    input=${inputs[$i]}
    output=${outputs[$i]}
    name=${names[$i]}

    echo "Processing sample: $name" | tee -a "$LOG"

    fastqc -t "$THREADS" "$input"/*.gz -o "$output/"
    multiqc "$output/" -o "$output/"

    #mv "$output"/*_report.html "$WEB/${name}_report.html"
    # Move HTML report safely
    report=$(ls "$output"/*_report.html 2>/dev/null || true)
    if [[ -n "$report" ]]; then
        mv "$report" "$WEB/${name}_report.html"
    else
        echo "Warning: No MultiQC report found for $name" | tee -a "$LOG"
    fi

 
    echo "Finished sample: $name at $(date)" >> "$LOG"
    echo "-----------------------------------" >> "$LOG" 

done


echo "===== Pipeline finished: $(date) =====" | tee -a "$LOG"
