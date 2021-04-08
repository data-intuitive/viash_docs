library(testthat)
library(processx)

# check 1
cat(">>> Checking whether output is correct\n")
out <- processx::run("./hello_world_r", c("I", "am", "viash!"))
expect_equal(out$status, 0)
expect_match(out$stdout, regexp = "Hello world! I am viash!")

# check 2
cat(">>> Checking whether output is correct when no parameters are given\n")
out <- processx::run("./hello_world_r")
expect_equal(out$status, 0)
expect_match(out$stdout, regexp = "Hello world!")

# check 3
cat(">>> Checking whether output is correct when more parameters are given\n")
out <- processx::run("./hello_world_r", args = c("General", "Kenobi.", "--greeter=Hello there."))
expect_equal(out$status, 0)
expect_match(out$stdout, regexp = "Hello there. General Kenobi.")

cat(">>> Test finished successfully!\n")
