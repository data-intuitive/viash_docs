---
title: "viash run"
nav_order: 1
parent: Commands
---

# viash run

Executes a viash component from the provided [viash config](/config)
file. viash generates a temporary executable and immediately executes it
with the given parameters.

Usage:

``` bash
  viash run config.vsh.yaml [-p docker] [-k true/false]  -- [arguments for script]
```

Arguments:

  - `config`: A viash config file (example: `config.vsh.yaml`). This
    argument can also be a script with the config as a header.
  - `-c, --command <arg>...`: Apply a command to the config using the
    [viash command DSL](/dsl). (default = List())
  - `-k, --keep <arg>`: Whether or not to keep temporary files. By
    default, files will be deleted if all goes well but remain when an
    error occurs. By specifying –keep true, the temporary files will
    always be retained, whereas –keep false will always delete them. The
    temporary directory can be overwritten by setting defining a
    VIASH\_TEMP directory.
  - `-p, --platform <arg>`: Specifies which platform amongst those
    specified in the config to use. If this is not provided, the first
    platform will be used. If no platforms are defined in the config,
    the native platform will be used. In addition, the path to a
    platform yaml file can also be specified.
  - `-h, --help`: Show help message
