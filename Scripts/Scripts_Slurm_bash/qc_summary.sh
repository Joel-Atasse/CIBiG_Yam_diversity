#!/bin/bash

# Variables
WORKDIR="/scratch/dansouk/yam_dir"
RDIR_1="$WORKDIR/QC_stat/Africrop_stat"
RDIR_2="$WORKDIR/QC_stat/BFcrop_stat"
RDIR_3="$WORKDIR/QC_stat/BFcrop_trim_stat"
RDIR_4="$WORKDIR/QC_stat/BFcrop_merge_stat"
RDIR_5="$WORKDIR/QC_stat/BFcrop_merge_trim_stat"
RES="$WORKDIR/QC_stat/Summary"

mkdir -p "$RES"


cd "$RDIR_1"
(head -n 1 "$RDIR_1"/A3009_R1_stats.tsv && tail -n +2 -q *_stats.tsv) > "$RES"/Africrop.tsv

cd "$RDIR_2"
(head -n 1 "$RDIR_2"/CR5858_L5_R1_stats.tsv && tail -n +2 -q *_stats.tsv) > "$RES"/BFcrop.tsv

cd "$RDIR_3"
(head -n 1 "$RDIR_3"/CR5858_L5_R1_stats.tsv && tail -n +2 -q *_stats.tsv) > "$RES"/BFcrop_trim.tsv

cd "$RDIR_4"
(head -n 1 "$RDIR_4"/CR5858_R1_stats.tsv && tail -n +2 -q *_stats.tsv) > "$RES"/BFcrop_merge.tsv

cd "$RDIR_5"
(head -n 1 "$RDIR_5"/CR5858_R1_stats.tsv && tail -n +2 -q *_stats.tsv) > "$RES"/BFcrop_merge_trim.tsv
