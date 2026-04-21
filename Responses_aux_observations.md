---
title: Reponses
subtitle: Aux préoccupations et recommandations exprimées lors des réunions
bibliography: biblio_observations.bib
link-citations: true
geometry: portrait, margin=1in
---

## 1. Reponses_1

## 1.1. Quelles sont les différences méthodologiques et conceptuelles entre un arbre de distance et un arbre phylogénétique ?

La distinction entre arbre de distance et arbre phylogénétique est à la fois méthodologique (comment ils sont construits) et conceptuelle (ce qu’ils représentent réellement en biologie évolutive)


### 1.1.1 Différence conceptuelle (le sens biologique)

#### Arbre phylogénétique
un arbre phylogénétique permet de décrire de façon très synthétique les deux principaux processus de l’évolution : (1) l’anagenèse
ou évolution dans une lignée qui est représentée par une branche, et (2) la cladogenèse ou spéciation, qui est représentée par un nœud d’où sont issues deux
espèces à partir d’un ancêtre commun [@Casane2012].

### Arbre de distance
Un arbre de distance est une représentation mathématique de similarités ou de dissimilarités. Il est construit à partir d’une matrice de distances (génétiques, morphologiques, etc.) et ne reconstruit pas directement l’histoire évolutive. Il cherche seulement à représenter au mieux les distances observées. La proximité sur l'arbre indique une ressemblance globale, pas nécessairement une parenté directe [@Wen2014].


### 1.2. Différence méthodologique (comment ils sont construits)

### Arbres phylogénétiques
Méthodes typiques [@Wang2023]:
* Maximum de parcimonie
* Maximum de vraisemblance
* Inférence bayésienne

Les méthodes basées sur la distance (telles que les méthodes NJ et UPGMA) sont également utilisé [@Balaban2022].


### Arbres de distance
Méthodes typiques [@Balaban2022]:
* UPGMA (Unweighted Pair Group Method with Arithmetic Mean)
* Neighbor-Joining (NJ)

En résumé : Les arbres de distance (phénétiques) regroupent les organismes selon leur ressemblance globale, tandis que les arbres phylogénétiques représentent les relations de parenté évolutive. Les méthodes de distance calculent des dissimilarités (ex: UPGMA/NJ), alors que les méthodes phylogénétiques utilisent des caractères pour inférer l'ancêtre commun (parcimonie, vraisemblance). Un arbre de distance peut être utilisé comme approximation rapide d’un arbre phylogénétique [@Zou2024].


## 1.2. Un arbre de distance et un arbre phylogénétique correspondent-ils à la même choses ?
Non (au regard de tout ce qui précede), un arbre de distance et un arbre phylogénétique ne correspondent pas à la même chose, même s’ils peuvent parfois se ressembler visuellement.


## 1.3. Dans quels types d'analyses utilise-t-on un arbre phylogénétique ? Un arbre de distance ?

- Un arbre phylogénétique est utilisé quand on veut reconstruire ou tester une histoire évolutive.
- Un arbre de distance est utilisé quand on veut explorer ou résumer des similarités entre individus ou populations, parfaits pour l'analyse rapide de grandes données moléculaires


## 1.4. Quels types de données utilise-t-on pour réaliser un arbre phylogénétique ? Un arbre de distance ?
- Un arbre phylogénétique utilise des données évolutives explicites, généralement alignées site par site.
	- Types de données:
	- Séquences moléculaires (principalement)
	- Données génomiques (SNP)

- Un arbre de distance utilise une matrice de distances entre individus ou populations.
	- Types de données:
	- Données génétiques transformées en distances
	- Toute donnée convertible en distance

## 1.5. Et donc, en conclusion, peut-on utiliser MASH pour réaliser un arbre phylogénétique ?
Non, on ne peut pas utiliser Mash pour construire un véritable arbre phylogénétique, mais on peut l’utiliser pour construire un arbre de distance qui en est une approximation.

Au-delà du simple regroupement, la distance de Mash est une approximation du taux de mutation qui peut également être utilisée pour approximer rapidement les phylogénies à l'aide d'un regroupement hiérarchique. Cependant, en raison des limitations de l'approche par k-mers et du modèle de distance simple, Ondov *et al*. (2016) ont souligné que Mash n'est pas explicitement conçu pour la reconstruction phylogénétique, en particulier pour les génomes présentant une forte divergence ou de grandes différences de taille [@Ondov2016].



## 2. Reponses_2

## 2.1. Qu'est ce qu'une ACP ? Une ACoP ? 

### 2.1.1.ACP — Analyse en Composantes Principales (*Principal Component Analysis, PCA*)

L’ACP est une méthode statistique qui permet de réduire la dimension d’un jeu de données. Cette méthode transforme des variables initiales (souvent corrélées) en nouvelles variables appelées "composantes principales" qui sont indépendantes les unes des autres et ordonnées selon la quantité de variance expliquée. Cela permet de visualiser des données multidimensionnelles sur un graphique simple (en 2D ou 3D) tout en conservant le maximum d'information possible [@Greenacre2022].

L'ACP a pour Objectifs de :

* Résumer l’information ;
* Visualiser les données (souvent en 2D ou 3D) ;
* Détecter des structures (groupes, tendances).


