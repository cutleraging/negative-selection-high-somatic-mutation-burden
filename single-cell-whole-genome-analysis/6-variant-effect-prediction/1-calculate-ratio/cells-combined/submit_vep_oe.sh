#!/bin/bash

# Define your groups of samples
groups=(
#    "C1_05_24 C2_05_24 C3_05_24"
#    "E1_06_14 E2_06_14 E1_08_16"
#    "E3_06_14 E2_08_16 E3_08_16"
#    "MMEA9_C1 MMEA9_C2 MMEA9_C3 MMEB9_C1 MMEB9_C2 MMEB9_C3"
    "MMEA9_E1 MMEA9_E2 MMEA9_E3 MMEB9_E1 MMEB9_E2 MMEB9_E3"
)

# Loop through each group and submit a job
for group in "${groups[@]}"; do
    echo "$group"
    sbatch vep_oe.sh "$group"
done
