---
title: "viash build"
nav_order: 2
parent: Commands
---

# viash build

Build an executable from the provided [viash config file](../../config).

Usage: 
```
viash build -o output [-P docker/-p platform.yaml] [-m] [-s] config.vsh.yaml
```

Arguments:

* `config`: A viash config file (example: `config.vsh.yaml`). This argument can also be a script with the config as a header (example: `script.vsh.R`).
* `-P|--platformid <arg>`: If multiple platforms are specified in the config, use the platform with this name.
* `-p|--platform <arg>`: Path to a custom platform file.
* `-m|--meta`: Print out some meta information at the end.
* `-o|--output <arg>`: Path to directory in which the executable and any resources is exported to. Default: "output/".
* `-s|--setup`: Set up the platform environment after building the executable.

Deprecated arguments:
* `-f|--functionality <arg>`: [deprecated] Path to the functionality file.
