#!/bin/bash

# Check if the export type is supplied.
if [ -z "$1" ]; then
  echo "::error::Please supply type that needs to be checked."
  exit 1
fi

# Check if the input file name is supplied.
if [ -z "$2" ]; then
  echo "::error::Please supply the input file name."
  exit 1
fi

# Get file name without the location
file_name="$(echo $2 | cut -d '.' -f 1)"

# Generate the file name that needs to be checked
if [ "$1" = "schematic_pdf" ]; then
  file="${file_name}.pdf"
elif [ "$1" = "schematic_svg" ]; then
  file="${file_name}.svg"
elif [ "$1" = "schematic_bom" ]; then
  file="${file_name}-bom.xml"
elif [ "$1" = "schematic_netlist" ]; then
  file="${file_name}.net"
elif [ "$1" = "pcb_step" ]; then
  file="${file_name}.step"
elif [ "$1" = "pcb_pos" ]; then
  file="${file_name}.pos"
elif [ "$1" = "pcb_gerbers" ]; then
  file="${file_name}-gerbers.zip"
elif [ "$1" = "pcb_drill" ]; then
  file="${file_name}.drl"
elif [ "$1" = "pcb_gerbers_drill" ]; then
  file="${file_name}-gerbers.zip"
else
  echo "::error::Type is not correct"
  exit 1
fi

# Check if the file exists
if [ -f "$file" ]; then
    echo "Export is succesfull."
else 
    echo "::error::Export is not succesfull."
    exit 1
fi