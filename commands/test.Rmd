---
title: "viash test"
nav_order: 3
parent: Commands
---

# viash test

Test the component using the tests defined in the [viash config file](../../config).

Usage:
```
viash test [-p docker [-k true/false] config.vsh.yaml
```

Arguments:

* `config`: A viash config file (example: `config.vsh.yaml`). This argument can also be a script with the config as a header (example: `script.vsh.R`).
* `-p|--platform <arg>`: Specifies which platform amongst those specified in
                          the config to use. If this is not provided, the first
                          platform will be used. If no platforms are defined in
                          the config, the native platform will be used. In
                          addition, the path to a platform yaml file can also be
                          specified.
* `-k|--keep true/false`: Whether or not to keep temporary files. By default,
                          files will be deleted if all goes well but remain when
                          an error occurs. By specifying `--keep true`, the
                          temporary files will always be retained, whereas
                          `--keep false` will always delete them. The temporary
                          directory can be overwritten by setting defining a
                          `VIASH_TEMP` directory.
* `VIASH_TEMP="<path>"`: An environment variable which can be defined to specify a temporary directory. By default, `/tmp` is used.
