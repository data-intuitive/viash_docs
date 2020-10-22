#!/bin/bash

NXF_VER=20.04.1-edge nextflow run . \
  --input "data/*.Civ6Save" \
  --output out/ \
  -resume

