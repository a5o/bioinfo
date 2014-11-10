#!/bin/bash

EXOMEBED=/home/genomica/alberto/chr21_exons.sort.merge.bed
PREFIX=$(basename $1 .bam)

function coverage {
	FILTER="{if (\$2 >= $2){a+=\$3}}END {print a*100/\$4}"
	grep "^all" $1 | awk -f <(echo $FILTER)
}

coverageBed -split -hist \
-abam $1 \
-b $EXOMEBED \
>${PREFIX}.exons.coverage.txt

AVGCOV=$(grep "^all" ${PREFIX}.exons.coverage.txt| awk '{a+=$3*$2} END {print a/$4}')
echo "La copertura media e' $AVGCOV" 

shift

for i in $*
do
	COV=$(coverage ${PREFIX}.exons.coverage.txt $i)
	echo "Il ${COV}% dell'esoma e' coperto ad una profondita' >= $i"
done

