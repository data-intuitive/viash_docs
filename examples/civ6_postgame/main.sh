#!/bin/bash

# run beforehand:
# viash ns build -s src -t target -P docker --setup

BIN=target/docker/civ6_save_renderer
output_dir="output"

mkdir -p "$output_dir"

function msg {
  echo -e "\033[32m>>>>>>> $1\e[0m"
}

for save_file in data/*.Civ6Save; do
  file_basename=$(basename $save_file)
  yaml_file="$output_dir/${file_basename/Civ6Save/yaml}"
  tsv_file="$output_dir/${file_basename/Civ6Save/tsv}"
  pdf_file="$output_dir/${file_basename/Civ6Save/pdf}"
  png_file="$output_dir/${file_basename/Civ6Save/png}"
  
  msg "parse header '$save_file'"
  $BIN/parse_header/parse_header -i "$save_file" -o "$yaml_file"
  
  msg "parse map '$save_file'"
  $BIN/parse_map/parse_map -i "$save_file" -o "$tsv_file"
  
  msg "plot map '$save_file'"
  $BIN/plot_map/plot_map -y "$yaml_file" -t "$tsv_file" -o "$pdf_file"
  
  msg "convert plot '$save_file'"
  $BIN/convert_plot/convert_plot -i "$pdf_file" -o "$png_file"
done

msg "combine plots"
$BIN/combine_plots/combine_plots -i "$output_dir" -o "$output_dir/movie.webm" --framerate 1
