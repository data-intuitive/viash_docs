
options(tidyverse.quiet = TRUE)
library(tidyverse)
library(httr, quietly = TRUE)
library(rvest, quietly = TRUE)

# Depends on pandoc local package

### 1 ###

## VIASH START
par <- list(
  inputfile = "Testfile.md",
  domain = "https://viash.io",
  output = "output.txt"
)

## VIASH END

temp_html <- tempfile(fileext = ".html")
on.exit(file.remove(temp_html)) # remove tempfile after scripts exits to make sure it's always removed


# Convert the markdown file to html
rmarkdown::render(input = par$inputfile, output_format = "html_document", output_file = temp_html, quiet = TRUE, runtime="static")
html <- rvest::read_html(temp_html)

cat("Extracting URLs\n")

### 2 ###

# Extract the titles and URLs from the converted html file and put the results in arrays
urls <- html %>% html_elements("a") %>%
  html_attr("href")
titles <- html %>% html_elements("a") %>%
  html_text()

# Convert the markdown file to html
cat("Checking", length(urls), "URLs\n")

amount_of_errors <- 0
expected_code <- "200"

### 3 ###

# Iterate over the array of URLs and check each of them
outputs <- map_df(seq_along(urls), function(i) {
  url <- urls[i]
  title <- titles[i]

  ### 4 ###

  # If an URL doesn't start with 'http', add the domain before it
  if (!grepl("^https?://", url)) {
    url = paste0(par$domain, url)
  }

  cat(i, ": ", url, "\n", sep = "")

  output <- tibble(
    url,
    title,
  )

  ### 5 ###

  # Do a web request and get the status code
  output$status <-
    tryCatch({
      code <- status_code(GET(url))
      if (code == expected_code) {
        "OK"
      } else {
        paste0("ERROR! URL cannot be reached. Status code:")
      }
    },
    error = function(cond) {
      "ERROR! URL does not seem to exist!"
    },
    warning = function(cond) {
      "ERROR! URL caused a warning!"
    })

  output
})

print(outputs)

content <- paste0(
  "Link name: ", outputs$title, "\n",
  "URL: ", outputs$url, "\n",
  outputs$status, "\n",
  "---\n"
)

write_lines(content, par$output)

cat("")
cat("Input '", par$inputfile, "' has been checked and a report named '", par$output, "' has been generated.\n", sep = "")
cat(sum(outputs$status != "OK"), " out of ", nrow(outputs), " URLs could not be reached.\n", sep = "")
