#!/bin/bash

#SBATCH -p normal
#SBATCH -J calculate-ratio
#SBATCH --cpus-per-task=50
#SBATCH --mem=350G
#SBATCH -o calculate-ratio_%A.log
#SBATCH --error=calculate-ratio_%A.err
#SBATCH -t 48:00:00
#export LC_ALL=C
#export MALLOC_ARENA_MAX=4

# Initialize Conda
source /gs/gsfs0/hpc01/rhel8/apps/conda3/etc/profile.d/conda.sh
conda activate somatic-mutations

Rscript 
