#!/bin/bash

# input table contains vcf files in first column and corresponding bed files in second column
input_table=/gs/gsfs0/users/rcutler/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/input_table.txt
output_dir=/gs/gsfs0/users/rcutler/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator_output
script=/gs/gsfs0/users/rcutler/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator.sh

mkdir $output_dir

# Read the file line by line
while IFS=$'\t' read -r vcf_file bed_file
do
    # Skip the header line
    if [ "$vcf_file" == "vcf" ]; then
        continue
    fi

    # Here you can use the variables $vcf_file and $bed_file
    echo "Processing VCF: $vcf_file, BED: $bed_file"

    name="$(basename "$vcf_file")"

    sbatch --exclude=cpu-752 --job-name="SigProfilerSimulator.${name}.out" --output="SigProfilerSimulator.${name}.out" --error="SigProfilerSimulator.${name}.err" $script $vcf_file $bed_file $output_dir

done < "$input_table"