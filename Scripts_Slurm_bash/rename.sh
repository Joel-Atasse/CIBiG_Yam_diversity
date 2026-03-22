#!/bin/bash

WORKDIR="/scratch/dansouk/yam_dir"
SRC="$WORKDIR/Data/Africrop/fastq"
DEST="$WORKDIR/Data/Africrop/renamed_fastq"
mkdir -p $DEST


awk -F';' -v src="$SRC" -v dest="$DEST" 'NR>1 {
    r1_src = src "/" $2 "_1.fastq.gz"
    r1_dest = dest "/" $1 "_R1.fastq.gz"
    r2_src = src "/" $2 "_2.fastq.gz"
    r2_dest = dest "/" $1 "_R2.fastq.gz"

    if (system("[ -f \"" r1_src "\" ]") == 0 && system("[ -f \"" r2_src "\" ]") == 0) {
        print "cp \"" r1_src "\" \"" r1_dest "\""
        print "cp \"" r2_src "\" \"" r2_dest "\""
    } else {
        print "Missing files for sample " $1 > "/dev/stderr"
    }
}' "$WORKDIR/Metadata/SRA_name.csv" | sh

