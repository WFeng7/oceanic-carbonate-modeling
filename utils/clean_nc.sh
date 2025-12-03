#!/bin/bash

# Check if input and output directories are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
fi

# Input and output directories
input_dir="$1"
output_dir="$2"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate over each NetCDF file in the input directory
for file in "$input_dir"/*.nc; do
    # Get the filename without the directory path
    filename=$(basename "$file")
    
    # Output file path in the specified output directory
    output_file="$output_dir/cleaned_$filename"
    
    # Delete the 'palette' variable and 'processing_control' group
    echo "Processing $file: Removing 'palette' variable and 'processing_control' group..."
    
    # ncks command to exclude the variable 'palette' and group 'processing_control'
    ncks -C -x -v palette "$file" "$output_file"
    
    echo "Cleaned file saved as $output_file"
done

echo "All files have been processed and cleaned."