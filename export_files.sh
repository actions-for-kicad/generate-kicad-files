#!/bin/bash

# Check if the input variables are present
if [ -z "$1" ]; then
  echo "::error::Please supply source file"
  exit 1
fi

if [ -z "$2" ]; then
  echo "::error::Please supply type"
  exit 1
fi

# Check if kicad is installed
kicad_version="$(kicad-cli --version)"
if [ -z "$kicad_version" ]; then
  echo "::error::Please make sure kicad is installed"
  exit 1
fi

# Export the schematic
if [ "$2" = "schematic_pdf" ]; then
  kicad-cli sch export pdf "$1"
elif [ "$2" = "schematic_svg" ]; then
  kicad-cli sch export svg "$1"
elif [ "$2" = "schematic_bom" ]; then
  kicad-cli sch export python-bom "$1"
elif [ "$2" = "pcb_step" ]; then
  kicad-cli pcb export step --subst-models "$1"
else
  echo "::error::Type is not correct"
  exit 1
fi

if [ "$?" != "0" ]; then
  echo "::error::Export failed"
  exit 1
fi