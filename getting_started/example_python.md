---
title: "Python example"
parent: Getting started
---

This vignette demonstrates how to wrap a simple ‘hello world’ Python
script with viash.

## Demonstration

Given the files and meta files in the
[examples/hello\_world\_py](https://github.com/data-intuitive/viash_docs/tree/master/examples/hello_world_py)
directory, we demonstrate the functionality of viash in running the
component with multiple backends.

#### Run the component

By running the component, it will output “Hello world!”, followed by any
other inputs provided to it.

``` bash
cd examples/hello_world_py
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

    ## > docker build -t hello_world_py:latest /tmp/viashsetupdocker-hello_world_py-bmKcfp

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
output/hello_world_py And now, as an executable.
```

    ## Hello world! And now, as an executable.

#### viash automatically generates a CLI

By running the command with a `--help` flag, more information about the
component is provided.

``` bash
output/hello_world_py --help
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

    ## Running tests in temporary directory: '/tmp/viash_test_hello_world_py4005516778975781919'
    ## ====================================================================
    ## +/tmp/viash_test_hello_world_py4005516778975781919/build_executable/hello_world_py ---setup
    ## > docker build -t hello_world_py:latest /tmp/viashsetupdocker-hello_world_py-KNfAeb
    ## ====================================================================
    ## +/tmp/viash_test_hello_world_py4005516778975781919/test_test.py/test.py
    ## 
    ## ----------------------------------------------------------------------
    ## Ran 0 tests in 0.000s
    ## 
    ## OK
    ## ====================================================================
    ## [32mSUCCESS! All 1 out of 1 test scripts succeeded![0m
    ## Cleaning up temporary directory

## Developing a new component

The first step of developing this component, is writing the core
functionality of the component, in this case a Python script.

#### Write a script in Python

This is a simple script which prints a simple message, along with any
input provided to it through the `par["input"]` parameter. Optionally,
you can override the greeter with `par["greeter"]`.

Contents of [`script.py`](script.py):

``` bash
## VIASH START
par = {
  "input": ["I am debug!"],
  "greeter": "Hello world!"
}

## VIASH END

if par["input"] is None:
  par["input"] = []

print(par["greeter"], *par["input"])
```

Anything between the `## VIASH START` and `## VIASH END` lines will
automatically be replaced at runtime with parameter values from the CLI.
Anything between these two lines can be used to test the script without
viash:

``` bash
python script.py
```

    ## Hello world! I am debug!

Next, we write a meta-file describing the functionality of this
component in YAML format.

#### Describe the component with as a YAML

A [viash config](config) file describes the behaviour of a script and
the platform it runs on. It consists of two main sections:
`functionality` and `platforms`.

Contents of [`yaml`](config.vsh.yaml):

``` bash
functionality:
  name: hello_world_py
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
  - type: python_script
    path: script.py
  tests:
  - type: python_script
    path: test.py
platforms:
  - type: native
  - type: docker
    image: "python:3.8"
```

The [functionality](config/functionality) section describes the core
functionality of the component, such as its inputs, outputs, arguments,
and extra resources. For each of the arguments, specifying a description
and a set of argument restrictions help create a useful command-line
interface. To ensure that your component works as expected, writing one
or more tests is essential.

The platforms section specifies the requirements to execute the
component on zero or more platforms. The list of currently supported
platforms are [Native](config/platform-native),
[Docker](config/platform-docker), and
[Nextflow](config/platform-nextflow). If no platforms are specified, a
native platform with no system requirements is assumed.

### Writing a first unit test

Writing a unit test for a viash component is relatively simple. You just
need to write a Bash script (or R, or Python) which runs the executable
multiple times, and verifies the output. Take note that the test needs
to produce an error code not equal to 0 when a mistake is found.

Contents of [`test.py`](test.py):

``` bash
import unittest
import os
from os import path
import subprocess

class Tester(unittest.TestCase):
    def simple_test(self):
        out = subprocess.check_output(["./hello_world_py", "I", "am", "viash"]).decode("utf-8")
        self.assertEqual(out, "Hello world! I am viash\n")
        
    def less_params(self):
        out = subprocess.check_output(["./hello_world_py"]).decode("utf-8")
        self.assertEqual(out, "Hello world!\n")
        
    def simple_test(self):
        out = subprocess.check_output(["./hello_world_py", "General", "Kenobi", "--greeter=Hello there."]).decode("utf-8")
        self.assertEqual(out, "Hello there. General Kenobi.\n")

unittest.main()
```

When running the test, viash will automatically build an executable and
place it – along with other resources and test resources – in a
temporary working directory.
