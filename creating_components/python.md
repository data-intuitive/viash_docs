---
title: "Creating a Python component"
parent: Creating components
---

## Developing a new component

The first step of developing this component, is writing the core
functionality of the component, in this case a Python script.

#### Write a script in Python

This is a simple script which prints a simple message, along with any
input provided to it through the `par["input"]` parameter. Optionally,
you can override the greeter with `par["greeter"]`.

Contents of [`script.py`](script.py):

``` python
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

    Hello world! I am debug!

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
