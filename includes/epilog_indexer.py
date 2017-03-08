#!/usr/bin/env python

"""
This script will index a fasta file for all positions that match a given
substring (or substrings). It's used by the methylation caller Epilog to index
the CG sites (or other sites) you would like to make methylation calls for; but
it could be used to find all occurrences of a substring in a genome for other
purposes. The output is a 3 column file with chromosome, position, and substring
found.
"""

__author__ = "Nathan C. Sheffield"
__credits__ = []
__license__ = "GPL3"
__version__ = "0.1"
__email__ = "nathan@code.databio.org"

# Requires the new regex library because it can handle overlapping matches
try:
	import regex as re
except:
	print("You need to install the new python 'regex' package.")
	raise SystemExit(1)

import os

from argparse import ArgumentParser

parser = ArgumentParser(description="Fasta substring indexer")
parser.add_argument("-i", "--infile", dest="infile",
		required=True,
		help="Input file (in FASTA format)")

parser.add_argument("-s", "--string", dest="string", default="CG",
 		required=False,
		nargs="+",
		help="Substring(s) to index. You can include just one, or multiple \
		space-separated strings to index. e.g. 'CG' or 'CG CA CT CC'")

parser.add_argument("-o", "--outfile", dest="outfile",
		required=False, default=None,
		help="Output file. Defaults to 'infile_index.tsv'")

parser.add_argument("-f", "--outfolder", dest="outfolder",
		required=False, default="",
		help="Output folder. Defaults to current working directory")

parser.add_argument('-m', '--limit', dest='limit',
		help="Limit to these chromosomes", nargs = "+", default=None)

parser.add_argument('-t', '--tabix', dest='tabix',
		help="Try to use bgzip/tabix to compress/index the posititions after finding them",
		action="store_true", default=False)



args = parser.parse_args()

if args.outfile is None:
	args.outfile = os.path.splitext(args.infile)[0] + "_"  + "index.tsv"

args.outfile = os.path.join(args.outfolder, args.outfile)

if not os.path.exists(os.path.dirname(args.outfile)):
    os.makedirs(os.path.dirname(args.outfile))

def write_index(seqname, seq, strings, index_file):
	"""
	Finds and then writes the indexes of the substrings
	"""
	if len(seq) > 1:
		tups = []
		for string in strings:
			positions = [m.start() for m in re.finditer(string, seq.upper(), overlapped=True)]
			positions_rev = [m.end()-1 for m in re.finditer(reverse_complement(string), seq.upper(), overlapped=True)]
			tups += zip(positions, ["+"] * len(positions), [string] * len(positions))
			tups += zip(positions_rev, ["-"] * len(positions_rev),  [string] * len(positions_rev))
			print("indexed " + str(len(positions) + len(positions_rev)) + " " + string + " sites")

		# Sort by position
		tups = sorted(tups, key=lambda x: x[0])

		# print(tups)
		for t in tups:
			index_file.write(seqname + "\t" + str(t[0]) + "\t" + t[1] + "\t" + t[2] + "\n")


def complement(sequence):
	"""
	Returns the complement of a DNA sequence without reversing the string.
	"""
	seq_dict = {'A':'T', 'T':'A', 'G':'C', 'C':'G', 'N':'N'}
	return "".join([seq_dict[base] for base in sequence])


def reverse_complement(sequence):
	"""
	Returns reverse complement of a DNA string.
	"""
	seq_dict = {'A':'T', 'T':'A', 'G':'C', 'C':'G', 'N':'N'}
	return "".join([seq_dict[base] for base in reversed(sequence)])


if __name__ == "__main__":
	seq = ""
	seqname = ""
	index_file = open(args.outfile, "w")
	infile = open(args.infile)


	# Check to make sure the tabix command exist:
	if args.tabix:
		import subprocess
		try: subprocess.check_output("which bgzip", shell=True)
		except:
			raise Exception("bgzip is not in your PATH. Unable to compress for tabix index.")
		try: subprocess.check_output("which tabix", shell=True)
		except:
			raise Exception("tabix is not in your PATH. Unable to compress for tabix index.")
		print("Dependencies for tabix conversion met.")
	for line in infile:
		if line[:1] == ">":
			# We have a new chromosome; write out the old one.
			new_seqname = line[1:].split()[0]
			if args.limit and not new_seqname in args.limit:
				process = False
			else:
				process = True

			write_index(seqname, seq, args.string, index_file)

			# Reset the name and purge the sequence variable.
			seqname = new_seqname
			seq = ""
			print(new_seqname)

		else:
			# append (collect) the sequences into a single variable.
			if process:
				seq = seq + line.rstrip()


	# Write out the last chromosome
	write_index(seqname, seq, args.string, index_file)
	index_file.close()

	# Did the user request a Tabix index?
	if (args.tabix):
		import subprocess
		print("Compressing position file...")
		cmd = "bgzip " + args.outfile
		print(cmd)
		subprocess.call(cmd, shell=True)
		print("Indexing position file with tabix...")
		cmd = "tabix -s 1 -b 2 -e 2 "  + args.outfile + ".gz"
		print(cmd)
		subprocess.call(cmd, shell=True)
		print("Outfile: " + args.outfile + ".gz")
	else:
		print("Outfile: " + args.outfile)




