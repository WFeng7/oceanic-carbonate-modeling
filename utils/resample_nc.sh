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

# Create a temporary grid file for 0.25x0.25 degree resolution
gridfile=$(mktemp)

cat > "$gridfile" << EOF
gridtype = lonlat
xsize    = 1440
ysize    = 720
xfirst   = 0.125
xinc     = 0.25
yfirst   = -89.875
yinc     = 0.25
EOF

# Iterate over each NetCDF file in the input directory
for file in "$input_dir"/*.nc; do
    # Get the filename without the directory path
    filename=$(basename "$file")
    
    # Output file path in the specified output directory
    output_file="$output_dir/resampled_$filename"
    
    # Resample the file using the custom grid
    echo "Resampling $file to custom 0.25x0.25 degree resolution (lon: 0.125-359.875, lat: -89.875-89.875)..."
    
    # CDO command for remapping to the custom grid
    cdo remapbil,"$gridfile" "$file" "$output_file"
    
    echo "Resampled file saved as $output_file"
done

# Clean up temporary grid file
rm "$gridfile"

echo "All files have been resampled to $output_dir."