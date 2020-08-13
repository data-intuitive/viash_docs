# Reproducibility with Viash

## Introduction

With Viash v0.2.0 rc2, some additional functionality is provided related to reproducibility.

## `viash.yaml`

Whenever `viash export` is run, a file `viash.yaml` is written in the exported directory. This file contains the following information:

1. Meta information about the viash run (version), the source `functionality.yaml` and `platform.yaml` location etc.
2. The complete `functionality.yaml` and `platform.yaml` used as input for `viash export`.
3. All the resources (serialized din YAML) and tests included in the source of the component.

In other words, based on `viash.yaml`, we could completely rebuild the component from scratch.

__Remark 1__: This makes for an interesting future feature: being able to _rebuild_ a target component without using the sources, just by means of `viash.yaml`.

__Remark 2__: The format and content of `viash.yaml` is still WIP, please expect changes.

## Versioning

`functionality.yaml` and `platform.yaml` both support (optional) versions now. These are manually provided version numbers.

A `viash` component is available to deal with versions in collection of components: `viash-version`. Tagging the `viash` components with a version using `viash-version` can be done like this:

```sh
bin/version 0.2.0-rc2 -l src/viash
```

We plan to add additional functionality in the future.

__Remark__: For now, the version numbers need to be quoted for them to be interpreted as a `String`. The `viash-version` component automatically takes care of that, but in case versions are specified manually this is still important.

## Git information

The `viash.yaml` file contains git information (remote, latest commit) about the repository you're running `viash export` from. The idea is that when you build the `viash` targets from source, usually that will be done from the repository directory (e.g. using `make` or similar).

When no git information is available (because `viash` is run outside a git repo, or when the YAML files are fetched using a URI) these attributes will show `NA`.

## Docker image tagging

When a version number is specified in `platform.yaml`, we tag the created Docker contains as `<target_image>:<version>`.

For example, the following `platform_docker.yaml` file

```yaml
type: docker
version: '1.1'
image: rocker/tidyverse
target_image: test
r:
  cran:
  - optparse
  - magrittr
volumes:
- name: data
  mount: /data
```

will generate the following Docker image:

```
test:1.1
```


