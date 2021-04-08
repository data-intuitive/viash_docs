---
title: "viash config view"
nav_order: 10
parent: Commands
---

# viash config view

View the config file after parsing.

Usage:

``` bash
  viash config view config.vsh.yaml
```

Arguments:

  - `config`: A viash config file (example: `config.vsh.yaml`). This
    argument can also be a script with the config as a header.
  - `-c, --config_mod <arg>...`: Modify a [viash config](/config) at
    runtime using a custom DSL. For more information, see the online
    documentation.
  - `-p, --platform <arg>`: Specifies which platform amongst those
    specified in the config to use. If this is not provided, the first
    platform will be used. If no platforms are defined in the config,
    the native platform will be used. In addition, the path to a
    platform yaml file can also be specified.
  - `-h, --help`: Show help message
