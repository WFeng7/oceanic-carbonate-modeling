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
        
        # Check if ncks was successful
        if [ $? -ne 0 ]; then
            echo "Failed to process $file with ncks."
            continue
        fi

        # Remap the grid resolution
        cdo remapbil,r1440x720 "$temp_file" "$file"
        
        # Check if cdo was successful
        if [ $? -ne 0 ]; then
            echo "Failed to remap $file with cdo."
            continue
        fi

        # Remove the temporary file
        rm "$temp_file"
        
        echo "$file processed successfully."
    else
        echo "No NetCDF files found in the directory."
    fi
done

echo "All files processed."
