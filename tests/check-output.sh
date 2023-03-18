#!/bin/bash

if [ -z "$1" ]; then
  echo "::error::Please supply type that needs to be checked."
  exit 1
fi

if [ -z "$2" ]; then
  echo "::error::Please supply the input file name."
  exit 1
fi

file_name="$(echo $2 | cut -d '.' -f 1)"

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
else
  echo "::error::Type is not correct"
  exit 1
fi

if [ -f "$file" ]; then
    echo "Export is succesfull."
else 
    echo "::error::Export is not succesfull."
    exit 1
fi