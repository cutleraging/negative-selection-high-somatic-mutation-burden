#!/usr/bin/env python

import sys
from SigProfilerSimulator import SigProfilerSimulator as sigSim

name = sys.argv[1]
vcf_dir = sys.argv[2]
bed = sys.argv[3].strip()

sigSim.SigProfilerSimulator(name, \
  vcf_dir, \
  "GRCh37", \
  contexts=["96", "ID"], \
  exome=None, \
  simulations=20000, \
  updating=False, \
  bed_file=bed, \
  overlap=False, \
  gender='female', \
  chrom_based=False, \
  seed_file=None, \
  noisePoisson=False, \
  cushion=100, \
  region=None, \
  vcf=True)