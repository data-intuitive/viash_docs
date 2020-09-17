### VIASH START
par <- list(
  input = "examples/knit/tests/input.Rmd",
  output = "examples/knit/tests/input.md"
)
resources_dir <- "."
### VIASH END

library(rmarkdown)
render(
  input = par$input,
  output_format = github_document(html_preview = FALSE),
  output_file = basename(par$output),
  output_dir = dirname(par$output)
)
