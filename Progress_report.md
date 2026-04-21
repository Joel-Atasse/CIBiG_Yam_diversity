---
title: CIBiG_2025 Supervised internships progress
subtitle: "**Assessing genetic diversity in yams (*Dioscorea spp*.): a comparison of Mash and SNP-based approaches**"
author: "Dansou-kodjo K.A."
date: "March-April 2026"
---


## 1. First online meeting: 02-26-2026

- Overview of the research project and Objectives by the Supervisor;
- Sory’s progress with his project;
- Tasks to complete during the week (before the next meeting).


## 2. Literature Review (in progress)

A literature review on yams (*Dioscorea* spp.) and on the methodological and analytical tools required for the successful implementation of the project


## 3. Data acquisition

- Africrop sequences were downloaded on NCBI based on a list of SRA accession (download_sra_1.sh)

```
module load sratoolkit/3.0.1

# Download SRA
prefetch "$SRA" --output-directory "$SRADIR" >> "$LOGFILE" 2>&1

# Convert
fasterq-dump "$SRADIR/$SRA/$SRA.sra" \
	--threads "$THREADS" \
        --split-files \
        --outdir "$FQDIR" \
        --temp "$TMPDIR" \
        --mem 8G \
	--progress >> "$LOGFILE" 2>&1

# Compress
gzip -f "$FQDIR"/${SRA}*.fastq
```

- BFcrop were available on the WAVE Cluster and were imported into the working directory using rsync -ravz --progress

- Reference genome
Yam reference genomes **TDr96x99_v1.0** (GCA_002260605.1) and **TDr96_F1_v2**  (GCF_009730915.1) were also downloaded from NCBI 

```
# Download reference genome
module load ncbi-datasets/18.10.2 
datasets download genome accession GCA_002260605.1 --include gff3,rna,cds,protein,genome,seq-report
datasets download genome accession GCF_009730915.1 --include gff3,rna,cds,protein,genome,seq-report	
```


## 4. Data description

- Cleaning and Quality Control
Only BFcrop data were submitted to data cleaning bases on Scarcelli *et al*. (2019) parameters. 

```
## Load module
module load FastQC/0.12.1 
module load MultiQC/1.9 

## Quality check
fastqc "$RAWDIR"/*.gz -o "$FQDIR/"
multiqc "$FQDIR/" -o "$FQDIR/"

# Trimming
## Load module
module load cutadapt/4.5

ADAPT_R1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
ADAPT_R2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

cd "$RAWDIR"

for sample in $(ls -1 *.fq.gz | cut -d_ -f1-2); do
     cutadapt \
    -a $ADAPT_R1 \
    -A $ADAPT_R2 \
    -q 30,30 \
    -m 35 \
    -o "$TRIMDIR/${sample}_R1.trimmed.fq.gz" \
    -p "$TRIMDIR/${sample}_R2.trimmed.fq.gz" \
    "$RAWDIR/${sample}_R1.fq.gz" \
    "$RAWDIR/${sample}_R2.fq.gz" \
    --cores 8     
done
```
BFcrop data were merged and trimmed. The quality of Africrop data were checked and then renamed using a list of samples name (rename_fastq.sh)

```
awk -F';' -v src="$SRC" -v dest="$DEST" 'NR>1 {
    # Construire les chemins source et destination
    src1 = src "/" $2 "_1.fastq.gz"
    src2 = src "/" $2 "_2.fastq.gz"
    dest1 = dest "/" $1 "_R1.fastq.gz"
    dest2 = dest "/" $1 "_R2.fastq.gz"

    # Vérifier si le fichier source existe avant de copier
    if (system("[ -f \"" src1 "\" ]") == 0) {
	print "cp " src1 " " dest1
    } else {
	print "# WARNING: " src1 " does not exist"
    }

    if (system("[ -f \"" src2 "\" ]") == 0) {
	print "cp " src2 " " dest2
    } else {
	print "# WARNING: " src2 " does not exist"
    }
}' "$CSV_FILE" | bash
```


## 5. Sequence metric statistics

Sequence metric statistics were performed on raw data as well as on trimmed data

```	
# Load module
module load seqkit/2.11.0 

seqkit stats -aT "$RAWDIR/${f}.fq.gz" > "$STATDIR/${f}_stats.tsv"		
```

The output of seqkit stats were exported and analyzed in **R**


## 6. Second online meeting: 03-05-2026

- Presentation of Project Background and Context;
- Presentation of Mind map and workflow;
- Présentation of Results of the descriptive analysis and statistics of data;
- Observations of supervisors: Review the presentation and structuring of the statistics; also review the workflow and produce the distribution map of the samples


## 7 Sequence metric statistics

- The output of seqkit stats were merged (merge_stat.sh) before exported and analyzed in **r**

```
cd "$STATDIR"
(head -n 1 $STATDIR/CR5858_L5_R1_stats.tsv && tail -n +2 -q *_stats.tsv) > ../merged_BF.tsv
```

**Table:** Africrop 

| sample    | num_seqs | sum_len    | min_len | avg_len | max_len | Q30 | AvgQual | GC    | depth            |
|-----------|----------|------------|---------|---------|---------|-----|---------|-------|------------------|
| CR4991_R1 | 51847955 | 6860176524 | 35      | 132.3   | 144     | 94  | 27.02   | 37.36 | 11.742856083533  |
| CR4991_R2 | 51847955 | 7124817136 | 35      | 137.4   | 150     | 90  | 24.76   | 37.33 | 12.1958526805888 |
| CR5031_R1 | 42633462 | 5549284144 | 35      | 130.2   | 144     | 94  | 27.13   | 39.9  | 9.49894581307771 |
| CR5031_R2 | 42633462 | 5766974157 | 35      | 135.3   | 150     | 90  | 24.82   | 39.91 | 9.87157507189319 |
| A67_R1    | 39194826 | 3653727169 | 35      | 93.2    | 94      | 96  | 30.96   | 35.16 | 6.25424027559055 |
| A67_R2    | 39194826 | 3882832966 | 35      | 99.1    | 100     | 96  | 30.73   | 34.95 | 6.64641041766518 |
| CR4952_R1 | 38443360 | 5052325497 | 35      | 131.4   | 144     | 94  | 27.1    | 41.15 | 8.64828054946936 |
| CR4952_R2 | 38443360 | 5253638618 | 35      | 136.7   | 150     | 91  | 25.04   | 41.03 | 8.99287678534748 |
| A5059_R1  | 38104250 | 5047088675 | 35      | 132.5   | 144     | 94  | 27.13   | 39.78 | 8.63931645840466 |
| A5059_R2  | 38104250 | 5232359903 | 35      | 137.3   | 150     | 89  | 24.21   | 39.73 | 8.95645310338925 |
| CR4967_R1 | 35298447 | 4666700809 | 35      | 132.2   | 144     | 94  | 26.96   | 37.55 | 7.98819036117768 |
| CR4967_R2 | 35298447 | 4840394985 | 35      | 137.1   | 150     | 89  | 24.36   | 37.36 | 8.28551007360493 |
| A5048_R1  | 34971061 | 4606023188 | 35      | 131.7   | 144     | 94  | 27.21   | 37.88 | 7.88432589524136 |
| A5048_R2  | 34971061 | 4783885675 | 35      | 136.8   | 150     | 90  | 24.82   | 37.71 | 8.18878068298528 |
| CR869_R1  | 34741499 | 3236980744 | 35      | 93.2    | 94      | 95  | 30.58   | 35.27 | 5.54087768572407 |
| CR869_R2  | 34741499 | 3445024716 | 35      | 99.2    | 100     | 96  | 31.04   | 35.01 | 5.89699540568299 |
| P599_R1   | 34469474 | 3214161424 | 35      | 93.2    | 94      | 96  | 30.88   | 34.12 | 5.50181688462855 |
| P599_R2   | 34469474 | 3416702824 | 35      | 99.1    | 100     | 96  | 30.8    | 34.04 | 5.84851561793906 |
| A537_R1   | 32374854 | 3017128922 | 35      | 93.2    | 94      | 95  | 30.67   | 39.8  | 5.16454796644985 |
| A537_R2   | 32374854 | 3205361523 | 35      | 99      | 100     | 96  | 30.55   | 39.89 | 5.48675371961657 |