### 2.2.1.2. ACoP — Analyse des Coordonnées Principales (*Principal Coordinates Analysis, PCoA*)

L’ACoP est une méthode statistique qui permet de représenter des distances ou des dissimilarités entre individus dans un espace de faible dimension.
L'ACoP est utilisée quand on ne dispose pas directement des mesures des variables, mais seulement de la "distance" (ressemblance) entre les individus [@Gower2014]. 

L'ACoP a pour Objectifs de :

* Visualiser les relations entre individus ;
* Travailler avec des distances complexes (pas forcément euclidiennes).


### 2.1.3. Différence fondamentale entre l’ACP et l'ACoP
La différence fondamentale entre l’ACP et l’ACoP tient à la nature des données utilisées en entrée [@Greenacre2022 ; @Gower2014]:

- ACP utilise directement une matrice de variables (données brutes) ;
- ACoP utilise une matrice de distances ou de dissimilarités (ex : distance génétique, distance de Bray-Curtis, etc.).


## 2.2. Quel type de données est utilisé en entrée pour une ACP ? Une ACoP ?

### 2.2.1. Données utilisées en entrée pour une ACP
L’ACP utilise une matrice de données brutes :

- lignes = individus (ou populations) ;
- colonnes = variables.

Types de données : variables quantitatives (numériques), souvent continues (ou codées numériquement)

Exemples : taille, poids, rendement, fréquences alléliques, génotypes codés (0, 1, 2)


### 2.2.2. Données utilisées en entrée pour une ACoP
L’ACoP utilise une matrice de distances ou de dissimilarités :

- Types de données : distances entre individus ou populations issues de n’importe quel type de données (même qualitatives) ;
- Exemples de distances : distance de Nei (génétique), distance de Jaccard, distance de Bray-Curtis, distance euclidienne.


## 2.3. Et donc, doit-on faire une ACP ou une ACoP à partir des données de MASH ?
Mash génère une matrice de distances génomiques basée sur les k-mers [@Ondov2016]. Donc ce ne sont pas des variables brutes, mais des dissimilarités. Avec ce type de données l'**ACoP** (PCoA) est la méthode appropriée. 

## 2.4. A-t-on fait une ACP ou une ACoP sur les données AfriCrop ?
Scarcelli *et al*. ont effectué l'**ACP** sur les données Africrop en utilisant tous les **SNP** et après un seuil de fréquence allélique minimale (MAF) de 5 %  [@Scarcelli2019].



## 3. Reponses_3

### *Question:* Comment comparer les résultats issus de MASH et ceux issus d'AfriCrop ?

### Sous-questions proposées:

### 1 Quels sont les résultats issus de Mash ?
Les résultats issus de Mash correspondent à des mesures de similarité/distance entre génomes basées sur les k-mers (Matrice de distances) [@Ondov2016]: 

- Distance Mash (valeur entre 0 et 1) ;
- P-value qui indique la significativité de la similarité observée ;
- Nombre de k-mers partagés (shared-hashes / total-hashes).
 

### 2. Quels sont les résultats isssus de AfriCrop ?
Les resultsta de AfriCrop [@Scarcelli2019]:

- 3,570,940 single-nucleotide polymorphisms (SNPs) analysés.
- Les résultats de l’analyse en composantes principales (ACP) a mis en évidence quatre groupes génétiques.
- Les résultats de ’analyse de la structure de la population a confirmé ces quatre groupes.

### 3. Peut-on comparer les résultats issus de MASH et ceux issus d'AfriCrop ?
Oui, on peut comparer les résultats issus de MASH et ceux issus des SNPs, mais pas de façon directe. Comme ce sont deux approches différentes,la bonne stratégie est une comparaison de concordance, pas une égalité stricte.


### 4. Quels sont les resultats issus de MASH et ceux d'AfriCrop qui peuvent être comparés ?

- Matrice de distances génétiques ;
- Assignation à des groupes ;
- Dendrogrammes (arbres).

### 5. Réponse à la question principale
Ainsi, comparer les résultats issus de MASH (basé sur les k-mers) et ceux issus des SNPs (basé sur des variants alignés) revient à comparer deux approches différentes de la distance génétique. Ce n’est pas une comparaison directe “1:1”, mais on peut établir une concordance globale.

Méthodes concrètes de comparaison:

