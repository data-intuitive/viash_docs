---
title: "Bash example"
parent: Getting started
---

This vignette demonstrates how to wrap a simple ‘hello world’ bash
script with viash.

## Demonstration

Given the files and meta files in the
[examples/hello\_world](https://github.com/data-intuitive/viash_docs/tree/master/examples/hello_world)
directory, we demonstrate the functionality of viash in running the
component with multiple backends.

#### Run the component

By running the component, it will output “Hello world!”, followed by any
other inputs provided to it.

``` bash
cd examples/hello_world
viash run config.vsh.yaml -- I am viash!
```

    ## /tmp/viash-run-hello_world-cKfehe: line 7: ﻿#!/usr/bin/env: No such file or directory
    ## Hello world! I am viash!

#### Run the component with a Docker backend

It can also be run with a Docker backend by specifying the `-p` or
`--platform` parameter.

First, you need to let viash set up the Docker container by pulling it
from Docker Hub.

``` bash
viash run config.vsh.yaml -p docker -- ---setup
```

    ## > docker build -t hello_world:latest /tmp/viashsetupdocker-hello_world-Meoadl

You can run the component with viash in the backend as follows.

``` bash
viash run config.vsh.yaml -p docker -- General Kenobi. --greeter="Hello there."
```

    ## Hello there. General Kenobi.
    ## /viash_automount/tmp//viash-run-hello_world-cCLneB: line 7: ﻿#!/usr/bin/env: No such file or directory

#### Export as an executable

Now that we know what the component does, we can export the
functionality as an executable.

``` bash
viash build config.vsh.yaml -p docker -o output
output/hello_world And now, as an executable.
```

    ## /viash_automount/tmp//viash-run-hello_world-McPCMN: line 7: ﻿#!/usr/bin/env: No such file or directory
    ## Hello world! And now, as an executable.

#### viash automatically generates a CLI

By running the command with a `--help` flag, more information about the
component is provided.

``` bash
output/hello_world --help
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

    ## Running tests in temporary directory: '/tmp/viash_test_hello_world184391355153468467'
    ## ====================================================================
    ## +/tmp/viash_test_hello_world184391355153468467/build_executable/hello_world ---setup
    ## > docker build -t hello_world:latest /tmp/viashsetupdocker-hello_world-AcaLfJ
    ## ====================================================================
    ## +/tmp/viash_test_hello_world184391355153468467/test_test.sh/test.sh
    ## >>> Checking whether output is correct
    ## + echo '>>> Checking whether output is correct'
    ## + ./hello_world I am 'viash!'
    ## /tmp/viash-run-hello_world-fepaAl: line 7: ﻿#!/usr/bin/env: No such file or directory
    ## + [[ ! -f output.txt ]]
    ## + grep -q 'Hello world! I am viash!' output.txt
    ## + echo '>>> Checking whether output is correct when no parameters are given'
    ## >>> Checking whether output is correct when no parameters are given
    ## + ./hello_world
    ## /tmp/viash-run-hello_world-DGiOlM: line 7: ﻿#!/usr/bin/env: No such file or directory
    ## + [[ ! -f output2.txt ]]
    ## + grep -q 'Hello world!' output2.txt
    ## + echo '>>> Checking whether output is correct when more parameters are given'
    ## >>> Checking whether output is correct when more parameters are given
    ## + ./hello_world General Kenobi. '--greeter=Hello there.'
    ## /tmp/viash-run-hello_world-PFFJBn: line 7: ﻿#!/usr/bin/env: No such file or directory
    ## + [[ ! -f output3.txt ]]
    ## + grep -q 'Hello there. General Kenobi.' output3.txt
    ## + echo '>>> Test finished successfully!'
    ## >>> Test finished successfully!
    ## + exit 0
    ## ====================================================================
    ## [32mSUCCESS! All 1 out of 1 test scripts succeeded![0m
    ## Cleaning up temporary directory

## Developing a new component

The first step of developing this component, is writing the core
functionality of the component, in this case a bash script.

#### Write a script in Bash

This is a simple script which prints a simple message, along with any
input provided to it through the `par_input` parameter. Optionally, you
can override the greeter with `par_greeter`.

    ## Warning in readLines(path): incomplete final line found on 'script.sh'

Contents of [`script.sh`](script.sh):

``` bash
#!/usr/bin/env bash

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

    ## ./script.sh: line 1: ﻿#!/usr/bin/env: No such file or directory
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
#!/usr/bin/env bash
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