**Table:** BFcrop
| sample       | num_seqs | sum_len     | min_len | avg_len | max_len | Q30 | AvgQual | GC    | depth            |
|--------------|----------|-------------|---------|---------|---------|-----|---------|-------|------------------|
| CR5858_L8_R1 | 93870835 | 14080625250 | 150     | 150     | 150     | 93  | 23.85   | 44.98 | 24.1024054262239 |
| CR5858_L8_R2 | 93870835 | 14080625250 | 150     | 150     | 150     | 94  | 25.7    | 45.36 | 24.1024054262239 |
| CR5859_L8_R1 | 93590837 | 14038625550 | 150     | 150     | 150     | 93  | 23.93   | 45.2  | 24.030512752482  |
| CR5859_L8_R2 | 93590837 | 14038625550 | 150     | 150     | 150     | 94  | 25.83   | 45.51 | 24.030512752482  |
| CR5863_L8_R1 | 85708735 | 12856310250 | 150     | 150     | 150     | 93  | 24.81   | 45.99 | 22.0066933413215 |
| CR5863_L8_R2 | 85708735 | 12856310250 | 150     | 150     | 150     | 93  | 25.16   | 46.19 | 22.0066933413215 |
| CR5861_L8_R1 | 82942040 | 12441306000 | 150     | 150     | 150     | 94  | 25.07   | 45.87 | 21.2963129065389 |
| CR5861_L8_R2 | 82942040 | 12441306000 | 150     | 150     | 150     | 94  | 26.08   | 46.09 | 21.2963129065389 |
| CR5858_L5_R1 | 82805814 | 12420872100 | 150     | 150     | 150     | 93  | 24.27   | 44.97 | 21.2613353303663 |
| CR5858_L5_R2 | 82805814 | 12420872100 | 150     | 150     | 150     | 94  | 26.36   | 45.39 | 21.2613353303663 |
| CR5859_L5_R1 | 82736026 | 12410403900 | 150     | 150     | 150     | 93  | 24.42   | 45.21 | 21.2434164669634 |
| CR5859_L5_R2 | 82736026 | 12410403900 | 150     | 150     | 150     | 94  | 26.42   | 45.55 | 21.2434164669634 |
| CR5860_L8_R1 | 81162253 | 12174337950 | 150     | 150     | 150     | 93  | 23.84   | 46.24 | 20.8393323348168 |
| CR5860_L8_R2 | 81162253 | 12174337950 | 150     | 150     | 150     | 92  | 24.3    | 46.35 | 20.8393323348168 |
| CR5862_L8_R1 | 78303386 | 11745507900 | 150     | 150     | 150     | 93  | 24.39   | 45.05 | 20.1052856898323 |
| CR5862_L8_R2 | 78303386 | 11745507900 | 150     | 150     | 150     | 93  | 25.42   | 44.88 | 20.1052856898323 |
| CR5863_L5_R1 | 74629174 | 11194376100 | 150     | 150     | 150     | 95  | 26.75   | 46.05 | 19.1618899349538 |
| CR5863_L5_R2 | 74629174 | 11194376100 | 150     | 150     | 150     | 94  | 25.89   | 46.26 | 19.1618899349538 |
| CR5861_L5_R1 | 73500901 | 11025135150 | 150     | 150     | 150     | 95  | 26.39   | 45.89 | 18.872192998973  |
| CR5861_L5_R2 | 73500901 | 11025135150 | 150     | 150     | 150     | 95  | 26.52   | 46.13 | 18.872192998973  |
| CR5862_L5_R1 | 70390799 | 10558619850 | 150     | 150     | 150     | 94  | 24.32   | 45.01 | 18.0736389079083 |
| CR5862_L5_R2 | 70390799 | 10558619850 | 150     | 150     | 150     | 94  | 26.21   | 44.94 | 18.0736389079083 |
| CR5860_L5_R1 | 70013361 | 10502004150 | 150     | 150     | 150     | 93  | 23.96   | 46.21 | 17.9767274049983 |
| CR5860_L5_R2 | 70013361 | 10502004150 | 150     | 150     | 150     | 93  | 25.06   | 46.4  | 17.9767274049983 |
| CR5859_L6_R1 | 19236385 | 2885457750  | 150     | 150     | 150     | 94  | 24.29   | 45.17 | 4.93916081821294 |
| CR5859_L6_R2 | 19236385 | 2885457750  | 150     | 150     | 150     | 94  | 26.12   | 45.51 | 4.93916081821294 |
| CR5858_L6_R1 | 19057539 | 2858630850  | 150     | 150     | 150     | 93  | 24.18   | 44.94 | 4.89324007189319 |
| CR5858_L6_R2 | 19057539 | 2858630850  | 150     | 150     | 150     | 94  | 26.07   | 45.37 | 4.89324007189319 |
| CR5863_L6_R1 | 17385820 | 2607873000  | 150     | 150     | 150     | 95  | 26.46   | 46.01 | 4.46400718931873 |
| CR5863_L6_R2 | 17385820 | 2607873000  | 150     | 150     | 150     | 94  | 25.6    | 46.22 | 4.46400718931873 |
| CR5861_L6_R1 | 17103591 | 2565538650  | 150     | 150     | 150     | 95  | 26.16   | 45.88 | 4.39154168093119 |
| CR5861_L6_R2 | 17103591 | 2565538650  | 150     | 150     | 150     | 95  | 26.37   | 46.12 | 4.39154168093119 |
| CR5862_L6_R1 | 16540966 | 2481144900  | 150     | 150     | 150     | 94  | 24.42   | 45.01 | 4.24708130777131 |
| CR5862_L6_R2 | 16540966 | 2481144900  | 150     | 150     | 150     | 94  | 25.93   | 44.9  | 4.24708130777131 |
| CR5860_L6_R1 | 15965924 | 2394888600  | 150     | 150     | 150     | 94  | 23.95   | 46.24 | 4.09943272851763 |
| CR5860_L6_R2 | 15965924 | 2394888600  | 150     | 150     | 150     | 93  | 24.73   | 46.39 | 4.09943272851763 |


**Table:** BFcrop trimmed

