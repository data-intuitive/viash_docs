---
title: "R example"
parent: Getting started
---

This vignette demonstrates how to wrap a simple ‘hello world’ R script
with viash.

## Demonstration

Given the files and meta files in the
[examples/hello\_world\_r](examples/hello_world_r) directory, we
demonstrate the functionality of viash in running the component with
multiple backends.

#### Run the component

By running the component, it will output “Hello world\!”, followed by
any other inputs provided to it.

``` bash
cd examples/hello_world_r
viash run config.vsh.yaml -- I am viash!
```

    ## Hello world! I am viash!

#### Run the component with a Docker backend

It can also be run with a Docker backend by specifying the `-p` or
`--platform` parameter.

First, you need to let viash set up the Docker container by pulling it
from Docker Hub.

``` bash
viash run config.vsh.yaml -p docker -- ---setup
```

    ## > docker pull rocker/tidyverse:4.0.4
    ## 4.0.4: Pulling from rocker/tidyverse
    ## Digest: sha256:d36d7b206800cca1984524e677b2732214002b36ef28a8ffae005d4c92eb62d2
    ## Status: Image is up to date for rocker/tidyverse:4.0.4
    ## docker.io/rocker/tidyverse:4.0.4

You can run the component with viash in the backend as follows.

``` bash
viash run config.vsh.yaml -p docker -- General Kenobi. --greeter="Hello there."
```

    ## Hello there. General Kenobi.

#### Export as an executable

Now that we know what the component does, we can export the
functionality as an executable.

``` bash
viash build config.vsh.yaml -p docker -o output
output/hello_world And now, as an executable.
```

    ## Hello world! And now, as an executable.

#### viash automatically generates a CLI

By running the command with a `--help` flag, more information about the
component is provided.

``` bash
output/hello_world_r --help
```

    ## A very simple 'Hello world' component.
    ## 
    ## Options:
    ##     string1 string2 ...
    ##         type: string, multiple values allowed
    ## 
    ##     --greeter=string
    ##         type: string, default: Hello world!

#### viash allows testing the component

To verify that the component works, use `viash test`. This can be run
both with or without the Docker backend.

``` bash
viash test config.vsh.yaml -p docker
```

    ## Running tests in temporary directory: '/home/rcannood/workspace/viash_temp/viash_test_hello_world_r3305100981094722073'
    ## ====================================================================
    ## +/home/rcannood/workspace/viash_temp/viash_test_hello_world_r3305100981094722073/build_executable/hello_world_r ---setup
    ## > docker pull rocker/tidyverse:4.0.4
    ## 4.0.4: Pulling from rocker/tidyverse
    ## Digest: sha256:d36d7b206800cca1984524e677b2732214002b36ef28a8ffae005d4c92eb62d2
    ## Status: Image is up to date for rocker/tidyverse:4.0.4
    ## docker.io/rocker/tidyverse:4.0.4
    ## ====================================================================
    ## +/home/rcannood/workspace/viash_temp/viash_test_hello_world_r3305100981094722073/test_test.R/test.R
    ## >>> Checking whether output is correct
    ## >>> Checking whether output is correct when no parameters are given
    ## >>> Checking whether output is correct when more parameters are given
    ## >>> Test finished successfully!
    ## ====================================================================
    ## [32mSUCCESS! All 1 out of 1 test scripts succeeded![0m
    ## Cleaning up temporary directory

## Developing a new component

The first step of developing this component, is writing the core
functionality of the component, in this case an R script.

#### Write a script in R

This is a simple script which prints a simple message, along with any
input provided to it through the `par["input"]` parameter. Optionally,
you can override the greeter with `par["greeter"]`.

Contents of [`script.R`](script.R):

``` bash
## VIASH START
par <- list(
  input = "I am debug!",
  greeter = "Hello world!"
)

## VIASH END

cat(par$greeter, " ", paste(par$input, collapse = " "), "\n", sep = "")
```

Anything between the `## VIASH START` and `## VIASH END` lines will
automatically be replaced at runtime with parameter values from the CLI.
Anything between these two lines can be used to test the script without
viash:

``` bash
Rscript script.R
```

    ## Hello world! I am debug!

Next, we write a meta-file describing the functionality of this
component in YAML format.

#### Describe the component with as a YAML

A [viash config](/config) file describes the behaviour of a script and
the platform it runs on. It consists of two main sections:
`functionality` and `platforms`.

Contents of [`yaml`](config.vsh.yaml):

``` bash
functionality:
  name: hello_world_r
  description: A very simple 'Hello world' component.
  arguments:
  - type: string
    name: input
    multiple: true
    multiple_sep: " "
  - type: string
    name: --greeter
    default: "Hello world!"
  resources:
  - type: r_script
    path: script.R
  tests:
  - type: r_script
    path: test.R
platforms:
  - type: native
  - type: docker
    image: "rocker/tidyverse:4.0.4"
```

The [functionality](/config/functionality) section describes the core
functionality of the component, such as its inputs, outputs, arguments,
and extra resources. For each of the arguments, specifying a description
and a set of argument restrictions help create a useful command-line
interface. To ensure that your component works as expected, writing one
or more tests is essential.

The platforms section specifies the requirements to execute the
component on zero or more platforms. The list of currently supported
platforms are [Native](/config/platform-native),
[Docker](/config/platform-docker), and
[Nextflow](/config/platform-nextflow). If no platforms are specified, a
native platform with no system requirements is assumed.

### Writing a first unit test

Writing a unit test for a viash component is relatively simple. You just
need to write a Bash script (or R, or Python) which runs the executable
multiple times, and verifies the output. Take note that the test needs
to produce an error code not equal to 0 when a mistake is found.

Contents of [`test.R`](test.R):

``` bash
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
```

When running the test, viash will automatically build an executable and
place it – along with other resources and test resources – in a
temporary working directory.
