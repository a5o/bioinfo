#!/bin/sh

PREFIX=$(basename $1 _1.fastq.gz)

interleave_pairs -o $PREFIX.fastq.gz \
-z $1 $2

filter_by_quality -o $PREFIX.filter.fastq.gz \
-z -q 20 --paired_reads $PREFIX.fastq.gz

filter_by_complexity -o $PREFIX.complexity.fastq.gz\
 -c 7 --paired_reads $PREFIX.filter.fastq.gz

filter_duplicates -o $PREFIX.dedup.fastq.gz -z \
-e $PREFIX.dedup_filtered.fastq.gz \
--paired_reads $PREFIX.complexity.fastq.gz

deinterleave_pairs \
-o ${PREFIX}_1.dedup.fastq.gz ${PREFIX}_2.dedup.fastq.gz \
-z $PREFIX.dedup.fastq.gz

gunzip ${PREFIX}_1.dedup.fastq.gz ${PREFIX}_2.dedup.fastq.gz

java -jar /opt/Trimmomatic-0.32/trimmomatic-0.32.jar PE \
-threads 2 \
-phred33 \
-trimlog trimmomatic.log \
${PREFIX}_1.dedup.fastq ${PREFIX}_2.dedup.fastq \
${PREFIX}_1.trim.fastq ${PREFIX}_1.trim.single.fastq \
${PREFIX}_2.trim.fastq ${PREFIX}_2.trim.single.fastq \
ILLUMINACLIP:/opt/Trimmomatic-0.32/adapters/NexteraPE-PE.fa:2:30:10 \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:4:20 \
MINLEN:50

