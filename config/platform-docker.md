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
a docker container from scratch using the setup flag, or pull it from a docker repository.

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
A list of requirements for installing apt, apk, R, Python, JavaScript packages or 
specifying other Docker setup instructions.
The order in which these dependencies are specified determines the order in which they will
be installed.^

### R requirements [list] {#r-reqs}
Specify which R packages should be available in order to run the component.

Example:
```yaml
setup: 
  - type: r
    cran: [ dynutils ]
    bioc: [ AnnotationDbi ]
    git: [ https://some.git.repository/org/repo ]
    github: [ rcannood/SCORPIUS ]
    gitlab: [ org/package ]
    svn: [ https://path.to.svn/group/repo ]
    url: [ https://github.com/hadley/stringr/archive/HEAD.zip ]
    script: [ 'devtools::install(".")' ]
```

### Python requirements [list] {#py-reqs}
Specify which Python packages should be available in order to run the component.

Example: 
```yaml
setup:
  - type: python
    pip: [ numpy ]
    git: [ https://some.git.repository/org/repo ]
    github: [ jkbr/httpie ]
    gitlab: [ foo/bar ]
    mercurial: [ http://... ]
    svn: [ http://...]
    bazaar: [ http://... ]
    url: [ http://... ]
```

### JavaScript requirements [list] {#js-reqs}
Specify which JavaScript packages should be available in order to run the component.

Example: 
```yaml
setup:
  - type: javascript
    npm: [ packagename ]
    git: [ https://... ]
    github: [ owner/repository ]
    url: [ https://... ]
```

### Aptitude requirements [list] {#apt-reqs}
Specify which apt packages should be available in order to run the component.

Example: 
```yaml
setup:
  - type: apt
    packages: [ sl ]
```



### Alpine requirements [list] {#apt-reqs}
Specify which apk packages should be available in order to run the component.

Example: 
```yaml
setup:
  - type: apk
    packages: [ sl ]
```


### Docker requirements [list] {#apt-reqs}
Specify which Docker commands should be run during setup.

Example: 
```yaml
setup:
  - type: docker
    build_args: [ GITHUB_PAT=hello_world ]
    run: [ git clone ... ]
    resources: 
      - resource.txt /path/to/resource.txt
```



## Decision tree

The following decision tree governs the use of `image` and `target_image` when using the Docker platform:

__Customization required?__ (i.e. `---dockerfile` return an empty string)

- __no__:

  Use available `image` (including version tags) to run

- __yes__:

  __`target_image` present?__
  - __no__:
    - Docker image can be built with `---setup`
    - The image is tagged as `viash_autogen/<component_name>`
  - __yes__:
    - Docker image can be built with `---setup`
    - If the image exists locally or in a repository, it will be pulled
    - Image is tagged with `target_image` and `platform.version` as version.


