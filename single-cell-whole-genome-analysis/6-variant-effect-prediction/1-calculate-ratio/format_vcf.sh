#!/bin/bash

#SBATCH --job-name=format_vcf
#SBATCH --output=format_vcf_%j.out
#SBATCH --error=format_vcf_%j.err
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50  # Adjust the number of CPUs based on your needs and system limits
#SBATCH --time=02:00:00
#SBATCH --mem=50G

# Load GNU Parallel module if it's not installed globally (uncomment if needed)
module load parallel

# Directory containing VCF files
VCF_DIR="/gs/gsfs0/shared-lab/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator_output_burden_matched/output"

# Output directory for modified VCF files
OUTPUT_DIR="/gs/gsfs0/shared-lab/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator_output_burden_matched/output_formated"
mkdir -p "$OUTPUT_DIR"

# Function to modify VCF files
modify_vcf() {
    file=$1
    output_dir=$2
    sample_name=$(basename "$file" .vcf)
    output_file="$output_dir/${sample_name}.vcf"

    # Check if the output file already exists
    if [ -f "$output_file" ]; then
        echo "Skipping $output_file as it already exists."
        return
    fi

    {
        echo "##fileformat=VCFv4.3"
        echo -e "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t$sample_name"
        tail -n +2 "$file" | while read -r line; do
            echo -e "$line\t255\tPASS\t.\t.\t."
        done
    } > "$output_file"
}

export -f modify_vcf

# Export necessary variables
export VCF_DIR OUTPUT_DIR

# Find all VCF files and pass each to GNU Parallel
find $VCF_DIR -name '*.vcf' | parallel modify_vcf {} $OUTPUT_DIR
