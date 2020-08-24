---
title: "Test"
nav_order: 4
parent: Commands
---

`viash test` runs the tests as defined in the functionality.yaml. See 
[functionality.md#tests](functionality.md#tests) for more information on how to
write tests.

Usage:
```
viash test -f functionality.yaml [-p platform.yaml] [-v] [-k]
```

Arguments:

* `-f|--functionality <arg>`: Path to the functionality file. See [functionality.md](functionality.md) for more info.
* `-p|--platform <arg>`: Path to the platform file. If not provided, the component is executed on the native platform. See [platform.md](platform.md) for more info.
* `-k|--keep`: Do not remove temporary files.
* `-v|--verbose`: Print out all output from the tests. Otherwise, only a summary is shown.
* `VIASH_TEMP="<path>"`: An environment variable which can be defined to specify a temporary directory. By default, `/tmp` is used.
  
