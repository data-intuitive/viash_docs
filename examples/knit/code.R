### VIASH START
par <- list(
  input = "index.Rmd"
  output = "output.md"
)
resources_dir <- "."
### VIASH END

# input/output filenames are passed as two additional arguments to Rscript
d = gsub('^_|[.][a-zA-Z]+$', '', par$input)
knitr::opts_chunk$set(
  fig.path   = sprintf('figure/%s/', d),
  cache.path = sprintf('cache/%s/', d)
)
options(digits = 4)
knitr::opts_knit$set(width = 70)

  # render markdown
knitr::knit(par$input, quiet = TRUE, encoding = 'UTF-8', envir = .GlobalEnv)
