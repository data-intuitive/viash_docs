---
title: "viash test"
nav_order: 3
parent: Commands
---

# viash test

Test the component using the tests defined in the [viash
config](/config) file.

Usage:

``` bash
  viash test config.vsh.yaml [-p docker] [-k true/false]
```

Arguments:

-   `config`: A viash config file (example: `config.vsh.yaml`). This
    argument can also be a script with the config as a header.
-   `-c, --config_mod  <arg>...`: Modify a [viash config](/config) at
    runtime using a custom DSL. For more information, see the online
    documentation. (default = List())
-   `-k, --keep  <arg>`: Whether or not to keep temporary files. By
    default, files will be deleted if all goes well but remain when an
    error occurs. By specifying –keep true, the temporary files will
    always be retained, whereas –keep false will always delete them. The
    temporary directory can be overwritten by setting defining a
    VIASH\_TEMP directory.
-   `-p, --platform  <arg>`: Specifies which platform amongst those
    specified in the config to use. If this is not provided, the first
    platform will be used. If no platforms are defined in the config,
    the native platform will be used. In addition, the path to a
    platform yaml file can also be specified.
-   `-h, --help`: Show help message
