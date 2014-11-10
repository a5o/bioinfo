#!/usr/bin/env python

import sys

def outfiles(filename):
	tag2file	= {}
	for line in open(filename):
		name,tag = line.rstrip().split("\t")
		tag2file[tag] = [open(name + "_1.fastq","w+"),open(name + "_2.fastq","w+")]
	return tag2file
		
class Fastq:
	def __init__(self,filename):
		self.f = open(filename)
	def __iter__(self):
		return self
	def next(self):
		seqid = self.f.readline().rstrip()
		#print(seqid)
		if seqid:
			sequence = self.f.readline().rstrip()
			self.f.readline()
			qual = self.f.readline().rstrip()
			return seqid,sequence,qual
		else:
			raise StopIteration()

def distance(seq1,seq2):
	d = 0
	for i in range(len(seq1)):
		if seq1[i] != seq2[i]:
			d += 1
	# print(d)
	return d
			
if __name__ == "__main__":
	tag2file = outfiles(sys.argv[1])
	read1 = Fastq(sys.argv[2])
	read2 = Fastq(sys.argv[3])
	read3 = Fastq(sys.argv[4])
	while True:
		try:
			r1 = read1.next()
			tag = read2.next()
			r3 = read3.next()
			for knowntag in tag2file:
				if distance(tag[1],knowntag) <= 1:
					tag2file[knowntag][0].write("\n".join([r1[0],r1[1],"+",r1[2]]) + "\n")
					tag2file[knowntag][1].write("\n".join([r3[0],r3[1],"+",r3[2]]) + "\n")
		except StopIteration:
			break