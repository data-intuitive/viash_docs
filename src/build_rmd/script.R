setwd(par$viash_docs)

# start docker daemon
system("dockerd", ignore.stdout = TRUE, ignore.stderr = TRUE, wait = FALSE)

# Rmd files under the root directory
rmds <- c(
  list.files(".", '[.]Rmd$', recursive = TRUE, full.names = TRUE)
)

# remove rmds under examples dir
rmds <- rmds[!grepl("^\\./examples|^\\./_site", rmds)]

# get corresponding mds
mds <- blogdown:::with_ext(rmds, '.md')


for (i in seq_along(rmds)) {
  rmd <- rmds[[i]]
  md <- mds[[i]]

  # if output is not older than input, skip the compilation
  if (blogdown:::require_rebuild(md, rmd)) {
    message('* knitting ', rmd)

    rmarkdown::render(
      input = rmd,
      output_format = rmarkdown::md_document(
        variant = "gfm",
        preserve_yaml = TRUE
      )
    )
  }
}

message('DONE!')
