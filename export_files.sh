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

# Get the file_name without file type
file_name="$(echo $file_name | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1)"

echo "filename: $file_name"

# Function to export schematic
export_schematic() {
  local format=$1
  if $black_and_white; then
    kicad-cli sch export "$format" --black-and-white "$file_name"
  else
    kicad-cli sch export "$format" "$file_name"
  fi
}

# Export based on type
case $type in
  schematic_pdf) export_schematic pdf ;;
  schematic_svg) export_schematic svg ;;
  schematic_bom) kicad-cli sch export python-bom "$file_name" ;;
  schematic_netlist) kicad-cli sch export netlist "$file_name" ;;
  pcb_step) kicad-cli pcb export step --subst-models "$file_name" ;;
  pcb_pos) kicad-cli pcb export pos "$file_name" ;;
  pcb_gerbers)
    kicad-cli pcb export gerbers -l "$layers" "$file_name"
    zip "${file_name}-gerbers.zip" *.g*
    ;;
  pcb_drill) kicad-cli pcb export drill "$file_name" ;;
  pcb_gerbers_drill)
    kicad-cli pcb export gerbers -l "$layers" "$file_name"
    kicad-cli pcb export drill "$file_name"
    zip "${file_name}-gerbers.zip" *.g* *.drl
    ;;
  *)
    echo "::error::Type is not correct"
    exit 1
    ;;
esac

# Give error if the export failed
if [ "$?" != "0" ]; then
  echo "::error::Export failed."
  exit 1
fi