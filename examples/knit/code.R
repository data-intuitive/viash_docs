library(rmarkdown)
render(
  input = par$input,
  output_format = md_document(preserve_yaml = par$preserve_yaml),
  output_file = basename(par$output),
  output_dir = dirname(par$output)
)