| sample       | num_seqs | sum_len     | min_len | avg_len | max_len | Q30 | AvgQual | GC    | depth            |
|--------------|----------|-------------|---------|---------|---------|-----|---------|-------|------------------|
| CR5858_L8_R1 | 92848943 | 11020291814 | 35      | 118.7   | 150     | 98  | 32.35   | 43.11 | 18.8639024546388 |
| CR5858_L8_R2 | 92848943 | 11024126585 | 35      | 118.7   | 150     | 99  | 33.76   | 43.12 | 18.8704665953441 |
| CR5859_L8_R1 | 92602621 | 11121887610 | 35      | 120.1   | 150     | 98  | 32.22   | 43.53 | 19.0378083019514 |
| CR5859_L8_R2 | 92602621 | 11122381140 | 35      | 120.1   | 150     | 98  | 33.47   | 43.53 | 19.038653098254  |
| CR5863_L8_R1 | 84838705 | 10229921027 | 35      | 120.6   | 150     | 98  | 31.98   | 44.39 | 17.5109911451558 |
| CR5863_L8_R2 | 84838705 | 10229039879 | 35      | 120.6   | 150     | 98  | 33.27   | 44.38 | 17.5094828466279 |
| CR5861_L8_R1 | 82144191 | 10261607600 | 35      | 124.9   | 150     | 98  | 32.08   | 44.58 | 17.5652304005478 |
| CR5861_L8_R2 | 82144191 | 10258447178 | 35      | 124.9   | 150     | 98  | 32.89   | 44.57 | 17.559820571722  |
| CR5858_L5_R1 | 82059546 | 9736146892  | 35      | 118.6   | 150     | 98  | 33.33   | 43.12 | 16.6657769462513 |
| CR5858_L5_R2 | 82059546 | 9735852882  | 35      | 118.6   | 150     | 99  | 33.65   | 43.13 | 16.665273676823  |
| CR5859_L5_R1 | 82002936 | 9855867741  | 35      | 120.2   | 150     | 98  | 33.13   | 43.57 | 16.870708218076  |
| CR5859_L5_R2 | 82002936 | 9850609577  | 35      | 120.1   | 150     | 98  | 33.32   | 43.55 | 16.8617075950017 |
| CR5860_L8_R1 | 80367206 | 9655199947  | 35      | 120.1   | 150     | 98  | 32.05   | 44.55 | 16.527216615885  |
| CR5860_L8_R2 | 80367206 | 9655731843  | 35      | 120.1   | 150     | 98  | 33.41   | 44.54 | 16.5281270849024 |
| CR5862_L8_R1 | 77563238 | 9571716194  | 35      | 123.4   | 150     | 98  | 31.84   | 43.04 | 16.3843139233139 |
| CR5862_L8_R2 | 77563238 | 9571048559  | 35      | 123.4   | 150     | 98  | 33.11   | 43.04 | 16.3831711040739 |
| CR5863_L5_R1 | 74010033 | 8927264660  | 35      | 120.6   | 150     | 98  | 32.95   | 44.45 | 15.2811788086272 |
| CR5863_L5_R2 | 74010033 | 8922612452  | 35      | 120.6   | 150     | 98  | 33.13   | 44.44 | 15.2732154262239 |
| CR5861_L5_R1 | 72895072 | 9111383423  | 35      | 125     | 150     | 98  | 32.95   | 44.6  | 15.5963427302294 |
| CR5861_L5_R2 | 72895072 | 9103752950  | 35      | 124.9   | 150     | 98  | 32.65   | 44.6  | 15.5832813248887 |
| CR5862_L5_R1 | 69834317 | 8625452669  | 35      | 123.5   | 150     | 98  | 32.82   | 43.07 | 14.7645543803492 |
| CR5862_L5_R2 | 69834317 | 8620998181  | 35      | 123.4   | 150     | 98  | 33.01   | 43.07 | 14.7569294436837 |
| CR5860_L5_R1 | 69477042 | 8354676518  | 35      | 120.3   | 150     | 98  | 33.14   | 44.6  | 14.3010553200959 |
| CR5860_L5_R2 | 69477042 | 8350170433  | 35      | 120.2   | 150     | 98  | 33.38   | 44.58 | 14.2933420626498 |
| CR5859_L6_R1 | 19072152 | 2298096649  | 35      | 120.5   | 150     | 98  | 33.09   | 43.56 | 3.933749827114   |
| CR5859_L6_R2 | 19072152 | 2296994239  | 35      | 120.4   | 150     | 99  | 33.49   | 43.54 | 3.93186278500514 |
| CR5858_L6_R1 | 18900118 | 2248472496  | 35      | 119     | 150     | 98  | 33.32   | 43.13 | 3.84880605272167 |
| CR5858_L6_R2 | 18900118 | 2248516128  | 35      | 119     | 150     | 99  | 33.83   | 43.13 | 3.84888073947278 |
| CR5863_L6_R1 | 17246384 | 2086347546  | 35      | 121     | 150     | 98  | 32.92   | 44.44 | 3.57128987675454 |
| CR5863_L6_R2 | 17246384 | 2085419780  | 35      | 120.9   | 150     | 98  | 33.29   | 44.42 | 3.56970178021226 |
| CR5861_L6_R1 | 16975328 | 2126864037  | 35      | 125.3   | 150     | 98  | 32.98   | 44.61 | 3.64064367853475 |
| CR5861_L6_R2 | 16975328 | 2125217969  | 35      | 125.2   | 150     | 98  | 32.88   | 44.6  | 3.6378260338925  |
| CR5862_L6_R1 | 16417954 | 2034454748  | 35      | 123.9   | 150     | 98  | 32.84   | 43.06 | 3.48246276617597 |
| CR5862_L6_R2 | 16417954 | 2033484772  | 35      | 123.9   | 150     | 98  | 33.21   | 43.06 | 3.48080241698049 |
| CR5860_L6_R1 | 15848502 | 1910509044  | 35      | 120.5   | 150     | 98  | 33.08   | 44.62 | 3.27029963026361 |
| CR5860_L6_R2 | 15848502 | 1909568958  | 35      | 120.5   | 150     | 99  | 33.52   | 44.59 | 3.26869044505306 |


**Table:** BFcrop merged

| sample    | num_seqs  | sum_len     | min_len | avg_len | max_len | Q30 | AvgQual | GC    | depth            |
|-----------|-----------|-------------|---------|---------|---------|-----|---------|-------|------------------|
| CR5858_R1 | 195734188 | 29360128200 | 150     | 150     | 150     | 93  | 24.05   | 44.97 | 50.2569808284834 |
| CR5858_R2 | 195734188 | 29360128200 | 150     | 150     | 150     | 94  | 26      | 45.37 | 50.2569808284834 |
| CR5859_R1 | 195563248 | 29334487200 | 150     | 150     | 150     | 93  | 24.16   | 45.2  | 50.2130900376583 |
| CR5859_R2 | 195563248 | 29334487200 | 150     | 150     | 150     | 94  | 26.1    | 45.53 | 50.2130900376583 |
| CR5863_R1 | 177723729 | 26658559350 | 150     | 150     | 150     | 94  | 25.68   | 46.01 | 45.632590465594  |
| CR5863_R2 | 177723729 | 26658559350 | 150     | 150     | 150     | 93  | 25.5    | 46.22 | 45.632590465594  |
| CR5861_R1 | 173546532 | 26031979800 | 150     | 150     | 150     | 95  | 25.69   | 45.88 | 44.560047586443  |
| CR5861_R2 | 173546532 | 26031979800 | 150     | 150     | 150     | 94  | 26.29   | 46.11 | 44.560047586443  |
| CR5860_R1 | 167141538 | 25071230700 | 150     | 150     | 150     | 93  | 23.9    | 46.23 | 42.9154924683328 |
| CR5860_R2 | 167141538 | 25071230700 | 150     | 150     | 150     | 93  | 24.64   | 46.37 | 42.9154924683328 |
| CR5862_R1 | 165235151 | 24785272650 | 150     | 150     | 150     | 93  | 24.36   | 45.03 | 42.4260059055118 |
| CR5862_R2 | 165235151 | 24785272650 | 150     | 150     | 150     | 94  | 25.79   | 44.9  | 42.4260059055118 |


