---
title: "viash run"
nav_order: 1
parent: Commands
---

# viash run

Run a viash component from the provided [viash config file](../../config). viash generates a temporary executable and immediately executes it with the given parameters.

Usage:
```
viash run [-P docker/-p platform.yaml] [-k] config.vsh.yaml -- [arguments for script]
```

Arguments:

* `config`: A viash config file (example: `config.vsh.yaml`). This argument can also be a script with the config as a header (example: `script.vsh.R`).
* `-P|--platformid <arg>`: If multiple platforms are specified in the config, use the platform with this name.
* `-p|--platform <arg>`: Path to a custom platform file.
* `-k|--keep`: Do not remove temporary files. The temporary directory can be overwritten by defining a `VIASH_TEMP` variable.
* `-- param1 param2 ...`: Extra parameters to be passed to the component itself. `--` is used to separate viash arguments from the arguments of the component. 
* `VIASH_TEMP="<path>"`: An environment variable which can be defined to specify a temporary directory. By default, `/tmp` is used.

Deprecated arguments:
* `-f|--functionality <arg>`: [deprecated] Path to the functionality file.
