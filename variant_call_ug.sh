#!/bin/bash

PICARD=/opt/picard-tools-1.123
HG19=/home/genomica/data/ucsc.hg19.fasta
JAVA=/opt/jre1.7.0_67/bin/java
GATK=/opt/GenomeAnalysisTK-3.3-0.jar
DBSNP=/home/genomica/data/dbsnp_138.hg19.vcf
KNOWNINDELS=/home/genomica/data/Mills_and_1000G_gold_standard.indels.hg19.vcf
TEMP=/tmp

OUTPUT=$1

shift

INPUT=""
for f in $*
do
	INPUT=$(echo ${INPUT} -I $f)
done


$JAVA -Xmx4G -jar $GATK -nt 10 -T UnifiedGenotyper -R $HG19 -glm BOTH $INPUT -o $OUTPUT
