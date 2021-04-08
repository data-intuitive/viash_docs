---
title: "viash build"
nav_order: 2
parent: Commands
---

# viash build

Build an executable from the provided [viash config](/config) file.

Usage:

``` bash
  viash build config.vsh.yaml -o output [-p docker] [-m] [-s]
```

Arguments:

  - `config`: A viash config file (example: `config.vsh.yaml`). This
    argument can also be a script with the config as a header.
  - `-c, --config_mod <arg>...`: Modify a [viash config](/config) at
    runtime using a custom DSL. For more information, see the online
    documentation. (default = List())
  - `-m, --meta`: Print out some meta information at the end.
  - `-o, --output <arg>`: Path to directory in which the executable and
    any resources is built to. Default: “output/”. (default = output/)
  - `-p, --platform <arg>`: Specifies which platform amongst those
    specified in the config to use. If this is not provided, the first
    platform will be used. If no platforms are defined in the config,
    the native platform will be used. In addition, the path to a
    platform yaml file can also be specified. –push Whether or not to
    push the container to a Docker registry \[Docker Platform only\].
  - `-s, --setup`: Whether or not to set up the platform environment
    after building the executable.
  - `-w, --write_meta`: Write out some meta information to
    RESOURCES\_DIR/viash.yaml at the end.
  - `-h, --help`: Show help message
