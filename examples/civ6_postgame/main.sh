#!/bin/bash

# run beforehand:
# viash ns build -P docker --setup
# viash ns build -P nextflow

BIN=target/docker/civ6_save_renderer
input_dir="data"
output_dir="output"

mkdir -p "$output_dir"

function msg {
  echo -e "\033[32m>>>>>>> $1\e[0m"
}

for save_file in $input_dir/*.Civ6Save; do
  file_basename=$(basename $save_file)
  yaml_file="$output_dir/${file_basename/Civ6Save/yaml}"
  tsv_file="$output_dir/${file_basename/Civ6Save/tsv}"
  pdf_file="$output_dir/${file_basename/Civ6Save/pdf}"
  png_file="$output_dir/${file_basename/Civ6Save/png}"
  
  if [ ! -f "$yaml_file" ]; then
    msg "parse header '$save_file'"
    $BIN/parse_header/parse_header -i "$save_file" -o "$yaml_file"
  fi
  
  if [ ! -f "$tsv_file" ]; then
    msg "parse map '$save_file'"
    $BIN/parse_map/parse_map -i "$save_file" -o "$tsv_file"
  fi
  
  if [ ! -f "$pdf_file" ]; then
    msg "plot map '$save_file'"
    $BIN/plot_map/plot_map -y "$yaml_file" -t "$tsv_file" -o "$pdf_file"
  fi
  
  if [ ! -f "$png_file" ]; then
    msg "convert plot '$save_file'"
    $BIN/convert_plot/convert_plot -i "$pdf_file" -o "$png_file"
  fi
done

png_inputs=`find "$output_dir" -name "*.png" | sed "s#.*#&:#" | tr -d '\n' | sed 's#:$#\n#'`

msg "combine plots"
$BIN/combine_plots/combine_plots -i "$png_inputs" -o "$output_dir/movie.webm" --framerate 1