**Table:** BFcrop merged trimmed

| sample    | num_seqs  | sum_len     | min_len | avg_len | max_len | Q30 | AvgQual | GC    | depth            |
|-----------|-----------|-------------|:-------:|---------|---------|-----|---------|-------|------------------|
| CR5858_R1 | 193808607 | 23004911202 |   35    | 118.7   | 150     | 98  | 32.83   | 43.12 | 39.3784854536118 |
| CR5858_R2 | 193808607 | 23008495595 |   35    | 118.7   | 150     | 99  | 33.72   | 43.12 | 39.3846210116399 |
| CR5859_R1 | 193677709 | 23275852000 |   35    | 120.2   | 150     | 98  | 32.66   | 43.55 | 39.8422663471414 |
| CR5859_R2 | 193677709 | 23269984956 |   35    | 120.1   | 150     | 98  | 33.41   | 43.54 | 39.8322234782609 |
| CR5863_R1 | 176095122 | 21243533233 |   35    | 120.6   | 150     | 98  | 32.45   | 44.42 | 36.3634598305375 |
| CR5863_R2 | 176095122 | 21237072111 |   35    | 120.6   | 150     | 98  | 33.21   | 44.41 | 36.352400053064  |
| CR5861_R1 | 172014591 | 21499855060 |   35    | 125     | 150     | 98  | 32.51   | 44.59 | 36.8022168093119 |
| CR5861_R2 | 172014591 | 21487418097 |   35    | 124.9   | 150     | 98  | 32.79   | 44.59 | 36.7809279305033 |
| CR5860_R1 | 165692750 | 19920385509 |   35    | 120.2   | 150     | 98  | 32.57   | 44.58 | 34.0985715662444 |
| CR5860_R2 | 165692750 | 19915471234 |   35    | 120.2   | 150     | 98  | 33.41   | 44.56 | 34.0901595926053 |
| CR5862_R1 | 163815509 | 20231623611 |   35    | 123.5   | 150     | 98  | 32.33   | 43.06 | 34.6313310698391 |
| CR5862_R2 | 163815509 | 20225531512 |   35    | 123.5   | 150     | 98  | 33.07   | 43.06 | 34.6209029647381 |


- Statistical analyses were used to generate the graphs
- The diagram has been revised to improve the clarity and understanding of the workflow.
- A map showing the distribution of the samples was created.


## 8. Third online meeting: 03-13-2026

- Presentation of all was done
- Observations of supervisors:

	- Summarize statistic per sample;
	- Planning a slide to explain the SRA download script;
	- Explain the sample distribution map;
	- Create a git repository and update Markdown file;
	- Planning how mash (MinHash) approach will be conducted;
	- Launch Mash,with few sample with and without reference ;


## 9. Sequence metric statistics per sample

**Table:** BFcrop 

|  Sample   | read_pairs | total_reads | total_bases |      Depth       |
|:---------:|:----------:|:-----------:|:-----------:|:----------------:|
| CR5858_L5 |  82805814  |  165611628  | 24841744200 | 42.5226706607326 |
| CR5858_L6 |  19057539  |  38115078   | 5717261700  | 9.78648014378637 |
| CR5858_L8 |  93870835  |  187741670  | 28161250500 | 48.2048108524478 |
| CR5859_L5 |  82736026  |  165472052  | 24820807800 | 42.4868329339267 |
| CR5859_L6 |  19236385  |  38472770   | 5770915500  | 9.87832163642588 |
| CR5859_L8 |  93590837  |  187181674  | 28077251100 | 48.0610255049641 |
| CR5860_L5 |  70013361  |  140026722  | 21004008300 | 35.9534548099966 |
| CR5860_L6 |  15965924  |  31931848   | 4789777200  | 8.19886545703526 |
| CR5860_L8 |  81162253  |  162324506  | 24348675900 | 41.6786646696337 |
| CR5861_L5 |  73500901  |  147001802  | 22050270300 | 37.7443859979459 |
| CR5861_L6 |  17103591  |  34207182   | 5131077300  | 8.78308336186238 |
| CR5861_L8 |  82942040  |  165884080  | 24882612000 | 42.5926258130777 |


**Table:** BFcrop trimmed

| Sample    | read_pairs | total_reads | total_bases |      Depth       |
|-----------|:----------:|:-----------:|:-----------:|:----------------:|
| CR5858_L5 |  82059546  |  164119092  | 19471999774 | 33.3310506230743 |
| CR5858_L6 |  18900118  |  37800236   | 4496988624  | 7.69768679219445 |
| CR5858_L8 |  92848943  |  185697886  | 22044418399 | 37.7343690499829 |
| CR5859_L5 |  82002936  |  164005872  | 19706477318 | 33.7324158130777 |
| CR5859_L6 |  19072152  |  38144304   | 4595090888  | 7.86561261211914 |
| CR5859_L8 |  92602621  |  185205242  | 22244268750 | 38.0764614002054 |
| CR5860_L5 |  69477042  |  138954084  | 16704846951 | 28.5943973827456 |
| CR5860_L6 |  15848502  |  31697004   | 3820078002  | 6.53899007531667 |
| CR5860_L8 |  80367206  |  160734412  | 19310931790 | 33.0553437007874 |
| CR5861_L5 |  72895072  |  145790144  | 18215136373 | 31.1796240551181 |
| CR5861_L6 |  16975328  |  33950656   | 4252082006  | 7.27846971242725 |
| CR5861_L8 |  82144191  |  164288382  | 20520054778 | 35.1250509722698 |


**Table:** BFcrop merged

| Sample | read_pairs | total_reads | total_bases |      Depth       |
|:------:|:----------:|:-----------:|:-----------:|:----------------:|
| CR5858 | 195734188  |  391468376  | 58720256400 | 100.513961656967 |
| CR5859 | 195563248  |  391126496  | 58668974400 | 100.426180075317 |
| CR5860 | 167141538  |  334283076  | 50142461400 | 85.8309849366655 |
| CR5861 | 173546532  |  347093064  | 52063959600 | 89.120095172886  |
| CR5862 | 165235151  |  330470302  | 49570545300 | 84.8520118110236 |
| CR5863 | 177723729  |  355447458  | 53317118700 | 91.265180931188  |


**Table:** BFcrop merged trimmed

| Sample | read_pairs | total_reads | total_bases |      Depth       |
|:------:|:----------:|:-----------:|:-----------:|:----------------:|
| CR5858 | 193808607  |  387617214  | 46013406797 | 78.7631064652516 |
| CR5859 | 193677709  |  387355418  | 46545836956 | 79.6744898254023 |
| CR5860 | 165692750  |  331385500  | 39835856743 | 68.1887311588497 |
| CR5861 | 172014591  |  344029182  | 42987273157 | 73.5831447398151 |
| CR5862 | 163815509  |  327631018  | 40457155123 | 69.2522340345772 |
| CR5863 | 176095122  |  352190244  | 42480605344 | 72.7158598836015 |


