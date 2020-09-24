# assume tidyverse is installed
options(tidyverse.quiet = TRUE)
library(tidyverse)
library(testthat, warn.conflicts = FALSE)


test_that("Checking whether output is correct", {
  out <- processx::run("./knit", c("input.Rmd", "out/myoutput.md"))
  
  expect_true(file.exists("out/myoutput.md"))
  
  output <- readr::read_file("out/myoutput.md")
  expect_match(output, '131')
  expect_match(output, 'Doing some major calculations here.')
  expect_match(output, 'Input document')
})

test_that("Checking whether output is correct with minimal parameters", {
  out <- processx::run("./knit", c("input.Rmd"))
  
  expect_true(file.exists("input.md"))
  
  output <- readr::read_file("input.md")
  expect_match(output, '131')
  expect_match(output, 'Doing some major calculations here.')
  expect_match(output, 'Input document')
})
