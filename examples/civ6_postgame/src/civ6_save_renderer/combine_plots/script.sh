#!/bin/bash

# render movie
ffmpeg -framerate $par_framerate -f image2 -i "$par_input/%*.png" -c:v libvpx-vp9 -pix_fmt yuva420p -y "$par_output"
