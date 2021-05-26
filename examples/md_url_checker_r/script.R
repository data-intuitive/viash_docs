library(httr)
library(knitr)
library(rvest)

# Depends on tidyverse r package
# Depends on pandoc local package

### 1 ###

## VIASH START
par <- list(
  inputfile = "Testfile.md",
  domain = "http://www.data-intuitive.com/viash_docs",
  output = "output.txt",
  temp_html = "temp.html"
)

knitr::opts_chunk$set(message = FALSE)

## VIASH END

# Convert the markdown file to html
rmarkdown::render(input = par$inputfile, output_format = "html_document", output_file = par$temp_html, quiet = TRUE, runtime="static")
html <- read_html(par$temp_html)

cat("Extracting URLs\n")

### 2 ###

# Extract the titles and URLs from the converted html file and put the results in arrays
urls <- html %>% html_elements("a") %>%
  html_attr("href")
titles <- html %>% html_elements("a") %>%
  html_text()

# Convert the markdown file to html
amount_of_urls <- length(urls)
cat("Checking", amount_of_urls, "URLs\n")

# Clear file
write("",file=par$output)

amount_of_errors <- 0
index <- 0
expected_code <- "200"

### 3 ###

# Iterate over the array of URLs and check each of them
for (i in urls){
  url <- urls[index+1]
  title <- titles[index+1]

  ### 4 ###

  # If an URL doesn't start with 'http', add the domain before it
  if (!grepl( "http", url, fixed = TRUE)) {
    url = paste0(par$domain, url)
  }

  message(paste(index+1, url, sep = ": "))

  write(paste("Link name:", title),file=par$output, append = TRUE)
  write(paste("URL:", url),file=par$output, append = TRUE)

  ### 5 ###

  # Do a web request and get the status code
  tryCatch(
    {
      r <- GET(url)
      statuscode <- status_code(r)

      # Check if status code obtained via cURL contains the expected code
      if (statuscode == expected_code) {
        message("OK")
        write("OK", file=par$output, append = TRUE)
      }  else {
        message(statuscode)
        write(paste("ERROR! URL cannot be reached. Status code:", statuscode),file=par$output, append = TRUE)
        amount_of_errors = amount_of_errors + 1
      }
    },
    error=function(cond) {
      message(paste("URL does not seem to exist!"))
      write("ERROR! URL does not seem to exist!", file=par$output, append = TRUE)
      amount_of_errors = amount_of_errors + 1
    },
    warning=function(cond) {
      message(paste("URL caused a warning!"))
      write("ERROR! URL caused a warning", file=par$output, append = TRUE)
      amount_of_errors = amount_of_errors + 1
    }
  )

  write("---", file=par$output, append = TRUE)
  index = index+1
}

message("")
message(paste(par$inputfile, "has been checked and a report named", par$output, "has been generated."))
message(paste(amount_of_errors, "of", amount_of_urls, "URLs could not be resolved."))
