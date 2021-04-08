## VIASH START
par <- list(
  input = "I am debug!",
  greeter = "Hello world!"
)

## VIASH END

cat(par$greeter, " ", paste(par$input, collapse = " "), "\n", sep = "")
