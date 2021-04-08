---
title: "viash ns build"
nav_order: 4
parent: Commands
---

# viash ns build

Build a namespace from many [viash config](/config) files.

Usage:

``` bash
  viash ns build [-n nmspc] [-s src] [-t target] [-p docker] [--setup] [---push] [--parallel]
```

Arguments:

-   `config`: A viash config file (example: `config.vsh.yaml`). This
    argument can also be a script with the config as a header.
-   `-c, --command  <arg>...`: Apply a command to the config using the
    [viash command DSL](/dsl).
-   `-l, --parallel`: Whether or not to run the process in parallel.
-   `-p, --platform  <arg>`: Acts as a regular expression to filter the
    platform ids specified in the found config files. If this is not
    provided, all platforms will be used. If no platforms are defined in
    a config, the native platform will be used. In addition, the path to
    a platform yaml file can also be specified. –push TODO
-   `-q, --query  <arg>`: Filter which components get selected by name
    and namespace. Can be a regex. Example: “^mynamespace/component1$”.
    –query\_name <arg> Filter which components get selected by name. Can
    be a regex. Example: “^component1”.
-   `-n, --query_namespace  <arg>`: Filter which namespaces get selected
    by namespace. Can be a regex. Example: “^mynamespace$”. –setup
    Whether or not to set up the platform environment after building the
    executable.
-   `-s, --src  <arg>`: A source directory containing [viash
    config](/config) files, possibly structured in a hierarchical folder
    structure. Default: src/.
-   `-t, --target  <arg>`: A target directory to build the executables
    into. Default: target/.
-   `-w, --write_meta`: Write out some meta information to
    RESOURCES\_DIR/viash.yaml at the end.
-   `-h, --help`: Show help message
