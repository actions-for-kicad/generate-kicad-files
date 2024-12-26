#!/bin/bash

# Check if kicad is installed
kicad_version="$(kicad-cli --version)"
if [ -z "$kicad_version" ]; then
  echo "::error::Please make sure kicad is installed"
  exit 1
fi

# Parse all variables
file_name=""
black_and_white=false
type=""
layers=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --black-and-white)
            if [[ "$2" == "false" ]]; then
                black_and_white=false
                shift
            else
                black_and_white=true
            fi
            ;;
        --type) type="$2"; shift ;;
        --layers) layers="$2"; shift ;;
        *) file_name="$1" ;;
    esac
    shift
done

# Check if the file name is supplied.
if [ -z "$file_name" ]; then
  echo "::error::Please supply source file"
  exit 1
fi

# Check if the export type is supplied.
if [ -z "$type" ]; then
  echo "::error::Please supply type"
  exit 1
fi

# Get the fil_name without file type
file_name="$(echo $file_name | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1)"

# Export the schematic
if [ "$type" = "schematic_pdf" ]; then
  if $black_and_white; then
    kicad-cli sch export pdf --black-and-white "$file_name"
  else
    kicad-cli sch export pdf "$file_name"
  fi
elif [ "$type" = "schematic_svg" ]; then
  if $black_and_white; then
    kicad-cli sch export svg --black-and-white "$file_name"
  else
    kicad-cli sch export svg "$file_name"
  fi
elif [ "$type" = "schematic_bom" ]; then
  kicad-cli sch export python-bom "$file_name"
elif [ "$type" = "schematic_netlist" ]; then
  kicad-cli sch export netlist "$file_name"
elif [ "$type" = "pcb_step" ]; then
  kicad-cli pcb export step --subst-models "$file_name"
elif [ "$type" = "pcb_pos" ]; then
  kicad-cli pcb export pos "$file_name"
elif [ "$type" = "pcb_gerbers" ]; then
  kicad-cli pcb export gerbers -l "$layers" "$file_name"
  zip "${$file_name}-gerbers.zip" *.g*
elif [ "$type" = "pcb_drill" ]; then
  kicad-cli pcb export drill "$file_name"
elif [ "$type" = "pcb_gerbers_drill" ]; then
  kicad-cli pcb export gerbers -l "$layers" "$file_name"
  kicad-cli pcb export drill "$file_name"
  zip "${$file_name}-gerbers.zip" *.g* *.drl
else
  echo "::error::Type is not correct"
  exit 1
fi

# Give error if the export is failed
if [ "$?" != "0" ]; then
  echo "::error::Export failed."
  exit 1
fi