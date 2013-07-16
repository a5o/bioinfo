#!/usr/bin/env python

import sys
from Bio import SeqIO

for record in SeqIO.parse(open(sys.argv[1]),"fasta"):
	i = 0
	c = 0
	for base in str(record.seq).upper():
		
		if base == "N":
			c += 1
		else:
			if c >= 10:
				sys.stdout.write("\t".join([record.id,str(i-c),str(i)]) + "\n")
			c = 0
		if i == len(record.seq)-1 and c >= 10:
			sys.stdout.write("\t".join([record.id,str(i-c),str(i)]) + "\n")
		i += 1	

