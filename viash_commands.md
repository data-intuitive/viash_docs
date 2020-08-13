viash commands
================

viash has three commands:

  - [`viash run`](#viash-run): Run a viash component (mainly for
    development purposes).
  - [`viash test`](#viash-test): Run the tests of a viash component (for
    development purposes).
  - [`viash export`](#viash-export): Export a component to an executable
    using the desired back-end.

Every subcommand requires a functionality.yaml meta file which describes
the behaviour of a component in terms of input, output and parameters.
See [functionality.md](functionality.md) for information regarding the
format of this file. Alongside the functionality.yaml is usually a Bash,
Python or R script which contains the desired logic for the component.

Each subcommand optionally allows a platform.yaml meta file to be
specified, which describes the environment the component will be
executed on. Current supported environments are natively (on the host
system), in a Docker container, or as part of a Nextflow pipeline. If no
platform file is provided, a native execution environment is assumed.
See [platform.md](platform.md) for information regarding the format of
this file.

## viash run

`viash run` executes a viash component. From the provided
functionality.yaml, viash generates a temporary executable and
immediately executes it with the given parameters.

Usage:

    viash run -f fun.yaml [-p plat.yaml] [-k] [-- --params --to component]

Arguments:

  - `-f|--functionality <arg>`: Path to the functionality file. See
    [functionality.md](functionality.md) for more info.
  - `-p|--platform <arg>`: Path to the platform file. If not provided,
    the component is executed on the native platform. See
    [platform.md](platform.md) for more info.
  - `-k|--keep`: Do not remove temporary files.
  - `-- param1 param2 ...`: Extra parameters to be passed to the
    component itself. `--` is used to separate viash arguments from the
    arguments of the component.
  - `VIASH_TEMP="<path>"`: An environment variable which can be defined
    to specify a temporary directory. By default, `/tmp` is used.

## viash test

`viash test` runs the tests as defined in the functionality.yaml. See
[functionality.md\#tests](functionality.md#tests) for more information
on how to write tests.

Usage:

    viash test -f functionality.yaml [-p platform.yaml] [-v] [-k]

Arguments:

  - `-f|--functionality <arg>`: Path to the functionality file. See
    [functionality.md](functionality.md) for more info.
  - `-p|--platform <arg>`: Path to the platform file. If not provided,
    the component is executed on the native platform. See
    [platform.md](platform.md) for more info.
  - `-k|--keep`: Do not remove temporary files.
  - `-v|--verbose`: Print out all output from the tests. Otherwise, only
    a summary is shown.
  - `VIASH_TEMP="<path>"`: An environment variable which can be defined
    to specify a temporary directory. By default, `/tmp` is used.

## viash export

`viash export` generates an executable from the functionality and
platform meta information.

Usage:

    viash export -f functionality.yaml [-p platform.yaml] -o output [-m]

Arguments:

  - `-f|--functionality <arg>`: Path to the functionality file. See
    [functionality.md](functionality.md) for more info.
  - `-p|--platform <arg>`: Path to the platform file. If not provided,
    the component is executed on the native platform. See
    [platform.md](platform.md) for more info.
  - `-m|--meta`: If specified, some meta information is printed at the
    end of the export.
  - `-o|--output <arg>`: Path to directory in which the executable and
    any resources is exported to. Default: “output/”.