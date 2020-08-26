### VIASH START
par <- list(
  input = "index.Rmd"
  output = "output.md"
)
resources_dir <- "."
### VIASH END

# get absolute path to file
path <- normalizePath(par$output, mustWork = FALSE)

# render markdown
knitr::knit(par$input, output = par$output)
