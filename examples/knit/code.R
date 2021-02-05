library(rmarkdown)

# retrieve format function
# (need to check whether other packages need to be loaded; 
# most used formats are inside rmarkdown).
format_fun <- get(par$format)

# check which parameters apply to this function
format_args <- par[names(par) %in% formalArgs(format_fun)]

cat("Running ", par$format, "() with args:\n", sep = "")
print(format_args)

# apply args to function
output_format <- do.call(format_fun, format_args)

render(
  input = par$input,
  output_format = output_format,
  output_file = basename(par$output),
  output_dir = dirname(par$output)
)
