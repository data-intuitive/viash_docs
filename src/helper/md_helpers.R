print_file <- function(path, path_text = path, format = "bash", show_filename = TRUE) {
  code <-
    readLines(path, warn = FALSE) %>%
    paste0(collapse = "\n")

  if (show_filename) {
    markdown <- paste0(

      "Contents of [`", path_text, "`](", path, "):\n",
      "```", format, "\n",
      code, "\n",
      "```"
    )
  }
  else {
    markdown <- paste0(
      "```", format, "\n",
      code, "\n",
      "```"
    )
  }


  knitr::asis_output(markdown)
}
