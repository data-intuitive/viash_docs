---
title: "Run"
nav_order: 2
parent: Commands
---

`viash run` executes a viash component. From the provided functionality.yaml, viash
generates a temporary executable and immediately executes it with the given parameters.

Usage:
```
viash run -f fun.yaml [-p plat.yaml] [-k] [-- --params --to component]
```

Arguments:

* `-f|--functionality <arg>`: Path to the functionality file. See [functionality.md](functionality.md) for more info.
* `-p|--platform <arg>`: Path to the platform file. If not provided, the component is executed on the native platform. See [platform.md](platform.md) for more info.
* `-k|--keep`: Do not remove temporary files.
* `-- param1 param2 ...`: Extra parameters to be passed to the component itself. `--` is used to separate viash arguments from the arguments of the component. 
* `VIASH_TEMP="<path>"`: An environment variable which can be defined to specify a temporary directory. By default, `/tmp` is used.

