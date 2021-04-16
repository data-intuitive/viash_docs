print_file <- function(path, path_text = path, format = "bash") {
  code <-
    readLines(path) %>%
    paste0(collapse = "\n")

  markdown <- paste0(
    "Contents of [`", path_text, "`](", path, "):\n",
    "```", format, "\n",
    code, "\n",
    "```"
  )
  knitr::asis_output(markdown)
}
