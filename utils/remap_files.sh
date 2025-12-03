#!/bin/bash

# Process each NetCDF file in the directory
for file in *.nc; do
    # Check if the file exists
    if [ -f "$file" ]; then
        # Define temporary file name
        temp_file="bad.nc"
        
        # Remove the 'palette' variable and save to temporary file
        echo "Processing $file..."
        ncks -O -x -v palette "$file" "$temp_file"
        
        # Remap the grid resolution
        cdo remapbil,r1440x720 "$temp_file" "$file"
        
        # Remove the temporary file
        rm "$temp_file"
        
        echo "$file processed."
    else
        echo "No NetCDF files found."
    fi
done

echo "Processing complete."
