#!/bin/bash

ffmpeg -framerate $par_framerate -i "concat:$(echo $par_input | tr ':' '|')" -c:v libvpx-vp9 -pix_fmt yuva420p -y "$par_output"
