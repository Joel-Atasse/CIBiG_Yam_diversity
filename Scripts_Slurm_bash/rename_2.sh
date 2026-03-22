#!/bin/bash

SRC="reads"
DEST="reads_renamed"

awk -F',' 'NR>1 {print $1","$2}' africrop.csv | while IFS=',' read -r newname oldname
do
    if [ -f "$SRC/${oldname}_R1.fastq.gz" ]; then
        cp "$SRC/${oldname}_R1.fastq.gz" "$DEST/${newname}_R1.fastq.gz"
    fi

    if [ -f "$SRC/${oldname}_R2.fastq.gz" ]; then
        cp "$SRC/${oldname}_R2.fastq.gz" "$DEST/${newname}_R2.fastq.gz"
    fi
done

