- Corrélation entre matrices de distance
- Comparaison des arbres (distance et phylogénétique): 
	- topologie (structrure de l'arbre) ; 
	- branches (longueurs) ;
	- clustering (groupes) ;
- Comparaison des clusters 
- Comparaison visuelle


Abram *et al*. (2021) ont utilise Mssh pour identifier des phylogroupes d'*Escherichia coli*. La méthodologie utilisé permet non seulement de reproduire fidèlement les phylogroupes déjà décrits, mais également de mettre en évidence de nouveaux phylogroupes jusqu’alors non caractérisés au sein des espèces d’E. coli [@Abram2021].



## 4. Reponses_4

### Les réponses aux préoccupations et recommandation exprimées lors de la réunion du *2 avril 2026*.

## 4.1. Réponse à la : C'est quoi l'indice de Jaccard ?
L'indice et la distance de Jaccard sont deux métriques utilisées en statistiques pour comparer la similarité et la diversitéentre des échantillons. 

L'indice de Jaccard est une mesure de similarité entre deux ensembles finis A et B. Il est défini comme le rapport de la taille de leur intersection à la taille de leur union : J(A, B) = |A ∩ B| / |A ∪ B|. Il vaut 0 si les ensembles sont disjoints et 1 s'ils sont égaux. La distance de Jaccard est 1 - J(A, B) [@Jaccard1901; @Ondov2016]


## 4.2. Réponse à la : Pourquoi les SNPs ne sont pas transformer en une matrice présence-absence?
Les SNPs (Single Nucleotide Polymorphisms) ne sont généralement pas transformés en une matrice présence-absence car ils représentent des substitutions (changement d'une base) plutôt que la présence ou l'absence d'un gène. Une matrice présence-absence (binaire) ne capte pas la diversité allélique, contrairement aux données génotypiques qui différencient les homozygotes et hétérozygotes [@Kim2021; @Geethanjali2024; @Abed2025].

Les raisons principales :
- Nature de la variation : Un SNP est la substitution d'un nucléotide (ex: A \(\rightarrow \) G). Il est présent chez tous les individus, mais sous des formes (allèles) différentes. La matrice binaire (0/1) est inadaptée pour refléter cette substitution.
- Perte d'information : Transformer un génotype diploïde (ex: AA, AG, GG) en présence/absence (1/0) masque l'hétérozygotie.
- Informations sur les allèles : L'analyse des SNPs nécessite de distinguer l'allèle majeur de l'allèle mineur pour les études d'association, ce qu'une matrice binaire simple ne permet pas.

Cependant, pour d'autres types de variations génétiques comme les insertions/délétions (InDels) ou les variations du nombre de copies (CNV), la matrice présence-absence est fréquemment utilisée.

Les SNPs ne sont pas transformés en matrice présence/absence parce que cela fait perdre l’information sur les génotypes et l’hétérozygotie, essentielle pour les analyses génétiques.


## 4.3. Distances génétiques  
Les polymorphismes nucléotidiques simples (SNP) permettent de calculer différentes distances génétiques pour mesurer la parenté, la structure et l'évolution, notamment les distances entre paires de SNP (nombre brut de différences), les métriques de dissimilarité/distance génétique (Nei, Rogers, Hamming) et le déséquilibre de liaison (r²). Ces métriques quantifient les différences entre individus, populations ou régions génomiques.

Types de distances à calculer à partir de données SNPs pour la comparaison avec Mash:

- Distance simple (p-distance) compte les différences [@Raghuram2023];
- Distance IBS (Identity By State) mesure la similarité allélique directe [@Mourtala2025];
- Distance de Jaccard 


## 4.4. PCoA

![PCoA](/media/joel/Lab/CIBiG_2025/stage_yam/R_analysis/Mash_results/k21s1000/pcoa_2b.png){ width=100% }

Les échantillons de BFcrop ont été regroupés avec les échantillons *Dioscorea rotundata* d'Africrop et les 4 groupes génétiques mis en évidence par l'analyse en composantes principales (ACP) de Scarcelli *et al*. (2019) ont également été observés.


## 4.5. Test de comparaison

### 4.5.1. Calcul de disance à partir du fichier vcf

```Bash
# Convert VCF to PLINK
plink --vcf Calling_ALL_Rotundata_Allc05.vcf --make-bed --allow-extra-chr --out Africrop

# Compute simple pairwise distance (allele sharing)
plink --bfile Africrop --distance square 1-ibs --allow-extra-chr --out allele_dist

# Pairwise genetic distance
plink --bfile Africrop --distance square --allow-extra-chr --out pairwise_dist
```


### 4.5.2. Test de Mantel 

```R
# Read sample IDs
sample_id <- read.table("Input_dir/comparison/sample_id.txt", stringsAsFactors = FALSE)

# Read distance matrices
pairwise_mat <- as.matrix(read.table("Input_dir/comparison/pairwise_dist.dist"))
allele_mat   <- as.matrix(read.table("Input_dir/comparison/allele_dist.mdist"))

# Assign names
rownames(pairwise_mat) <- colnames(pairwise_mat) <- sample_id$V1
rownames(allele_mat)   <- colnames(allele_mat)   <- sample_id$V1

# Import Mash distances
mash <- read.table("Input_dir/comparison/mash_dist_clean.tab", header = FALSE)
colnames(mash) <- c("Query","Ref", "mash_dist", "pvalue", "shared_hashes")
mash_mat <- acast(mash, Query ~ Ref, value.var = "mash_dist") # Casts long table into a matrix

# Common set of individuals
common <- Reduce(intersect, list(
  rownames(mash_mat),
  rownames(allele_mat),
  rownames(pairwise_mat)
))

# Subset all matrices consistently
mash_mat       <- mash_mat[common, common]
allele_mat    <- allele_mat[common, common]
pairwise_mat  <- pairwise_mat[common, common]

# Convert to dist objects
mash_dist      <- as.dist(mash_mat)
dist_allele    <- as.dist(allele_mat)
dist_pairwise  <- as.dist(pairwise_mat)

# Mantel tests
mantel_result1 <- mantel(mash_dist, dist_allele, method = "pearson", permutations = 999)
mantel_result2 <- mantel(mash_dist, dist_pairwise, method = "pearson", permutations = 999)

print(mantel_result1)
print(mantel_result2)
```

Le **test de Mantel** a révélé une **corrélation positive et significative** entre les distances Mash et les distances basées sur le partage allélique (**r = 0.6311, p = 0.001**), indiquant une concordance entre les approches sans alignement et basées sur les SNP.



## 5. Reponses_5

## 5.1. Indice de Jaccard : qu’est ce que ça signifie génétiquement ? On regarde les SNPs qui sont communs sur l’ensemble des SNPS.
L'indice de Jaccard est une mesure de similarité entre deux ensembles finis A et B. Il est défini comme le rapport de la taille de leur intersection à la taille de leur union : J(A, B) = |A ∩ B| / |A ∪ B|. Il vaut 0 si les ensembles sont disjoints et 1 s'ils sont égaux. La distance de Jaccard est 1 - J(A, B) [@Jaccard1901; @Ondov2016]

L'indice de Jaccard génétiquement, est une mesure binaire (présence/absence) de similarité entre deux ensembles de données génétiques. Il calcule le rapport entre le nombre de marqueurs génétiques (allèles, SNPs) partagés (intersection) et le nombre total de marqueurs uniques présents dans l'ensemble des deux échantillons (union). L'indice est compris entre 0 (aucune similarité) et 1 (identité génétique totale), il permet d'évaluer la proximité génétique.


## 5.2. Distance de Jaccard : La dissimilarité, différents entre echantillons entre tous les échantillons
La distance de Jaccard est une métrique utilisées en statistiques pour comparer la dissimilarité entre des échantillons ou deux ensembles finis A et B. 
Elle est définie comme la différence entre la taille de l'union et celle de l'intersection, divisée par la taille de l'union des ensembles. 
Elle est égale à \(1\) moins l'indice de similarité de Jaccard (\(1 - J(A,B)\)), variant entre \(0\) (ensembles identiques) et \(1\) (ensembles disjoints) [@Jaccard1901; @Ondov2016].


## 5.3. SNps en matrice presence/absence?
- On perd des informations comme la frequence allélique ou le fait homoz/heteroz (cas indice de jacquard) mais heterozygiotie importante en génétique des pops
- Les SNPs (Single Nucleotide Polymorphisms) ne sont généralement pas transformés en une matrice présence-absence car une matrice présence-absence (binaire) entaine une perte d'information comme la fréquence allélique et l'hétérozygotie [@Kim2021; @Geethanjali2024; @Abed2025].
- Distance de Nei => travaille sur fréquence allélique
- La distance génétique de Nei (1972, 1978) est une mesure quantitative de la divergence génétique entre deux populations, basée sur les fréquences alléliques. Elle estime le nombre de substitutions de nucléotides par locus qui se sont accumulées depuis leur séparation, variant de 0 à l'infini, souvent utilisée pour construire des arbres phylogénétiques (Nei, 1972).


## 5.4. Test de comparaison 
### 5.4.1. vcf -> bed  : plink ->  qu est ce un format bed ?
- **.bed** est une table de génotypes bialléliques binaires ;
- **.bim** est un fichier d’informations sur les variants accompagnant la table de génotypes binaires .bed. Il s’agit d’un fichier texte sans en-tête, contenant une ligne par variant avec les six champs suivants :


		1. Code chromosomique ;
		2. Identifiant du variant ;
		3. Position en morgans ou centimorgans ;
		4. Coordonnée de la paire de bases ;
		5. Allèle 1 ;
		6. Allèle 2.    	
	    	
    	
- **.fam** est un fichier d'informations sur les échantillons accompagnant la table de génotype binaire .bed. Il s'agit d'un fichier texte sans en-tête, contenant une ligne par échantillon avec les six champs suivants :


		1. Identifiant de la famille (« FID »)
		2. Identifiant intrafamilial (« IID » ; ne peut pas être égal à « 0 »)
		3. Identifiant intrafamilial du père (« 0 » si le père n'est pas présent dans l'ensemble de données)
		4. Identifiant intrafamilial de la mère (« 0 » si la mère n'est pas présente dans l'ensemble de données)
		5. Code du sexe (« 1 » = masculin, « 2 » = féminin, « 0 » = inconnu)
		6. Valeur du phénotype (« 1 » = témoin, « 2 » = cas, « -9 »/« 0 »/non numérique = données manquantes si cas/témoin)

**Source:** [PLINK 1.9: Format](https://www.cog-genomics.org/plink/1.9/formats)


### 5.4.2. Script

```Bash
# 4.2.1. Convert VCF to Genotype matrix (vcf_to_geno.sh)

# Load modules
module load bioinfo-wave
module load bcftools/1.18
module load plink/1.9

# Extract sample order from the initial VCF 
bcftools query -l Calling_ALL_Rotundata_Allc05.vcf  > samples_order.txt

# Samples_order.txt was used to prepare renamed_samples.csv structured as
#	old_name1	new_name1
#	old_name2	new_name2

#sed 's/,/\t/g' renamed_samples.csv > renamed_samples.tsv # to change delimiter


# Rename samples in VCF
bcftools reheader -s renamed_samples.tsv Calling_ALL_Rotundata_Allc05.vcf -o renamed.vcf

# Reorder samples in the VCF
bcftools view -S final_order.txt renamed.vcf -o reordered.vcf

# Convert VCF to BED
plink --vcf reordered.vcf --make-bed --allow-extra-chr --out Africrop

# Export genotype to a simple matrix:
plink --bfile Africrop --recode A --allow-extra-chr --out geno
```

## **Source:** 
- [PLINK 1.9 Home](https://www.cog-genomics.org/plink/1.9/)

## 

```R
# 4.2.2. Distance Jaccard et test de Mantel sous R (mantel_test.R, mantel_test.sh)

load labraries
library(data.table)
library(reshape2)
library(vegan)

cat("\n========== Begining ==========\n")

# Load data
cat("Load geno.raw ...\n")
geno <- fread("geno.raw", header=TRUE, data.table=FALSE)

# Convert to binary (presence/absence)
## Skip the first 6 columns (metadata from PLINK .raw files)
cat("Convert to binary ...\n")
geno_bin <- (geno[,7:ncol(geno)] > 0) * 1


# Jaccard distance
cat("Jaccard distance Method 1 begining ...\n")

## Impute missing values
geno_bin[is.na(geno_bin)] <- 0

## Compute Jaccard distance matrix
cat("Compute Jaccard distance ...\n")
dist_jaccard <- vegdist(geno_bin, method="jaccard", binary = T)


# Save Jaccard distances 
cat("Save Jaccard distance ...\n")
write.csv(dist_jaccard, file = file.path("jaccard_dist.csv"), row.names = TRUE)


# Import Mash distances
cat("Convert mash to mat and dist ...\n")
mash <- read.table("mash_dist_clean.tab", header = FALSE)
colnames(mash) <- c("Query","Ref", "mash_dist", "pvalue", "shared_hashes")
mash_mat <- acast(mash, Query ~ Ref, value.var = "mash_dist") # Casts long table into a matrix


# Convert to dist objects
mash_dist <- as.dist(mash_mat)


# Mantel tests
cat("Mantel test ...\n")
mantel_result <- mantel(mash_dist, dist_jaccard, method = "pearson", permutations = 999)

print(mantel_result)

# Save 
cat("Save results ...\n")
write.csv(mantel_result, file = file.path("mantel_test_result.csv"), row.names = TRUE)


cat("\n========== Done ==========\n")

```
## **Source:** 
- [Man pages for vegan](https://rdrr.io/cran/vegan/man/vegdist.html)
- [Discussion sur vegdist](https://github.com/vegandevs/vegan/issues/153)


### 5.4.3. Resultat
Le **test de Mantel** a révélé une **corrélation positive et significative** entre les distances Mash et les distances Jaccard calculées à partir de données SNP (**r = 0.6394, p = 0.001**), indiquant une concordance entre les approches sans alignement et basées sur les SNP.



## 6. Reponses_6

## 6.1. Conversion du fichier vcf en matrice de genotype (fichier .raw)

```Bash
# Load modules
module load bioinfo-wave
module load bcftools/1.18
module load plink/1.9

# Extract samples name and order from VCF
bcftools query -l Calling_ALL_Rotundata_Allc05.vcf  >  \
	Calling_ALL_Rotundata_Allc05_samples_name.txt

# Calling_ALL_Rotundata_Allc05_samples_name.txt was used to prepare 
#	Calling_ALL_Rotundata_Allc05_samples_renamed.csv with two colums:
#		old_name1 	new_name1
#		old_name2 	new_name2

# Change delimiter
#sed 's/,/\t/g' Calling_ALL_Rotundata_Allc05_samples_rename.csv > \
#	Calling_ALL_Rotundata_Allc05_samples_rename.tsv 

# Rename samples in VCF
bcftools reheader -s Calling_ALL_Rotundata_Allc05_samples_rename.tsv \
	Calling_ALL_Rotundata_Allc05.vcf \
	-o Calling_ALL_Rotundata_Allc05_renamed.vcf

# Reorder samples in the VCF
bcftools view -S mash_order.txt Calling_ALL_Rotundata_Allc05_renamed.vcf \
	-o Calling_ALL_Rotundata_Allc05_reordered.vcf

# Convert VCF to BED
plink --vcf Calling_ALL_Rotundata_Allc05_reordered.vcf \
	--make-bed --allow-extra-chr \
	--out Calling_ALL_Rotundata_Allc05_reordered_plink

# Export genotype to a simple matrix:
plink --bfile Calling_ALL_Rotundata_Allc05_reordered_plink \
	--recode A \
	--allow-extra-chr \
	--out Calling_ALL_Rotundata_Allc05_reordered_geno
```

Le fichier Calling_ALL_Rotundata_Allc05_reordered_plink.bed est un fichier binaire qui stocke les génotypes des variants bialléliques de manière compacte 

Le fichier Calling_ALL_Rotundata_Allc05_reordered_geno.raw obtenu contient une matrice où chaque SNP est codé par:

		- 0 = homozygote référence
		- 1 = hétérozygote
		- 2 = homozygote alternatif
		- NA = donnée manquante


**Source:** [PLINK](https://www.cog-genomics.org/plink/1.9/formats#bed)


## 6.2. Vérification du fichier vcf après avoir renommé et réordonné les échantillons
### 6.2.1. Script

```Bash
# Load modules
module load bioinfo-wave
module load bcftools/1.18

# Compare variants number:
echo "=========== Variants number in Calling_ALL_Rotundata_Allc05.vcf ==============="
bcftools view -H Calling_ALL_Rotundata_Allc05.vcf | wc -l

echo
echo "========= Variants number in Calling_ALL_Rotundata_Allc05_reordered.vcf ======="
bcftools view -H Calling_ALL_Rotundata_Allc05_reordered.vcf | wc -l

echo
echo
# Compare chromosome-position-reference-alternate fields:
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' \
	Calling_ALL_Rotundata_Allc05.vcf > \
	"$OUT_DIR"/original_sites.txt
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' \
	Calling_ALL_Rotundata_Allc05_reordered.vcf > \
	"$OUT_DIR"/reordered_sites.txt

diff original_sites.txt reordered_sites.txt

# Compare headers (except for the sample line):
bcftools view -h Calling_ALL_Rotundata_Allc05.vcf | grep '^##' > \
	"$OUT_DIR"/original_header.txt
bcftools view -h Calling_ALL_Rotundata_Allc05_reordered.vcf | grep '^##' > \
	"$OUT_DIR"/reordered_header.txt

diff original_header.txt reordered_header.txt 

echo
echo

# Compare a few variant lines before and after in order to confirm if 
#   genotype data were stayed attached to the correct samples:

echo "========== Variants in Calling_ALL_Rotundata_Allc05.vcf =========="
bcftools view Calling_ALL_Rotundata_Allc05.vcf | grep -v '^#' | head

echo
echo "===== Variants in Calling_ALL_Rotundata_Allc05_reordered.vcf ====="
bcftools view Calling_ALL_Rotundata_Allc05_reordered.vcf | grep -v '^#' | head
```

### 6.2.2 Output

```Text
$ cat logs/ck_11837.out 
======== Variants number in Calling_ALL_Rotundata_Allc05.vcf ==========
3570940

===== Variants number in Calling_ALL_Rotundata_Allc05_reordered.vcf ===
3570940

$ head reordered_sites.txt 
BDMI01000001.1	7768	C	T
BDMI01000001.1	7781	C	G
BDMI01000001.1	8533	C	G
BDMI01000001.1	8896	G	A
BDMI01000001.1	8923	T	G
BDMI01000001.1	8930	C	A
BDMI01000001.1	8950	G	A
BDMI01000001.1	9044	C	T
BDMI01000001.1	9202	A	G
BDMI01000001.1	9208	T	A

$ head original_sites.txt 
BDMI01000001.1	7768	C	T
BDMI01000001.1	7781	C	G
BDMI01000001.1	8533	C	G
BDMI01000001.1	8896	G	A
BDMI01000001.1	8923	T	G
BDMI01000001.1	8930	C	A
BDMI01000001.1	8950	G	A
BDMI01000001.1	9044	C	T
BDMI01000001.1	9202	A	G
BDMI01000001.1	9208	T	A
```


## 6.3. Effects of imputation SNP missing data 
L'imputation des données manquantes de polymorphisme nucléotidique simple (SNP) modifie la matrice de génotypes et affecte les analyses de distances, de regroupement, d'ordination et de structure de population ([@Sethuraman2026 ; @Geibel2021 ; @Sun2008 ; @Roshyara2014 ; @Georges2023].

Les principales conséquences de l'imputation dépendent de la méthode d'imputation :

- Effets généraux de l'imputation :

	* Diminution des distances génétiques entre les individus;
	* Diminution de l'hétérozygotie observée;
	* Distorsion potentielle du regroupement et de l'ordination;
	* Biais possible dans les fréquences alléliques;
	* Risque accru d'interprétation biologique erronée en cas de forte proportion de données manquantes.

- Imputer les valeurs manquantes par 0 tend à augmenter le nombre d'homozygotes de référence ou d'absences

	* Ceci peut rendre les échantillons artificiellement plus similaires. 
	* Cela peut biaiser à la baisse les distances de Jaccard, de Nei ou euclidienne.


## 6.4. Test de Mantel

### 4.1. Distance Mash (Minhash)
La distance Mash est une distance de mutation par paire ; elle estime le taux de mutation entre deux séquences directement à partir de leurs *sketches* MinHash. Mash estime d'abord l'indice de Jaccard à partir *sketches* MinHash, puis le convertit en une distance évolutive [@Ondov2016]. 
Si j est l'indice de Jaccard estimé et k la taille du k-mer, la distance de Mash est : $D_{Mash}=-\frac{1}{k}\ln\left(\frac{2j}{1+j}\right)$


### 6.4.2. Distances génétiques basées sur les SNP   
Les polymorphismes nucléotidiques simples (SNP) permettent de calculer différentes distances génétiques pour mesurer la parenté, la structure et l'évolution, notamment les distances entre paires de SNP (nombre brut de différences), les métriques de dissimilarité/distance génétique (Nei, Rogers, Hamming) et le déséquilibre de liaison (r²). Ces métriques quantifient les différences entre individus, populations ou régions génomiques.

Types de distances calculé à partir de données SNP:
- Distances par paire SNP (p-distance) : mesure la proportion de loci SNP qui diffère entre deux individus [@Raghuram2023 ; @Vanwallendael2022];
- Distance d’identité par état (IBS) : mesure la similarité allélique directe (nombre d’allèles partagés à chaque locus) [@Mourtala2025];
- Distance de Jaccard : mesure la dissimilarité en se basant uniquement sur les allèles présents partagés, en ignorant les absences partagées [@Russo2024];
- Distance de Nei : distance génétique au niveau de la population basée sur les fréquences alléliques [@Vanwallendael2022 ; @Muktar2023b];
- Distance de Jukes-Cantor : distance de séquence corrigée qui tient compte des substitutions multiples survenant au même site [@Ilyasov2022];
- Distance de Kimura à deux paramètres : la distance de Kimura à deux paramètres est une extension de la distance de Jukes-Cantor qui distingue les transitions des transversions [@Laojun2023].

Distances basées sur les SNP comparées avec la distance de Mash dans de précédantes études:
- distance par paire SNP (p-distance): [@Vanwallendael2022 ; @Raghuram2023];
- distance d’identité par état (IBS): [@Mourtala2025];
- distance de Nei: [@Vanwallendael2022]. 


### 6.4.3. Calcul de distance par paire (pairwise distance) à partir du fichier vcf

```Bash
# Computes pairwise IBS similarity
plink --bfile Calling_ALL_Rotundata_Allc05_reordered_plink \
	--distance square ibs --allow-extra-chr \
	--out ibs_dist
	
# Computes pairwise genetic distance as: 1 - IBS
plink --bfile Calling_ALL_Rotundata_Allc05_reordered_plink \
	--distance square 1-ibs --allow-extra-chr \
	--out pairwise_dist1	
	
plink --bfile Calling_ALL_Rotundata_Allc05_reordered_plink \
	--distance 1-ibs flat-missing square --allow-extra-chr \
	--out pairwise_dist2 
```

- **Sans flat-missing** : PLINK applique sa correction par défaut des données manquantes. Cette correction pondère chaque SNP manquant selon sa contribution moyenne attendue à la distance génétique. Les SNP avec forte variabilité (MAF plus élevée) influencent davantage la correction que les SNP peu variables.

- **Avec flat-missing**: PLINK applique une correction simple et uniforme des données manquantes : chaque SNP manquant contribue de manière identique à l'ajustement, indépendamment de sa fréquence allélique.

**Source:** [PLINK](https://www.cog-genomics.org/plink/1.9/distance)


### 6.4.4. Mantel test
#### 6.4.4.1. Distance IBS et par paire SNP (p-distance) 

```R
# load labraries
library(data.table)
library(reshape2)
library(vegan)

cat("\n========== Begining ==========\n")


# Read sample IDs to name pairwise_dist1 and pairwise_dist2 
sample_id <- read.table("ibs_dist.mibs.id", stringsAsFactors = FALSE)

# Read distance matrices
ibs_mat <- as.matrix(read.table("ibs_dist.mibs"))
pairwise1_mat   <- as.matrix(read.table("pairwise_dist1.mdist"))
pairwise2_mat   <- as.matrix(read.table("pairwise_dist2.mdist"))

# Assign names
rownames(ibs_mat) <- colnames(ibs_mat) <- sample_id$V1
rownames(pairwise1_mat)   <- colnames(pairwise1_mat)   <- sample_id$V1
rownames(pairwise2_mat)   <- colnames(pairwise2_mat)   <- sample_id$V1

# Import Mash distances
mash <- read.table("mash_dist_clean.tab", header = FALSE)
colnames(mash) <- c("Query","Ref", "mash_dist", "pvalue", "shared_hashes")
mash_mat <- acast(mash, Query ~ Ref, value.var = "mash_dist")

# Convert to dist objects
mash_dist <- as.dist(mash_mat)
ibs_dist <- as.dist(ibs_mat)
pairwise1_dist  <- as.dist(pairwise1_mat)
pairwise2_dist  <- as.dist(pairwise2_mat)

# Mantel tests
mantel_result1a <- mantel(mash_dist, ibs_dist, 
	method = "pearson", permutations = 999)
mantel_result1b <- mantel(mash_dist, ibs_dist, 
	method = "spearman", permutations = 999)

mantel_result2a <- mantel(mash_dist, pairwise1_dist, 
	method = "pearson", permutations = 999)
mantel_result2b <- mantel(mash_dist, pairwise1_dist, 
	method = "spearman", permutations = 999)

mantel_result3a <- mantel(mash_dist, pairwise2_dist, 
	method = "pearson", permutations = 999)
mantel_result3b <- mantel(mash_dist, pairwise2_dist, 
	method = "spearman", permutations = 999)

cat("===== IBS distance ===== \n")
print(mantel_result1a)
cat("...\n"
print(mantel_result1b)

cat("===== pairwise distance distance ===== \n")
print(mantel_result2a)
cat("...\n"
print(mantel_result2b)

cat("===== Pairwise distance with flat-missing ===== \n")
print(mantel_result3a)
cat("...\n"
print(mantel_result3b)
```

#### 6.4.4.2. Distance Jaccard

```R
# load labraries
library(data.table)
library(reshape2)
library(vegan)


cat("\n========== Begining ==========\n")

# Import Mash distances
cat("Convert mash to mat and dist ...\n")
mash <- read.table("mash_dist_clean.tab", header = FALSE)
colnames(mash) <- c("Query","Ref", "mash_dist", "pvalue", "shared_hashes")
mash_mat <- acast(mash, Query ~ Ref, value.var = "mash_dist")

# Convert to dist objects
mash_dist <- as.dist(mash_mat)

# Method_1
cat("========== Methode 1: Treat missing data as 0/absence ==========\n")

# 1.1. Load data
cat("Load genotype matrix ...\n")
geno <- fread("Calling_ALL_Rotundata_Allc05_reordered_geno.raw", 
	header=TRUE, data.table=FALSE)

# 1.2. Skip the first 6 columns (metadata from PLINK) 
#	and Keeps only genotype columns
geno_snp <- geno[,7:ncol(geno)]

# 1.3. Impute missing values by 0
cat("Imputation ...\n")
geno_snp[is.na(geno_snp)] <- 0

# 1.4. Convert to binary (presence/absence)
#	Allele presence define as genotype > 0
cat("Convert to binary ...\n")
geno_snp <- (geno_snp > 0) * 1

# 1.5. Compute Jaccard distance matrix
cat("Computing Jaccard distance ... \n")
jaccard_dist <- vegdist(geno_snp, method="jaccard", binary = T)

# 1.6. Mantel tests
cat("Mantel test ...\n")
mantel_result_1 <- mantel(mash_dist, jaccard_dist, 
	method = "pearson", permutations = 999)
	
mantel_result_2 <- mantel(mash_dist, jaccard_dist, 
	method = "spearman", permutations = 999)

# 1.7. Print results
cat("===== Jaccard distance_All missing data impute as 0 =====\n")
print(mantel_result_1)
cat("...\n")
print(mantel_result_2)

# 1.8. Free memory
rm(geno_snp, jaccard_dist, mantel_result_1, mantel_result_2)
gc()

cat("========= Done ==========\n")
```

Deux autres methodes d'imputation ont été utilisées:

```R
# Method_2
cat("Methode 2: Impute missing data by 0 after removing loci with >10% missing\n")

# 2.1. Skip the first 6 columns 
geno_snp <- geno[,7:ncol(geno)]

# 2.2. Remove loci with >10% missing data
geno_snp <- geno_snp[, colMeans(is.na(geno_snp)) <= 0.10]

# 2.3. Replace remaining missing values with 0
geno_snp[is.na(geno_snp)] <- 0

# 2.4. Convert to binary presence/absence
geno_snp <- (geno_snp > 0) * 1


# Method_3
cat("========== Methode 3: No missing data ==========\n")

# 3.1. Skip the first 6 columns 
geno_snp <- geno[,7:ncol(geno)]

# 3.2. Keep only loci with no missing data
geno_snp <- geno_snp[, colSums(is.na(geno_snp)) == 0]

# 3.3. Convert to binary
geno_snp <- (geno_snp > 0) * 1
```

**Source:**

- [Man pages for vegan](https://rdrr.io/cran/vegan/man/vegdist.html)
- [Discussion sur vegdist](https://github.com/vegandevs/vegan/issues/153)


### 6.4.3. Resultat


**Table:** BFcrop merged

| Distances                     | Methode  | r        | p     |  
|-------------------------------|----------|:--------:|:-----:|
| mash_dist and ibs_dist        | Pearson  | -0,6311  | 1     | 
| mash_dist and ibs_dist        | Spearman | -0,6593  | 1     | 
| mash_dist and pairwise1_dist  | Pearson  |  0,6311  | 0,001 | 
| mash_dist and pairwise1_dist  | Spearman |  0,6558  | 0,001 | 
| mash_dist and pairwise2_dist  | Pearson  |  0,6258  | 0,001 | 
| mash_dist and pairwise2_dist  | Spearman |  0,6503  | 0,001 | 
| mash_dist and jaccard_dist1   | Pearson  |    |  | 
| mash_dist and jaccard_dist1   | Spearman |    |  | 
| mash_dist and jaccard_dist2   | Pearson  |    |  | 
| mash_dist and jaccard_dist2   | Spearman |    |  | 
| mash_dist and jaccard_dist3   | Pearson  |  0,6938  | 0,001 | 
| mash_dist and jaccard_dist3   | Spearman |  0,729   | 0,001 | 

- mash_dist:		distance de Mash
- ibs_dist: 		distance IBS
- pairwise1_dist:	distance par paire avec ajustement des données manquantes
- pairwise2_dist:	distance par paire sans ajustement des données manquantes
- jaccard_dist1:	distance de Jaccard avec des données manquantes imputées par 0
- jaccard_dist2:	distance de Jaccard avec une imputation à 0 après la suppession des loci >10% de données manquantes
- jaccard_dist3:	distance de Jaccard sans données manquante


## References














