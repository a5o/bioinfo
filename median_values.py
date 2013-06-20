import Tkinter, tkFileDialog
import numpy

root = Tkinter.Tk()
root.withdraw()

file_path = tkFileDialog.askopenfilename()

samples = []
gene2values = {}
for line in open(file_path):
	fields = line.rstrip().split("\t")
	if not samples:
		samples = fields[1:]
	else:
		gene = fields[0]
		if not gene in gene2values:
			gene2values[gene] = {}
			for sample in samples:
				gene2values[gene][sample] = []
		i = 0
		for value in fields[1:]:
			gene2values[gene][samples[i]].append(float(value))
			i += 1

out_path = tkFileDialog.asksaveasfilename()

out_file = open(out_path,"w+")
out_file.write("Gene\t" + "\t".join(samples) + "\n")
for gene in gene2values:
	out_file.write(gene)
	for sample in samples:
		out_file.write("\t" + str(numpy.median(gene2values[gene][sample])))
	out_file.write("\n")
