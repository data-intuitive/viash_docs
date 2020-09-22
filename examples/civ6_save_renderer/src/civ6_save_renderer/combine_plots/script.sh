#!/bin/bash

# convert pdfs to png
for file in $par_input/*.pdf; do
  convert "$file" "${file/pdf/png}"
done

# render movie
ffmpeg -framerate 4 -f image2 -i "$par_input/%*.png" -c:v libvpx-vp9 -pix_fmt yuva420p "$par_output"
