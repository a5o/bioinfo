#!/usr/bin/env python

import sys

from Bio import SeqIO

accumulator = []
total_length = 0

chunk = 1

def print_accumulator(chunk_n):
    outfile = open("chunk_" + str(chunk) + ".fas", "w+")
    for record in accumulator:
        outfile.write(record.format("fasta"))
    outfile.close()

for record in SeqIO.parse(sys.argv[1],"fasta"):
    if total_length + len(str(record.seq)) > 30E+6:
        print_accumulator(chunk)
        accumulator=[]
        total_length = 0
        chunk += 1
    accumulator.append(record)
    total_length += len(str(record.seq))
    sys.stderr.write(str(total_length) + "\n")

print_accumulator(chunk)
