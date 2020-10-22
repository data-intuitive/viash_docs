#!/bin/bash

#inputs=`echo $par_input | sed "s#:#' -i '#g"`
#eval ffmpeg -framerate $par_framerate -f image2 -i "'$inputs'" -c:v libvpx-vp9 -pix_fmt yuva420p -y "'$par_output'"

ffmpeg -f concat -safe 0 -i <(echo $par_input | tr ':' '\n' | sed "s#.*#file &#") -framerate $par_framerate -c:v libvpx-vp9 -pix_fmt yuva420p -y "$par_output"
