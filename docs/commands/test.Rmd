---
title: "Test"
nav_order: 4
parent: Commands
---

`viash test` tests the component using the tests defined in the [viash config file](../../config).

Usage:
```
viash test -f functionality.yaml [-p platform.yaml] [-v] [-k]
```

Arguments:

* `config`: A viash config file (example: `config.vsh.yaml`). This argument can also be a script with the config as a header (example: `script.vsh.R`).
* `-P|--platformid <arg>`: If multiple platforms are specified in the config, use the platform with this name.
* `-p|--platform <arg>`: Path to a custom platform file.
* `-k|--keep`: Do not remove temporary files.
* `-v|--verbose`: Print out all output from the tests. Otherwise, only a summary is shown.
* `VIASH_TEMP="<path>"`: An environment variable which can be defined to specify a temporary directory. By default, `/tmp` is used.
  
Deprecated arguments:
* `-f|--functionality <arg>`: [deprecated] Path to the functionality file.