**Table:** Africrop (All species, first 20th)

| Sample | read_pairs | total_reads | total_bases |      Depth       |
|:------:|:----------:|:-----------:|:-----------:|:----------------:|
| A3009  |  17330594  |  34661188   | 3329665848  | 5.69953072235536 |
| A3085  |  15842995  |  31685990   | 3046409709  | 5.21466913557001 |
|  A420  |  30329976  |  60659952   | 5828869918  | 9.97752467990414 |
|  A467  |  29723454  |  59446908   | 5720132725  | 9.79139459945224 |
| A5045  |  9754184   |  19508368   | 2607104420  | 4.46269157822663 |
| A5047  |  12342247  |  24684494   | 3324539881  | 5.69075638651147 |
| A5048  |  34971061  |  69942122   | 9389908863  | 16.0731065782266 |
| A5059  |  38104250  |  76208500   | 10279448578 | 17.5957695617939 |
| A5061  |  10547449  |  21094898   | 2814425720  | 4.81757226977063 |
| A5066  |  30165739  |  60331478   | 8089247187  | 13.8467086391647 |
| A5067  |  28611430  |  57222860   | 7674222587  | 13.1362933704211 |
| A5068  |  7400407   |  14800814   | 1977629086  | 3.3851918623759  |
|  A52   |  8610883   |  17221766   | 1655930336  | 2.83452642245806 |
|  A537  |  32374854  |  64749708   | 6222490445  | 10.6513016860664 |
| A5497  |  9590842   |  19181684   | 2791866680  | 4.77895700102705 |
| A5498  |  12817475  |  25634950   | 3742105565  | 6.40552133687093 |
| A5499  |  12530235  |  25060470   | 3656967933  | 6.25978762923656 |
| A5689  |  14418432  |  28836864   | 4215697311  | 7.21618848168435 |
| A5690  |  19878071  |  39756142   | 5789002178  | 9.90928137281753 |


- Graphs were generated per species
- The workflow diagram has been revised and improve
- Distribution of the samples maps were created.


## 10. MinHash approach using Mash
- Compute Mash distance with k=11 and s= 10000 and Mash distance

```
# LOAD MODULES
module load singularity/4.0.1
module load mash/2.3
module load mashtree/1.4.6

# STEP 1: CREATE MASH SKETCHES FOR READS
echo "STEP 1: Creating Mash sketches for reads..." | tee -a "$LOGFILE"

for FQ in "${READ_DIR}"/*.fastq.gz
do
    SAMPLE=$(basename "$FQ" .fastq.gz)
    echo "Sketching sample: $SAMPLE" | tee -a "$LOGFILE"
    mash sketch -k "$KMER" -s "$SKETCH" -m "$MIN_KMER" -p "$THREADS" \
    -o "${SKETCH_DIR}/${SAMPLE}" "$FQ"
done

echo "Read sketches completed" | tee -a "$LOGFILE"

# STEP 2: SKETCH REFERENCE GENOME
echo "STEP 2: Creating Mash sketch for reference genome..." | tee -a "$LOGFILE"
mash sketch -k "$KMER" -s "$SKETCH" -p "$THREADS" -o "${SKETCH_DIR}/reference" "$REF_GENOME"
echo "Reference genome sketch completed" | tee -a "$LOGFILE"

# STEP 3: COMBINE SKETCHES
echo "STEP 3: Combining sketches..." | tee -a "$LOGFILE"
mash paste "${SKETCH_DIR}/all.msh" "${SKETCH_DIR}"/*.msh
echo "Sketch combination completed" | tee -a "$LOGFILE"

# STEP 4: COMPUTE PAIRWISE DISTANCES
echo "STEP 4: Computing pairwise Mash distances..." | tee -a "$LOGFILE"
mash dist "${SKETCH_DIR}/all" "${SKETCH_DIR}/all.msh" \
	> "${DIST_DIR}/mash_distances.tab"
echo "Distance calculation completed" | tee -a "$LOGFILE"

# STEP 5: BUILD TRIANGLE MATRIX
echo "STEP 5: Building Mash triangle matrix..." | tee -a "$LOGFILE"
mash triangle "${SKETCH_DIR}/all.msh" > "${DIST_DIR}/mash_triangle.txt"
echo "Triangle matrix completed" | tee -a "$LOGFILE"

# OPTIONAL: BUILD QUICK TREE
echo "STEP 6: Building MashTree phylogeny..." | tee -a "$LOGFILE"
mashtree "${READ_DIR}"/*.fastq.gz "$REF_GENOME" > "${DIST_DIR}/mashtree.nwk"
```

- Remove the directory path and .fastq.gz extension from mash_distances.tab

```
awk '{
gsub(".*/","",$1); gsub(".fastq.gz","",$1);
gsub(".*/","",$2); gsub(".fastq.gz","",$2);
print
}' mash_distances.tab > mash_distRef1_clean.tab
```

- Remove the directory path and .fastq.gz extension from mash_triangle.txt

```
awk '{gsub(".*/","",$1); gsub(".fastq.gz","",$1); print}' mash_triangle.txt > \
	mash_triangleRef1_clean.txt
```

- Downstream analysis in R

	- PCoA
    	- k-means clustering
    	- Neighbor-Joining tree
    	- Mash distance heatmap 
    	


## 11. Fourth online meeting 03-19-2026

- Supervisors recommandations:

	- Revise the presentation by removing old genetic diversity tools
    	- Update downstream analysis in ```Workflow```
    	- Revise scripts
    	- Explain Mash approach


- All recommandations were observed


## 12. Mash run_1
- Get error with k-mer size used (11)
WARNING: For the k-mer size used (11), the random match probability (0.992991) is above the specified 
warning threshold (0.01) for the sequence "TDr96x99_v1.0.fasta_genomic.fna" of size 594227176. 
Distances to this sequence may be underestimated as a result. To meet the threshold of 0.01, 
a k-mer size of at least 18 is required. See: -k, -w.


## 13. Mash run_2
Scripts were updates to integrate array mode and Mash was run based on scripts **mash_step1.sh**, **mash_step1.sh**.

After run_2, file named **all.msh** in output directories were renamed ```all_[directory_name].msh``` and then move to the directory **all_sk_reads**.


## 14. Mash run_3
The scripts **mash_ref1.sh**, **mash_ref2.sh** were used to take in account reference genomes in order to access distance between theses references and BFcrop samples.


## 15. Mash running times

```
# Get the running time of a job
sacct -j 6295 --format=JobID,JobName,Elapsed
scontrol show job JOBID

# Compute the average runtime (one-liner)
sacct -j 8149 --format=ElapsedRaw -n | awk '{sum+=$1; n++} END {print "Average runtime:", sum/n, "seconds"}'

# Compute min and max runtime
sacct -j 8149 --format=ElapsedRaw -n | awk '
NR==1{min=max=$1}
{sum+=$1; if($1<min)min=$1; if($1>max)max=$1}
END{
print "Tasks:", NR
print "Average:", sum/NR, "seconds"
print "Min:", min, "seconds"
print "Max:", max, "seconds"
}'
```

- Average runtime (mash sketche): 202.277 seconds k21s1000
	- Tasks: 346
	- Average: 202.277 seconds
	- Min: 55 seconds
	- Max: 1533 seconds

