# generate-kicad-files

> ⚠️ **This repository is archived and no longer maintained.**  
> Please use my new and improved all in one [KiCad action](https://github.com/marketplace/actions/kicad-actions).

The schematic and PCB export action for KiCad projects.

> **_NOTE:_** Minimal KiCad version is 7.0.

# Usage

See [action.yml](action.yml)

```yaml
steps:
  - uses: actions/checkout@v3
  - uses: actions-for-kicad/setup-kicad@v1
    with:
      version: "8.0"
  - uses: actions-for-kicad/generate-kicad-files@v1
    with:
      file: "./file.kicad_sch"
      type: "schematic_pdf"
      black-and-white: true
  - name: Upload
    uses: actions/upload-artifact@v4
    with:
      name: "file.pdf"
      path: "./file.pdf"
```

## Inputs

### `file`

Required: `True`

Description: The location to the schematic or PCB file.

### `type`

Required: `True`

Description: Export type, choose one of the following:

- schematic_pdf
- schematic_svg
- schematic_bom
- schematic_netlist
- pcb_step
- pcb_pos
- pcb_gerbers
- pcb_drill
- pcb_gerbers_drill

### `layers`

Required: `False`

The layers that need to be exported in a comma separated list. Example: "F.Cu,B.cu". If no layers are given, all layers are exported.
This input can be used when exporting the following types:

- pcb_gerbers
- pcb_gerbers_drill

### `black-and-white`

Required: `False`
Default: `False`

Export schematic in black and white.
The black-and-white option be used when exporting the following types:

- schematic_pdf
- schematic_svg

# License

The scripts and documentation in this project are released under the [GNU license](LICENSE).

# Contributions

Contributions are welcome! Please help me expand and maintain this repository.
