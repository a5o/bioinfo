#!/bin/bash

PREFIX=$(basename $1 .bam)
PICARD=/opt/picard-tools-1.123
HG19=/home/genomica/data/ucsc.hg19.fasta
JAVA=/opt/jre1.7.0_67/bin/java
JAVAOPTS="-Xmx4G -Duser.country=EN -Duser.language=en -Duser.variant=Traditional_WIN"
GATK=/opt/GenomeAnalysisTK-3.3-0.jar
DBSNP=/home/genomica/data/dbsnp_138.hg19.vcf
KNOWNINDELS=/home/genomica/data/Mills_and_1000G_gold_standard.indels.hg19.vcf
TEMP=/tmp

echo "START " $(date -R)

echo "Fixing mates information " $(date -R)
$JAVA $JAVAOPTS -jar $PICARD/FixMateInformation.jar \
I=$1 \
O=${PREFIX}.fixmate.bam \
TMP_DIR=$TEMP \
SO=coordinate \
VALIDATION_STRINGENCY=LENIENT

echo "Marking duplicates " $(date -R)
$JAVA $JAVAOPTS -jar $PICARD/MarkDuplicates.jar \
VALIDATION_STRINGENCY=SILENT \
TMP_DIR=$TEMP \
MAX_RECORDS_IN_RAM=2000000 \
INPUT=${PREFIX}.fixmate.bam OUTPUT=${PREFIX}.dedup.bam METRICS_FILE=duplicates.txt CREATE_INDEX=true;

echo "Creating realignment targets " $(date -R)
$JAVA $JAVAOPTS -jar $GATK -nt 10 -T RealignerTargetCreator \
-R $HG19 \
-I ${PREFIX}.dedup.bam \
-known $KNOWNINDELS \
-o ${PREFIX}.intervals

echo "Realign indels " $(date -R)
$JAVA $JAVAOPTS -jar $GATK -nt 1 -T IndelRealigner \
-R $HG19 \
-I ${PREFIX}.dedup.bam \
-known $KNOWNINDELS \
-targetIntervals ${PREFIX}.intervals \
-o ${PREFIX}.realigned.bam
# https://www.broadinstitute.org/gatk/events/2038/GATKwh0-BP-2-Realignment.pdf

echo "Analyzing pre-calibration patterns of covariation  " $(date -R)
$JAVA $JAVAOPTS -jar $GATK -nt 1 -T BaseRecalibrator \
-I ${PREFIX}.realigned.bam \
-R $HG19 \
-knownSites $DBSNP \
-known $KNOWNINDELS \
-o ${PREFIX}.grp

echo "Analyzing post-calibration patterns of covariation in the original data " $(date -R)
$JAVA $JAVAOPTS -jar $GATK -nt 1 -T BaseRecalibrator \
-I ${PREFIX}.realigned.bam \
-R $HG19 \
-knownSites $DBSNP \
-known $KNOWNINDELS \
-BQSR ${PREFIX}.grp  \
-o ${PREFIX}_post.grp

echo "Generating plots " $(date -R)
$JAVA $JAVAOPTS -jar $GATK -T AnalyzeCovariates \
-R $HG19 \
-before ${PREFIX}.grp \
-after ${PREFIX}_post.grp \
-plots ${PREFIX}_recal_plot.pdf

echo "Saving recalibrated data " $(date -R)
$JAVA $JAVAOPTS -jar $GATK -nt 1 -T PrintReads \
-R $HG19 \
-I ${PREFIX}.realigned.bam \
-BQSR ${PREFIX}.grp \
-o ${PREFIX}.recalibrated.bam

echo "END " $(date -R)
