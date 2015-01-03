#!/usr/bin/env python

import sys
from Bio import SeqIO

def usage():
	sys.stderr.write("USAGE: " + sys.argv[0] + " <idslist_filename> <input_filename> <input_format> <output_filename> <output_format>\n")
	exit()

def main():
	if not sys.argv[5:]:
		usage()	
	id_list = sys.argv[1]
	in_fname = sys.argv[2]
	in_fmt = sys.argv[3]
	out_file = open(sys.argv[4],"w+")
	out_fmt = sys.argv[5]
	sys.stderr.write("Indexing file...\n")
	in_index = SeqIO.index(in_fname,in_fmt)
	sys.stderr.write("Retrieving sequences...\n")
	for sid in open(id_list):
		#sys.stderr.write(sid + "\n")
		out_file.write(in_index[sid.rstrip("\n")].format(out_fmt))


if __name__ == "__main__":
	main()
