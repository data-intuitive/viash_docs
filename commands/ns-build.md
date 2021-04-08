---
title: "viash ns build"
nav_order: 4
parent: Commands
---

# viash ns build

Build a [namespace](/good_practices/namespaces) from many [viash config
files](/config).

Usage:

    viash ns build [-n nmspc] [-s src] [-t target] [-p docker] [--setup] [--parallel]

Arguments:

  - `-n|--namespace <arg>`: Filter which namespaces get selected. Can be
    a regex. Example: `"build|run"`.
  - `-s|--src <arg>`: A source directory containing viash config files,
    possibly structured in a hierarchical folder structure. Default:
    `src/`.
  - `-t|--target <arg>`: A target directory to build the executables
    into. Default: `target/`.
  - `-p|--platform <arg>`: Acts as a regular expression to filter the
    platform ids specified in the found config files. If this is not
    provided, all platforms will be used. If no platforms are defined in
    a config, the native platform will be used. In addition, the path to
    a platform yaml file can also be specified.
  - `--setup`: Whether or not to set up the platform environment after
    building the executable.
  - `-l|--parallel`: Whether or not to run the process in parallel.
