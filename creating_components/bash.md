---
title: "Creating a Bash component"
parent: Creating components
---

## Developing a new component

The first step of developing this component, is writing the core
functionality of the component, in this case a bash script.

#### Write a script in Bash

This is a simple script which prints a simple message, along with any
input provided to it through the `par_input` parameter. Optionally, you
can override the greeter with `par_greeter`.

Contents of [`script.sh`](script.sh):

``` bash
## VIASH START
par_input="I am debug!"
par_greeter="Hello world!"
## VIASH END

echo $par_greeter $par_input
```

Anything between the `## VIASH START` and `## VIASH END` lines will
automatically be replaced at runtime with parameter values from the CLI.
Anything between these two lines can be used to test the script without
viash:

``` bash
./script.sh
```

    ## ./script.sh: line 5: $'\r': command not found
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
  name: hello_world
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
  - type: bash_script
    path: script.sh
  tests:
  - type: bash_script
    path: test.sh
platforms:
  - type: native
  - type: docker
    image: bash:4.0
  - type: docker
    id: alpine
    image: alpine
    setup:
      - type: apk
        packages: [ bash ]
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

Contents of [`test.sh`](test.sh):

``` bash
set -ex # exit the script when one of the checks fail.

# check 1
echo ">>> Checking whether output is correct"
./hello_world I am viash! > output.txt

[[ ! -f output.txt ]] && echo "Output file could not be found!" && exit 1
grep -q 'Hello world! I am viash!' output.txt

# check 2
echo ">>> Checking whether output is correct when no parameters are given"
./hello_world > output2.txt

[[ ! -f output2.txt ]] && echo "Output file could not be found!" && exit 1
grep -q 'Hello world!' output2.txt

# check 3
echo ">>> Checking whether output is correct when more parameters are given"
./hello_world General Kenobi. --greeter="Hello there." > output3.txt

[[ ! -f output3.txt ]] && echo "Output file could not be found!" && exit 1
grep -q 'Hello there. General Kenobi.' output3.txt

echo ">>> Test finished successfully!"
exit 0 # don't forget to put this at the end
```

When running the test, viash will automatically build an executable and
place it – along with other resources and test resources – in a
temporary working directory.
