---
title: "viash ns list"
nav_order: 6
parent: Commands
---

# viash ns list

List a namespace containing many [viash config](/config) files.

Usage:

``` bash
  viash ns list [-n nmspc] [-s src] [-p docker] [--tsv file.tsv]
```

Arguments:

-   `-c, --config_mod  <arg>...`: Modify a [viash config](/config) at
    runtime using a custom DSL. For more information, see the online
    documentation.
-   `-k, --keep  <arg>`: Whether or not to keep temporary files. By
    default, files will be deleted if all goes well but remain when an
    error occurs. By specifying –keep true, the temporary files will
    always be retained, whereas –keep false will always delete them. The
    temporary directory can be overwritten by setting defining a
    VIASH\_TEMP directory.
-   `-l, --parallel`: Whether or not to run the process in parallel.
-   `-p, --platform  <arg>`: Acts as a regular expression to filter the
    platform ids specified in the found config files. If this is not
    provided, all platforms will be used. If no platforms are defined in
    a config, the native platform will be used. In addition, the path to
    a platform yaml file can also be specified.
-   `-q, --query  <arg>`: Filter which components get selected by name
    and namespace. Can be a regex. Example: “^mynamespace/component1$”.
    –query\_name <arg> Filter which components get selected by name. Can
    be a regex. Example: “^component1”.
-   `-n, --query_namespace  <arg>`: Filter which namespaces get selected
    by namespace. Can be a regex. Example: “^mynamespace$”.
-   `-s, --src  <arg>`: A source directory containing [viash
    config](/config) files, possibly structured in a hierarchical folder
    structure. Default: src/.
-   `-t, --tsv  <arg>`: Path to write a summary of the list results to.
-   `-h, --help`: Show help message
