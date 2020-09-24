build_one <- function(rmd, md) {
  # if output is not older than input, skip the compilation
  if (!blogdown:::require_rebuild(md, rmd)) return()

  message('* knitting ', rmd)
  if (blogdown:::Rscript(shQuote(c('R/build_one.R', rmd, md))) != 0) {
    unlink(md)
    stop('Failed to compile ', rmd, ' to ', md)
  }
}

# Rmd files under the root directory
rmds <- c(
  list.files('.', '[.]Rmd$', recursive = TRUE, full.names = TRUE)
)

# remove rmds under examples dir
rmds <- rmds[!grepl("^\\./examples|^\\./_site", rmds)]

# get corresponding mds
mds <- blogdown:::with_ext(rmds, '.md')


for (i in seq_along(rmds)) {
  build_one(rmds[[i]], mds[[i]])
}
system2('jekyll', 'build')
