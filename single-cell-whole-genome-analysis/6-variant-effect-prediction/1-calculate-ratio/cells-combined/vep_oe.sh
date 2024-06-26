#!/bin/bash

#SBATCH -p quick
#SBATCH -J "vep_oe"
#SBATCH --cpus-per-task=50
#SBATCH --mem=100G
#SBATCH -o "vep_oe_%A.log"
#SBATCH --error="vep_oe_%A.err"
#SBATCH -t 4:00:00

# Initialize Conda
source /gs/gsfs0/hpc01/rhel8/apps/conda3/etc/profile.d/conda.sh
conda activate somatic-mutations

# Run R script with sample as argument
echo $1
Rscript -e "rmarkdown::render('vep_oe.Rmd', params = list(group = '$1'))"

