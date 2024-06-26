#!/bin/bash

#SBATCH -p large-mem
#SBATCH -J create_simulated_cells
#SBATCH --cpus-per-task=25
#SBATCH --mem=1000G
#SBATCH -o create_simulated_cells_%A.log
#SBATCH --error=create_simulated_cells_%A.err
#SBATCH -t UNLIMITED
#export LC_ALL=C
#export MALLOC_ARENA_MAX=4

# Initialize Conda
source /gs/gsfs0/hpc01/rhel8/apps/conda3/etc/profile.d/conda.sh
conda activate somatic-mutations

Rscript /gs/gsfs0/shared-lab/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator_output_burden_matched/match_mutation_burden_sim_cells_submit.R
