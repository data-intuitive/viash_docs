---
title: "viash ns build"
nav_order: 4
parent: Commands
---

# viash ns build

Build a namespace from many [viash config files](../../config).

Usage: 
```
viash ns build [-s src] [-t target] [-P docker/-p platform.yaml] [--setup] [--parallel]
```

Arguments:

* `-s|--src <arg>`: A source directory containing viash config files, possibly structured in a hierarchical folder structure. Default: `src/`.
* `-t|--target <arg>`: A target directory to build the executables into. Default: `target/`.
* `-P|--platformid <arg>`: Only build a particular platform type.
* `-p|--platform <arg>`: Path to a custom platform file.
* `--setup`: Whether or not to set up the platform environment after building the executable.
* `-l|--parallel`: Whether or not to run the process in parallel.
