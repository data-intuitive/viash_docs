---
title: "File Formats"
nav_order: 10
parent: Config
---

viash supports multiple file formats, the most important of which are 'joined' and 'integrated'.

## Split
This is a legacy file format which is (still) supported for backwards compatibility. The file structure is as follows:

* `functionality.yaml`: Metadata concerning the functionality provided by a software component.
* `script.R/py/sh`: A script.
* `platform_native.yaml` (optional): Metadata describing the requirements for using the software component as is.
* `platform_docker.yaml` (optional): Metadata describing the requirements for using the software component in a Docker container.
* `platform_nextflow.yaml` (optional): Metadata describing the requirements for using the software component as part of a Nextflow pipeline.

Examples for each of these files are show below.

`functionality.yaml`:

```yaml
name: hello
arguments:
  - name: "name"
    type: string
    default: Bob
resources:
  - type: bash_script
    path: script.sh
```

`script.sh`:

```bash
#!/bin/bash
echo Hello $par_name
```


## Joined

## Integrated

```r
#' functionality:
#'   name: r-estimate
#'   arguments: ...
#' platforms:
#' - type: native
#' - type: docker
#'   image: rocker/tidyverse

library(tidyverse)
cat("Hello world!\n")
```

