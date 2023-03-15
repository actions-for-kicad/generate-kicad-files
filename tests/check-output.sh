#!/bin/bash

if [ -z "$1" ]; then
  echo "::error::Please supply type that needs to be checked."
  exit 1
fi

if [ -z "$2" ]; then
  echo "::error::Please supply the input file."
  exit 1
fi

file_path="$(echo $2 | cut -d '.' -f 1)"

if [ "$1" = "schematic_pdf" ]; then
  file="${file_path}.pdf"
# elif [ "$1" = "schematic_svg" ]; then
#   kicad-cli sch export svg "$1"
# elif [ "$1" = "pcb_step" ]; then
#   kicad-cli pcb export step --subst-models "$1"
else
  echo "::error::Type is not correct"
  exit 1
fi

if [ -f "$file" ]; then
    echo "Export is succesfull."
else 
    echo "Export is not succesfull."
    exit 1
fi