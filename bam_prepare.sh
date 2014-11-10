#!/bin/bash

PREFIX=$(basename $1 .sam)

samtools view -bS $1 >$PREFIX.bam
samtools sort $PREFIX.bam $PREFIX.sort
samtools index $PREFIX.sort.bam
