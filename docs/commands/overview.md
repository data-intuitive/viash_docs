---
title: "Overview"
nav_order: 1
parent: Commands
---

viash has three main commands:

* [`viash run script.sh`](#viash-run): Run a viash component (mainly for development purposes).
* [`viash export script.sh`](#viash-export): Export a component to an executable using the desired back-end.
* [`viash test script.sh`](#viash-test): Run the tests of a viash component (for development purposes).

The script (R/Python/Bash) requires a YAML header which describes the functionality 
of the component (input/output/arguments) and the platform which will execute the 
component (native/docker/nextflow). 

Every subcommand requires a functionality.yaml meta file which describes the
behaviour of a component in terms of input, output and parameters. See 
[functionality.md](functionality.md) for information regarding the format of 
this file. Alongside the functionality.yaml is usually a Bash, Python or R 
script which contains the desired logic for the component. 

Each subcommand optionally allows a platform.yaml meta file to be specified,
which describes the environment the component will be executed on. Current 
supported environments are natively (on the host system), in a Docker container,
or as part of a Nextflow pipeline. If no platform file is provided, a native 
execution environment is assumed. See [platform.md](platform.md) for information
regarding the format of this file.