- Average runtime (mash sketche): 199.376 sesonds k21s10000

	- Tasks: 346
	- Average: 199.376 seconds
	- Min: 53 seconds
	- Max: 1572 seconds

- Average runtime(mash sketche): 202.468 seconds k21s100000

	- Tasks: 346
	- Average: 202.468 seconds
	- Min: 57 seconds
	- Max: 1519 seconds

- Average runtile (Mashtree without --mindepth) 4 threads per task
	- Average runtime: 9586.33 seconds
	- Tasks: 6
	- Average: 9586.33 seconds
	- Min: 9544 seconds
	- Max: 9633 seconds


## 16. Fifth online meeting: 03-26-2026 

- Supervisors recommendations: 

	- Bayesian analysis
	- How do the resuls will be compare
	- Admixture:
	- Acestry analysis:
	- Mast distance is genetic distance or not
	- Phylogeny
	- Distance tree vs phylogenetic tree
	- Coverage and depth 
	- Chromosomes number of ref v1 and ref v2
	

### 16.1. Comparison tests:

-  1. Comparing distance matrices (Mantel test)
The Mantel test is a statistical test used to assess the correlation between two matrices (Mantel, 1967)
https://uw.pressbooks.pub/appliedmultivariatestatistics/chapter/mantel-test/

- 2. Comparing phylogenetic trees (topology)
In phylogenetics, “topology” refers to the branching pattern of a tree, regardless of branch lengths. It shows who is related to whom (Li *et al*., 2023).

- 3. Procrustes test (global structure comparison)
The Procrustes test is a statistical method used to compare two sets of multivariate data, usually in the context of shape analysis, ecology, or genetics, to see how similar they are in structure. It’s often used with ordination results like PCA (Principal Component Analysis), PCoA, or NMDS. 

- 4. Clustering comparison --> compare group assignments
- 5. Direct correlation (scatter plot)

---

## 16.2. Trees

- Phylogeny is the study of evolutionary relationships among organisms (species, populations, or genes).

- Admixture analysis tries to answer:

	- For each individual, what fraction of its genome comes from each of K ancestral populations?
	- Output: A matrix of ancestry proportions (Q matrix) and cluster allele frequencies (P matrix).
	- Applications: Population structure, hybrid detection, GWAS correction.

- Ancestry analysis is a biological/genetic objective:It aims to estimate the origin of individuals’ genomes in terms of contributions from different ancestral populations.

- Bayesian analysis is a statistical framework:It estimates parameters by combining prior knowledge with observed data. In genetics Estimate ancestry proportions with uncertainty Include prior assumptions about populations. Bayesian analysis is a method used to solve problems (including ancestry analysis)

ADMIXTURE = What is the best explanation for the data?
STRUCTURE (Bayésien) = What are all the possible explanations, and with what probability?

Mash Distance: Ranges from 0 (identical) to 1 (totally different). It directly estimates the mutation rate, making it linear regarding sequence evolution, unlike Jaccard-based measures which drop sharply. P-value (Confidence): Evaluates the probability of seeing a given distance by chance. Lower p-values indicate more confident, non-random matches. In current scientific practice (microbial genomics), Mash distance is accepted as a measure of genetic distance for rapid screening, species classification, and preliminary tree construction.(Jain *et al*., 2018; Ondov *et al*., 2016).


### 16.3. Coverage and depth

- Sequencing depth, also known as read depth or depth of coverage, refers to the number of times a specific base (nucleotide) in the DNA is read during the sequencing process. In other words, it’s the average number of times a given position in the genome is sequenced. A higher sequencing depth provides more confidence in the accuracy of the base calls at that position and helps to reduce sequencing errors and noise.

- Coverage is closely related to sequencing depth but provides a broader perspective. Coverage is the proportion or percentage of a genome that has been sequenced at a certain depth. It gives an idea of how much of the entire genome has been effectively read and is usually expressed as a multiple of the genome’s size.

- Sequencing Depth: Number of reads covering a genomic position (e.g., 30×)
- Sequencing Coverage: Percentage of the genome covered by reads
- Mapping Coverage: Mapping coverage is the percentage of the reference genome covered by aligned reads.
- Mapping Depth:Mapping depth is the number of reads aligned to a specific position in the reference genome.


### 16.4. Reference genome
Genome assembly TDr96x99_v1.0.fasta:	
	Assembly level	Scaffold

Genome assembly TDr96_F1_v2_PseudoChromosome.rev07_lg8_w22 25.fasta:
	Number of chromosomes	28
	Number of organelles	1
	Assembly level	Chromosome


### 16.5. Mash adventages & Limitations
#### Advantages
1. No reference bias
2. Speed ​​and simplicity
3. Useful for unmodeled species

#### Major limitations
1. No genomic positioning (loses all structural information)
2. No detailed variant analysis
3. Limited biological interpretation

Mash is therefore best suited for fast screening, clustering, and quick distance estimation, but not for detailed, alignment-level analysis of highly divergent sequences.


### 16.6. Answers to questions: Reponse.pdf, Reponse_2.pdf, Reponce_3.pdf


## 17. Sixth online Meeting: 04-02-2026

- Supervisors recommendations: 

	- Resume PCoA analysis: color samples with "Field identification" and by "Country";
	- Resume PCoA analysis: color samples with the structure results and by kmeans;
	- Retrieve the Africrop VCF from https://zenodo.org/records/2540773;
	- Convert the VCF into a presence-absence matrix, then into a Jaccard index, and finally into a distance matrix;
	- Perform the Mantel test;
	- What is the Jaccard index?
	- Why the SNPs are not transformed into a presence-absence matrix?
	

### Réponse à la : C'est quoi l'indice de Jaccard?
L'indice et la distance de Jaccard sont deux métriques utilisées en statistiques pour comparer la similarité et la diversitéentre des échantillons. 

L'indice de Jaccard est une mesure de similarité entre deux ensembles finis A et B. Il est défini comme le rapport de la taille de leur intersection à la taille de leur union : J(A, B) = |A ∩ B| / |A ∪ B|. Il vaut 0 si les ensembles sont disjoints et 1 s'ils sont égaux. La distance de Jaccard est 1 - J(A, B) (Jaccard, 1901; Ondov et al., 2016)

