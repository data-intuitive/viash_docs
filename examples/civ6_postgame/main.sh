#!/bin/bash

# run beforehand:
# viash ns build -s src -t target -P docker --setup

BIN=target/docker/civ6_save_renderer
output_dir="output"

mkdir -p "$output_dir"

for save_file in data/*.Civ6Save; do
  file_basename=$(basename $save_file)
  yaml_file="$output_dir/${file_basename/Civ6Save/yaml}"
  tsv_file="$output_dir/${file_basename/Civ6Save/tsv}"
  pdf_file="$output_dir/${file_basename/Civ6Save/pdf}"
  png_file="$output_dir/${file_basename/Civ6Save/png}"
  
  echo -e "\033[32m>>>>>>> parse header $save_file\e[0m"
  $BIN/parse_header/parse_header -i "$save_file" -o "$yaml_file"
  
  echo -e "\033[32m>>>>>>> parse map $save_file\e[0m"
  $BIN/parse_map/parse_map -i "$save_file" -o "$tsv_file"
  
  echo -e "\033[32m>>>>>>> plot map $save_file\e[0m"
  $BIN/plot_map/plot_map -y "$yaml_file" -t "$tsv_file" -o "$pdf_file"
  
  echo -e "\033[32m>>>>>>> convert plot $save_file\e[0m"
  $BIN/convert_plot/convert_plot -i "$pdf_file" -o "$png_file"
done

echo -e "\033[32m>>>>>>> combine plots\e[0m"
$BIN/combine_plots/combine_plots -i "$output_dir" -o "$output_dir/movie.webm" --framerate 1
