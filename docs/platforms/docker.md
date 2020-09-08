---
title: "Docker"
nav_order: 2
parent: Platforms
---

# Docker Platform

## From `image` to `target_image`

A platform specification of `type: docker` has to contain _at least_ an `image` attribute containing the docker image to use as a base. It can also contain a `target_image`. The way these two attributes are used depends on the run mode (and possibly the platform).

### `image`

Before a Docker container can run, the image has to be made available. Either because it's already available in the local Docker cache or it can be fetched from some external repository (Docker Hub, Artifactory, ...).

If the image to use is provided and no changes/updates need to be made to it, it's sufficient to specify it as follows:

```yaml
platform:
  type: docker
  version: 0.1
  image: <docker image>[:<tag>]
  ...
```

This is the simplest form. The `tag` is optional and will be automatically replaced by `latest`. The `<image>:<tag>` needs to exist locally or in some repository it can be fetched from.

TODO

## Decision tree

The following decision tree governs the use of `image` and `target_image` when using the Docker platform:

__Customization required?__ (i.e. `---dockerfile` return an empty string)

- __no__:

  Use available `image` (including version tags) to run[^1]

- __yes__:

  __`target_image` present?__
  - __no__:
    - Docker image can be to be built with `---setup`
    - The image is tagged as `viash_autogen/<component_name>`
  - __yes__:
    - Docker image can be built with `---setup`
    - If the image exists locally or in a repository, it will be pulled, and
    - Image is tagged with `target_image` and `platform.version` as version.

[^1]: Future versions of `viash` will also tag the image with `target_image` if the latter is filled, which improved consistency.


