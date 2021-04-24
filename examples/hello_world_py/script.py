## VIASH START
par = {
  "input": ["I am debug!"],
  "greeter": "Hello world!"
}

## VIASH END

if par["input"] is None:
  par["input"] = []

print(par["greeter"], *par["input"])