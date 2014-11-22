bioinfo
=======

split_for_mercator.py
---------------------

Splits a fasta file in chunks for input to mercator annotation system.

correct_mercator_mapping.py
---------------------------

Corrects errors in mercator mapping.

median_values.py
----------------

Calculates median gene expression value from a gene x sample matrix.

undetermined2bed.py
-------------------

Reads a fasta file and outputs a BED file of the undetermined (N) regions

demultiplex.py
--------------

Demultiplex illumina data.

demultiplex.py samples.txt read_1.fastq read_2.fastq read_3.fastq

The samples file is a tab delimited file with two columns. The first one corresponds to the output file name; the second corresponds to the tag sequence.

filter.sh
---------

Filter FASTQ files using seq_crumbs and trimmomatic

bam_prepare.sh
--------------

Convert a SAM file to BAM, sort the BAM file and index it.

bam_qc.sh
---------

Basic QC of a bam file using Picard tools

genome_coverage.sh
------------------

Calculate the genome coverage from a BAM file

exome_coverage.sh
-----------------

Calculate average coverage and coverage at different read depths with bedtools

preprocess_bam.sh
-----------------

Preprocess bam for variant calling (realignment + base recalibration)

variant_call_ug.sh
------------------

Calls variants with Unified Genotypes. Supports multi-sample calling.