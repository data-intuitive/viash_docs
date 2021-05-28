This example demonstrates how to wrap a simple ‘hello world’ bash script
with viash.

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

    Hello world! I am viash!

#### Run the component with a Docker backend

It can also be run with a Docker backend by specifying the `-p` or
`--platform` parameter.

First, you need to let viash set up the Docker container by pulling it
from Docker Hub.

``` bash
viash run config.vsh.yaml -p docker -- ---setup
```

    > docker pull bash:4.0
    4.0: Pulling from library/bash
    Digest: sha256:2fb822817a6e1e42030bf163ca61c997441ec20ebb6adef52643d8c33f01bc6a
    Status: Image is up to date for bash:4.0
    docker.io/library/bash:4.0

You can run the component with viash in the backend as follows.

``` bash
viash run config.vsh.yaml -p docker -- General Kenobi. --greeter="Hello there."
```

    Hello there. General Kenobi.

#### Export as an executable

Now that we know what the component does, we can export the
functionality as an executable.

``` bash
viash build config.vsh.yaml -p docker -o output
output/hello_world And now, as an executable.
```

    Hello world! And now, as an executable.

#### viash automatically generates a CLI

By running the command with a `--help` flag, more information about the
component is provided.

``` bash
output/hello_world --help
```

    A very simple 'Hello world' component.

    Options:
        string1 string2 ...
            type: string, multiple values allowed

        --greeter=string
            type: string, default: Hello world!

#### viash allows testing the component

To verify that the component works, use `viash test`. This can be run
both with or without the Docker backend.

``` bash
viash test config.vsh.yaml -p docker
```

    Running tests in temporary directory: '/tmp/viash_test_hello_world155930160846356233'
    ====================================================================
    +/tmp/viash_test_hello_world155930160846356233/build_executable/hello_world ---setup
    > docker pull bash:4.0
    4.0: Pulling from library/bash
    Digest: sha256:2fb822817a6e1e42030bf163ca61c997441ec20ebb6adef52643d8c33f01bc6a
    Status: Image is up to date for bash:4.0
    docker.io/library/bash:4.0
    ====================================================================
    +/tmp/viash_test_hello_world155930160846356233/test_test.sh/test.sh
    >>> Checking whether output is correct
    + echo '>>> Checking whether output is correct'
    + ./hello_world I am 'viash!'
    + [[ ! -f output.txt ]]
    + grep -q 'Hello world! I am viash!' output.txt
    + echo '>>> Checking whether output is correct when no parameters are given'
    >>> Checking whether output is correct when no parameters are given
    + ./hello_world
    + [[ ! -f output2.txt ]]
    + grep -q 'Hello world!' output2.txt
    + echo '>>> Checking whether output is correct when more parameters are given'
    + ./hello_world General Kenobi. '--greeter=Hello there.'
    >>> Checking whether output is correct when more parameters are given
    + [[ ! -f output3.txt ]]
    + grep -q 'Hello there. General Kenobi.' output3.txt
    + echo '>>> Test finished successfully!'
    >>> Test finished successfully!
    + exit 0
    ====================================================================
    [32mSUCCESS! All 1 out of 1 test scripts succeeded![0m
    Cleaning up temporary directory
