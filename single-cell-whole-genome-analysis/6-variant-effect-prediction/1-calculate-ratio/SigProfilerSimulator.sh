#!/bin/bash

#SBATCH -p unlimited
#SBATCH -J SigProfilerSimulator_cell
#SBATCH -n 1
#SBATCH --mem=350G
#SBATCH -o SigProfilerSimulator_cell_%A.log
#SBATCH --error=SigProfilerSimulator_cell_%A.err
#SBATCH -t UNLIMITED

source /gs/gsfs0/hpc01/rhel8/apps/conda3/etc/profile.d/conda.sh
conda activate SigProfilerSimulator

vcf_file=$1
bed_file=$2
output_dir=$3

filename="$(basename "$vcf_file")"
name=${filename%.*}


# top level output ir
mkdir $output_dir

# create output dir for each and copy vcf to this as sigprofilersim will output to this
mkdir $output_dir/$name
cp $vcf_file $output_dir/$name

# run sigprofilersim
python runSigProfilerSimulator.py $name $output_dir/$name $bed_file