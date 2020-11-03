---
title: "Docker platform"
nav_order: 3
parent: Config
---

# Docker Platform
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

Run a viash component on a Docker backend platform. 

By specifying which dependencies your component needs, users will be able to build 
a docker container from scratch using the setup flag, or pull it from a docker repository (WIP).

## Example
An example of a docker platform yaml can be found below, each part of which is explained in more depth in the following sections. 

```yaml
- type: docker
  id: custom_platform_name
  image: bash:4.0
  version: "0.1.0"
  target_image: myorganisation/example_docker
  resolve_volume: Automatic
  chown: true
  port: [80, 8080]
  workdir: /app
  setup:
    - type: docker
      build_args: 
        - GITHUB_PAT="$GITHUB_PAT"
    - type: apt
      packages:
        - imagemagick
    - type: r
      cran:
        - tidyverse
        - dynutils
    - type: docker
      run: 
        - "git clone https://github.com/data-intuitive/randpy.git"
        

  setup:
    - type: r
      cran: [ dynutils ]
      bioc: [ AnnotationDbi ]
      git: [ https://some.git.repository/org/repo ]
      github: [ rcannood/SCORPIUS ]
      gitlab: [ org/package ]
      svn: [ https://path.to.svn/group/repo ]
      url: [ https://github.com/hadley/stringr/archive/HEAD.zip ]
    - type: python
      pip: [ numpy ]
      git: [ https://some.git.repository/org/repo ]
      github: [ jkbr/httpie ]
      gitlab: [ foo/bar ]
      mercurial: [ http://... ]
      svn: [ http://...]
      bazaar: [ http://... ]
      url: [ http://... ]
    - type: javascript
      npm: [ packagename ]
      git: [ https://... ]
      github: [ owner/repository ]
      url: [ https://... ]
```


## id [string] {#id}
As with all platforms, you can give a platform a different name. By specifying `id: foo`, you can target this platform (only) by specifying `-p foo` in any of the viash commands.

Example:
```yaml
id: foo
```

## version [string] {#version}
The version of the platform specifications. This will automatically be used as a tag for the target docker image name.

Example:
```yaml
version: "0.1.0"
```

## image [string] {#image}
The base container to start from.

```yaml
image: "bash:4.0"
```

## target_image [string] {#target_image}

## setup [list] {#setup}
A list of requirements. The native platform only supports specifying `r` and `python` requirements.

## R requirements [list] {#r-reqs}
Specify which R packages should be available in order to run the component.

Example:
```yaml
type: r
cran: [ dynutils ]
bioc: [ AnnotationDbi ]
git: [ https://some.git.repository/org/repo ]
github: [ rcannood/SCORPIUS ]
gitlab: [ org/package ]
svn: [ https://path.to.svn/group/repo ]
url: [ https://github.com/hadley/stringr/archive/HEAD.zip ]
```

## Python requirements [list] {#py-reqs}
Specify which Python packages should be available in order to run the component.

Example: 
```yaml
type: python
pip: [ numpy ]
git: [ https://some.git.repository/org/repo ]
github: [ jkbr/httpie ]
gitlab: [ foo/bar ]
mercurial: [ http://... ]
svn: [ http://...]
bazaar: [ http://... ]
url: [ http://... ]
```

## JavaScript requirements [list] {#js-reqs}
Specify which JavaScript packages should be available in order to run the component.

Example: 
```yaml
type: javascript
npm: [ packagename ]
git: [ https://... ]
github: [ owner/repository ]
url: [ https://... ]
```





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






