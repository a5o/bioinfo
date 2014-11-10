#!/bin/bash

PREFIX=$(basename $1 .bam)
REFERENCE=/home/genomica/data/hg19.chr21.fasta

java -Duser.country=EN -Duser.language=en -Duser.variant=Traditional_WIN \
-jar /opt/picard-tools-1.123/CollectMultipleMetrics.jar \
INPUT=$1 OUTPUT=$PREFIX

java -Duser.country=EN -Duser.language=en -Duser.variant=Traditional_WIN \
-jar /opt/picard-tools-1.123/CollectGcBiasMetrics.jar \
I=$1 O=${PREFIX}.gc_metrics.txt \
CHART=${PREFIX}.gc_metrics.pdf R=$REFERENCE

