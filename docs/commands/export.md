---
title: "Export"
nav_order: 3
parent: Commands
---

`viash export` generates an executable from the functionality and platform meta information.

Usage: 
```
viash export -f functionality.yaml [-p platform.yaml] -o output [-m]
```

Arguments:

* `-f|--functionality <arg>`: Path to the functionality file. See [functionality.md](functionality.md) for more info.
* `-p|--platform <arg>`: Path to the platform file. If not provided, the component is executed on the native platform. See [platform.md](platform.md) for more info.
* `-m|--meta`: If specified, some meta information is printed at the end of the export.
* `-o|--output <arg>`: Path to directory in which the executable and any resources is exported to. Default: "output/".

