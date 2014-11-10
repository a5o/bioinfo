#!/bin/bash

#genome_coverage.sh <bamfile> [depth_threshold1] [depth_threshold2] [...]

GENOME=/home/genomica/data/chr21.genome
PREFIX=$(basename $1 .bam)

# funzione che computa il numero di basi del genoma coperte
# ad una data profondita'
# ha 2 parametri: <file di coverage> <soglia>
function covered_bases {
	FILTER="{ if (\$2 >= $2) {s+=\$3}} END {print s} "
	echo $FILTER
	grep "genome" $1 |awk -f <(echo $FILTER)
}

# genero un file ocn il coverage delle basi
genomeCoverageBed -split -ibam $1 \
-g $GENOME \
>${PREFIX}.genomeCoverage.txt

shift # rimuovo il primo parametro (nome del bam) 
      # dalla lista di parametri

# per ogni valore di coverage applico la funzione
# covered_bases
for i in $* 
do 
	covered_bases ${PREFIX}.genomeCoverage.txt $i
done
