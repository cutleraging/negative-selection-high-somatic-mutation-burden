#!/bin/bash
#SBATCH -p unlimited
#SBATCH -J dndscv
#SBATCH --cpus-per-task=50
#SBATCH --mem=350G
#SBATCH -o dndscv_%A.log
#SBATCH --error=dndscv_%A.err
#SBATCH -t UNLIMITED
#export LC_ALL=C
#export MALLOC_ARENA_MAX=4

# Initialize Conda
source /gs/gsfs0/hpc01/rhel8/apps/conda3/etc/profile.d/conda.sh
conda activate somatic-mutations

Rscript 240223-dnds-essential-simulation.R
