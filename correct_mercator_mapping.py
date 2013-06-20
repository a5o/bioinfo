#!/usr/bin/env python

import sys

bincodes = {}

for line in open(sys.argv[1]):
	bincode,name,identifier,description,type = "","","","",""
	fields = line.rstrip().split("\t")
	if fields[0]:
		bincode = fields[0]
	if fields[1:]:
		name = fields[1]
	if fields[2:]:
		identifier = fields[2]
	if fields[3:]:
		description = fields[3]
	if fields[4:]:
		type = fields[4]
	
	if not bincode in bincodes:
		bincodes[bincode] = name
	else:
		if name != bincodes[bincode]:
			type = description
			description = identifier
			identifier = name[name.find("VIT"):]
			name = bincodes[bincode]
	print("\t".join([bincode,name,identifier,description,type]))