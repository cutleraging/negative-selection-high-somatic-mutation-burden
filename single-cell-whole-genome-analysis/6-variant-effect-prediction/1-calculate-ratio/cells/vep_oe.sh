#!/bin/bash

#SBATCH -p quick
#SBATCH -J "vep_oe"
#SBATCH --cpus-per-task=50
#SBATCH --mem=100G
#SBATCH -o "vep_oe_%A.log"
#SBATCH --error="vep_oe_%A.err"
#SBATCH -t 1:00:00

# Initialize Conda
source /gs/gsfs0/hpc01/rhel8/apps/conda3/etc/profile.d/conda.sh
conda activate somatic-mutations

# Run R script with sample as argument
Rscript -e "rmarkdown::render('/gs/gsfs0/users/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/variant-effect-prediction/vep_oe.Rmd', params = list(sample = '$1'))"

