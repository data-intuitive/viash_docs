#!/bin/bash

node /home/node/civ6save-editing/scripts/savetomaptsv.js "$par_input" "$par_output"
mv "$par_output.tsv" "$par_output"
