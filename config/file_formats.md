---
title: "File Formats"
nav_order: 10
parent: Config
---

# Regarding viash file formats

viash uses a `config.vsh.yaml` file represent a component’s metadata.
Alternatively, the metadata can also be contained in the component
script itself.

The following two file formats are equivalent.

## Config format

Metadata `config.vsh.yaml`:

``` yaml
functionality:
  name: hello
  arguments:
    - name: "name"
      type: string
      default: Bob
  resources:
    - type: bash_script
      path: script.sh
platforms:
  - type: native
```

Script `script.sh`:

``` bash
#!/bin/bash
echo Hello $par_name
```

## Script format

Script `script.vsh.sh`:

``` bash
#!/bin/bash

#' functionality:
#'   name: hello
#'   arguments:
#'     - name: "name"
#'       type: string
#'       default: Bob
#' platforms:
#' - type: native

echo Hello $par_name
```
