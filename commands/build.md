---
title: "viash build"
nav_order: 2
parent: Commands
---

# viash build

Build an executable from the provided [viash config file](../../config).

Usage: 
```
viash build -o output [-p docker] [-m] [-s] config.vsh.yaml 
```

Arguments:

* `config`: A viash config file (example: `config.vsh.yaml`). This
            argument can also be a script with the config as a
            header.
* `-p|--platform <arg>`: Specifies which platform amongst those specified in
                          the config to use. If this is not provided, the first
                          platform will be used. If no platforms are defined in
                          the config, the native platform will be used. In
                          addition, the path to a platform yaml file can also be
                          specified.
* `-m|--meta`: Print out some meta information at the end.
* `-o|--output <arg>`: Path to directory in which the executable and any
                          resources is built to. Default: `"output/"`.
* `-s|--setup`: Set up the platform environment after building the executable.
