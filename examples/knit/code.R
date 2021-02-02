library(rmarkdown)

if (par$format == "md_document") {
  par$format <- md_document(
    preserve_yaml = par$preserve_yaml, 
    variant = par$variant
  )
} else if (par$format == "github_document") {
  par$format <- github_document(html_preview = FALSE)
}

render(
  input = par$input,
  output_format = par$format,
  output_file = basename(par$output),
  output_dir = dirname(par$output)
)
