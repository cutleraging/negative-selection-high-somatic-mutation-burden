#!/bin/bash

# Directory containing the CSV files
dir="/gs/gsfs0/users/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/variant-effect-prediction/cells-combined"

# Prepare the directory for combined results
mkdir -p "$dir/combined_results"

# Navigate to the directory
cd "$dir"

# Use an associative array to track files by suffix and their headers
declare -A file_headers

# Loop through all CSV files in the directory
for file in *.csv; do
    # Extract the sample name
    sample=$(echo "$file" | sed -E 's/^([A-Z0-9_]+)_.*$/\1/')
    # Extract the suffix by removing the sample part
    suffix=$(echo "$file" | sed -E 's/^[A-Z0-9_]+_(.+\.csv)$/\1/')

    # Check if this is the first time we are encountering this suffix
    if [[ -z "${file_headers[$suffix]}" ]]; then
        # Extract and store header
        header=$(head -1 "$file")
        # Write the header with an additional "sample" column to a new file
        echo "$header,sample" > "combined_results/$suffix"
        # Save the header in the associative array
        file_headers[$suffix]="$header"
    fi
    # Append data with the sample name, skip the header line
    tail -n +2 "$file" | awk -v sample="$sample" '{print $0 "," sample}' >> "combined_results/$suffix"
done

# Output results
echo "Combined files are located in: $dir/combined_results"
ls -l "$dir/combined_results"