### Réponse à la : Pourquoi les SNPs ne sont pas transformer en une matrice présence-absence?
Les SNPs (Single Nucleotide Polymorphisms) ne sont généralement pas transformés en une matrice présence-absence car ils représentent des substitutions (changement d'une base) plutôt que la présence ou l'absence d'un gène. Une matrice présence-absence (binaire) ne capte pas la diversité allélique, contrairement aux données génotypiques qui différencient les homozygotes et hétérozygotes (Kim et al., 2021; Geethanjali et al., 2024; Abed et al., 2025).

Les raisons principales :
- Nature de la variation : Un SNP est la substitution d'un nucléotide (ex: A \(\rightarrow \) G). Il est présent chez tous les individus, mais sous des formes (allèles) différentes. La matrice binaire (0/1) est inadaptée pour refléter cette substitution.
- Perte d'information : Transformer un génotype diploïde (ex: AA, AG, GG) en présence/absence (1/0) masque l'hétérozygotie.
- Informations sur les allèles : L'analyse des SNPs nécessite de distinguer l'allèle majeur de l'allèle mineur pour les études d'association, ce qu'une matrice binaire simple ne permet pas.

Cependant, pour d'autres types de variations génétiques comme les insertions/délétions (InDels) ou les variations du nombre de copies (CNV), la matrice présence-absence est fréquemment utilisée.

Les SNPs ne sont pas transformés en matrice présence/absence parce que cela fait perdre l’information sur les génotypes et l’hétérozygotie, essentielle pour les analyses génétiques.


### Single Nucleotide Polymorphisms (SNPs)  
Les polymorphismes nucléotidiques simples (SNP) permettent de calculer différentes distances génétiques pour mesurer la parenté, la structure et l'évolution, notamment les distances entre paires de SNP (nombre brut de différences), les métriques de dissimilarité/distance génétique (Nei, Rogers, Hamming) et le déséquilibre de liaison (r²). Ces métriques quantifient les différences entre individus, populations ou régions génomiques.

Types de distances calculer à partir de données SNPs:

- Distance simple (p-distance) compte les différences (Mustapha et al., 2018; Raghuram et al., 2023; Jandrasits et al. 2019);
- Distance de Nei (1972 ou 1978) et Distance de Reynolds analysent les fréquences alléliques (Muktar et al.,2023; Zhang et al., 2022);
- Distance IBS (Identity By State) mesure la similarité allélique directe (Yan et al., 2023; Mourtala et al., 2025);
- Distance Euclidienne représente la séparation géométrique dans un espace multidimensionnel (Li et al., 2020; Reverter et al., 2020) ;
- Le déséquilibre de liaison (DL) (r²) mesure l'association non aléatoire des allèles à différents sites SNP (yan et al., 2023; Kandarkar et al., 2024) 



### Calcul de disance à partir du fichier vcf

```Script bash
# Convert VCF to PLINK
plink --vcf Calling_ALL_Rotundata_Allc05.vcf --make-bed --allow-extra-chr --out Africrop

# IBS Distance Matrix:
plink --bfile Africrop --distance square ibs --allow-extra-chr --out ibs_dist

# Compute simple pairwise distance (allele sharing)
plink --bfile Africrop --distance square 1-ibs --allow-extra-chr --out allele_dist

# Pairwise genetic distance
plink --bfile Africrop --distance square --allow-extra-chr --out pairwise_dist
```

- IBS = Identity By State, Measures how many alleles are identical between two individuals. So this output is fundamentally a similarity measure, not a true distance.

- 1 − IBS (allele-sharing distance), This is a true dissimilarity metric; This is the most commonly used genetic distance in population genetics from PLINK IBS output


1 - IBS is the cleanest and most interpretable true genetic distance
Because it:

- is directly derived from a similarity metric
- behaves like a proper dissimilarity measure
- is widely used in population genetics (PCA, clustering, dendrograms)


## Script R

```
library(vcfR)
library(adegenet)
library(vegan)
library(poppr)

# Import des données SNP
vcf <- read.vcfR("file.vcf")
genind_obj <- vcfR2genind(vcf)

# Calcul de la distance de Jaccard
dist_jaccard <- vegan::vegdist(X_bin, method = "jaccard")

# Obtenir l’indice de similarité
jaccard_similarity <- 1 - as.matrix(dist_jaccard)

# Identity By State (IBS) distance
dist_snp1 <- poppr::bitwise.dist(genind_obj)

# Pairwise distance/Convert to SNP distance matrix
snp_dist2 <- poppr::dist(genind_obj, method = 2)  

# Import Mash distances
mash <- read.table("mash_distances.tsv", header = FALSE)
colnames(mash) <- c("genome1", "genome2", "mash_dist", "pvalue", "shared_hashes")

# Aligner les individus
common <- intersect(labels(mash_dist), labels(dist_snp))
mash_dist <- as.dist(as.matrix(mash_dist)[common, common])
dist_snp1 <- as.dist(as.matrix(dist_snp1)[common, common])
dist_snp2 <- as.dist(as.matrix(dist_snp2)[common, common])
dist_jaccard <- as.dist(as.matrix(dist_jaccard)[common, common])

# Test de Mantel
mantel_result1 <- vegan::mantel(mash_dist, dist_jaccard, method="pearson", permutations=999)
mantel_result2 <- vegan::mantel(mash_dist, dist_snp1, method="pearson", permutations=999)
mantel_result3 <- vegan::mantel(mash_dist, dist_snp2, method="pearson", permutations=999)

print(mantel_result1)
print(mantel_result2)
print(mantel_result3)
```

# ==================================================

```Text
| Goal                             | Use  |
| -------------------------------- | ---- |
| Fine population structure        | SNPs |
| Evolutionary analysis (detailed) | SNPs |
| Quick similarity / clustering    | Mash |
| Species identification           | Mash |
| Large dataset screening          | Mash |
| Detect exact mutations           | SNPs |

Practical workflow (common in research)
Use Mash first → quickly cluster and filter samples
Then use SNP analysis → detailed population/genetic study

When each performs better

- SNP is better when:

		- Need precise evolutionary or genetic inference
		- Studying population structure, selection, GWAS
		- Tracking transmission chains or microevolution
		- Require exact genomic positions

- Mash is better when:

		- Want fast genome comparison
		- Have hundreds–thousands of genomes
		- Need species-level or strain-level clustering
		- Are doing exploratory or screening analysis
```

# ==================================================


## Answers to supervisors' questions: Reponse_4.pdf


## 18. Seventh online Meeting: 04-09-2026 

### PLINK
- .bed (PLINK binary biallelic genotype table): Primary representation of genotype calls at biallelic variants. Must be accompanied by .bim and .fam files. Loaded with --bfile; generated in many situations, most notably when the --make-bed command is used (https://www.cog-genomics.org/plink/1.9/formats#bed) 

- .bim (PLINK extended MAP file): Extended variant information file accompanying a .bed binary genotype table.  A text file with no header line, and one line per variant with the following six fields:

	- 1. Chromosome code (either an integer, or 'X'/'Y'/'XY'/'MT'; '0' indicates unknown) or name
    	- 2. Variant identifier
    	- 3. Position in morgans or centimorgans (safe to use dummy value of '0')
    	- 4. Base-pair coordinate (1-based; limited to 231-2)
    	- 5. Allele 1 (corresponding to clear bits in .bed; usually minor)
    	- 6. Allele 2 (corresponding to set bits in .bed; usually major)
    	
Allele codes can contain more than one character. Variants with negative bp coordinates are ignored by PLINK.

- .fam (PLINK sample information file): Sample information file accompanying a .bed binary genotype table. (--make-just-fam can be used to update just this file.) Also generated by "--recode lgen" and "--recode rlist". A text file with no header line, and one line per sample with the following six fields:

	- 1. Family ID ('FID')
	- 2. Within-family ID ('IID'; cannot be '0')
	- 3. Within-family ID of father ('0' if father isn't in dataset)
	- 4. Within-family ID of mother ('0' if mother isn't in dataset)
	- 5. Sex code ('1' = male, '2' = female, '0' = unknown)
	- 6. Phenotype value ('1' = control, '2' = case, '-9'/'0'/non-numeric = missing data if case/control)

https://www.cog-genomics.org/plink/1.9/formats#bed
https://www.cog-genomics.org/plink/1.9/distance


### Extract sample order
bcftools query -l Calling_ALL_Rotundata_Allc05.vcf  > samples_order.txt

samples_order.txt was used to prepare renamed_samples.csv structured as
old_name1 new_name1
old_name2 new_name2

sed 's/,/\t/g' renamed_samples.csv > renamed_samples.tsv # to change delimiter


### Rename samples in VCF
bcftools reheader -s renamed_samples.tsv Calling_ALL_Rotundata_Allc05.vcf -o renamed.vcf

### Reorder samples in the VCF
bcftools view -S final_order.txt renamed.vcf -o reordered.vcf

### Convert VCF to BED
plink --vcf reordered.vcf --make-bed --allow-extra-chr --out Africrop

### Export genotype to a simple matrix:
plink --bfile Africrop --recode A --allow-extra-chr --out geno


### Compute Jaccard in R
library(vegan)

## Load data
geno <- read.table("geno.raw", header=TRUE)

## Convert to binary (presence/absence)
## Skip the first 6 columns (plink metadata) and Keeps only genotype columns
geno_bin <- (geno[,7:ncol(geno)] > 0) * 1

## Compute Jaccard distance matrix
dist <- vegdist(geno_bin, method="jaccard")
dist <- vegdist(geno_bin, method="jaccard", binary = T)

https://github.com/vegandevs/vegan
https://rdrr.io/cran/vegan/man/vegdist.html
https://github.com/vegandevs/vegan/issues/153


## Mash distance
Mash distance is calculated by estimating the Jaccard index (\(J\)) of shared \(k\)-mers between two sequences using MinHash sketches, then converting this similarity into a mutation rate (\(D\)) using the formula \(D = -\frac{1}{k} \ln(\frac{2J}{1+J})\), where \(k\) is the \(k\)-mer size. It efficiently approximates evolutionary distance without alignment. 

How Mash Distance Works Sketching (MinHash): 
- Sequences are reduced to small, fixed-size sketches (a representative set of \(k\)-mers).
- Jaccard Index Calculation: The proportion of shared \(k\)-mers between two sketches is computed to estimate the Jaccard similarity (\(J = \frac{|A \cap B|}{|A \cup B|}\)).
- Distance Estimation: The formula \(D = -\frac{1}{k} \ln(\frac{2J}{1+J})\) is applied to convert the Jaccard index (\(J\)) into a distance measure that approximates the mutation rate, accounting for the \(k\)-mer length \(k\).
- Result Interpretation: A Mash distance of 0 indicates identical sequences, while a distance of 1 indicates no shared \(k\)-mers (no similarity).

Source: https://mash.readthedocs.io/en/latest/distances.html

## Answers to supervisors’ questions: Reponse_5.pdf


## 19. Eighth online Meeting: 04-17-2026 

Recommandation: 
- Re perform Mante test;
- Review the management of missing data from SNP data;
- Provide a verification after renaming and reordering the vcf file.


## Check the VCF file after renaming and reordering samples

```Bash
# Compare varant numbers:
bcftools view -H file.vcf | wc -l
bcftools view -H reordered.vcf | wc -l

# Compare chromosome-position-reference-alternate fields:
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' file.vcf > original_sites.txt
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' reordered.vcf > reordered_sites.txt

diff original_sites.txt reordered_sites.txt

# Compare headers (except for the sample line):
bcftools view -h file.vcf | grep '^##' > original_header.txt
bcftools view -h reordered.vcf | grep '^##' > reordered_header.txt

diff original_header.txt reordered_header.txt

# Compare a few variant lines before and after in order to confirm if genotype data were stayed attached to the correct samples:
bcftools view file.vcf | grep -v '^#' | head
bcftools view reordered.vcf | grep -v '^#' | head
```

## Mash distance
Mash distance is a pairwise mutation distance, it estimates the mutation rate between two sequences directly from their MinHash sketches. Mash first estimates the Jaccard index from MinHash sketches, then converts it into an evolutionary distance (Ondov et al., 2016). If j is the estimated Jaccard index and k is the k-mer size, the Mash distance is: D_{Mash}=-\frac{1}{k}\ln\left(\frac{2j}{1+j}\right)

## SNP-based genetic distances   
Single nucleotide polymorphisms (SNPs) allow the calculation of various genetic distances to measure relatedness, structure, and evolution, including SNP pairwise distances (raw number of differences), genetic dissimilarity/distance metrics (Nei, Rogers, Hamming) and linkage disequilibrium (r²). These metrics quantify differences between individuals, populations, or genomic regions.

Types of distances to calculate from SNP data for comparison with MASH:

- pairwise SNP distances (p-distance): measures the proportion of SNP loci that differ between two individuals [@Raghuram2023]; (VanWallendael&Alvarez, 2020)
- Identity-by-State (IBS) distance: measures direct allelic similarity (how many alleles are shared at each locus) [@Mourtala2025];
- Jaccard distance: measures dissimilarity based only on shared presences alleles, ignoring shared absences (Russo et al., 2024)
- Nei distance, a population-level genetic distance based on allele frequencies (VanWallendael&Alvarez, 2020); (Muktar et al., 2023)
- Jukes-Cantor distance: is a corrected sequence distance that accounts for multiple substitutions occurring at the same site (Ilyasov et al., 2022)
- Kimura two-parameter distance: The Kimura two-parameter model distance is an extension of the Jukes-Cantor model distance that distinguishes between transitions and transversions (A simple method for estimating evolutionary rates of base substitutions through comparative studies of nucleotide sequences (Laojun et al., 2023)

The SNP-based distance most comparable to Mash distance is the nucleotide substitution rate per site, usually called p-distance:
p=\frac{\text{number of differing SNP sites}}{\text{total compared sites}}

This is because Mash distance approximates the mutation rate between genomes, and for closely related genomes it behaves similarly to the fraction of nucleotide differences. For small divergences:

	* Mash distance ≈ SNP p-distance
	* Mash distance ≈ (1-) ANI

If SNP divergence becomes larger, p-distance starts underestimating true divergence because multiple substitutions can happen at the same site. In that case, corrected SNP distances such as: **Jukes-Cantor distance** and **Kimura two-parameter distance**, become more comparable to Mash distance for more divergent genomes.


## Scripts


### Which method is best for SNPs?

| Distance     | Best use                                      |
| ------------ | --------------------------------------------- |
| p-distance   | basic SNP divergence                          |
| IBS          | population structure / relatedness            |
| Jaccard      | presence/absence SNPs                         |
| Nei          | population genetics                           |
| Jukes-Cantor | evolutionary correction                       |
| K2P          | sequence evolution (more classical phylogeny) |

## Effects of imputation SNP missing data 
Imputing missing Single-nucleotide polymorphism data changes the genotype matrix and therefore affects downstream distances, clustering, ordination, and population structure analyses (Sethuraman, 2026; Geibel et al. 2021, Sun and Kardia, 2008; Roshyara et al.,2014, Georges et al., 2023)


Main consequences depend on the imputation method:

- General effects of imputation:

		- Reduced genetic distances between individuals
		- Lower observed heterozygosity
		- Potential distortion of clustering and ordination
		- Possible bias in allele frequencies
		- Increased risk of false biological interpretation if missingness is high


- Imputing missing values as 0 tends to increase the number of reference homozygotes or absences

		- This can artificially make samples appear more similar.
		- It can bias Jaccard distance, Nei distance, or Euclidean distance downward.
  
- Mean imputation replaces missing genotypes with the average allele dosage at that locus.

		- This reduces variance between individuals.
		- Distances between samples become smaller.
  


## Answers to supervisors’ questions: Reponse_6.pdf


## All responses to supervisors' questions  were combines in one file: responses_aux_observations.md
















