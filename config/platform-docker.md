---
title: "Docker platform"
nav_order: 3
parent: Config
---

# Docker Platform

{: .no\_toc }

## Table of contents

{: .no\_toc .text-delta }

1.  TOC {:toc}

-----

Run a viash component on a Docker backend platform.

By specifying which dependencies your component needs, users will be
able to build a docker container from scratch using the setup flag, or
pull it from a docker repository.

## Example

An example of a docker platform yaml can be found below, each part of
which is explained in more depth in the following sections.

``` yaml
- type: docker
  id: custom_platform_name
  image: bash:4.0
  version: "0.1.0"
  target_image: myorganisation/example_docker
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

## id \[string\]

As with all platforms, you can give a platform a different name. By
specifying `id: foo`, you can target this platform (only) by specifying
`-p foo` in any of the viash commands.

Example:

``` yaml
id: foo
```

## version \[string\]

The version of the platform specifications. This will automatically be
used as a tag for the target docker image name.

Example:

``` yaml
version: "0.1.0"
```

## image \[string\]

The base container to start from.

Example:

``` yaml
image: "bash:4.0"
```

## target\_image \[string\]

If anything is specified in the `setup` section, running the `---setup`
will result in a container with the name of `<target_image>:<version>`.
If nothing is specified in the `setup` section, simply `image` will be
used.

Example:

``` yaml
target_image: myfoo
```

## chown \[boolean\]

In Linux, files created by a Docker container will be owned by `root`.
With `chown: true`, viash will automatically change the ownership of
output files (arguments with `type: file` and `direction: output`) to
the user running the viash command after execution of the component.
Default value: `true`.

Example:

``` yaml
chown: false
```

## port \[list of strings\]

A list of enabled ports. This doesn’t change the Dockerfile but gets
added as a command-line argument at runtime.

Example:

``` yaml
port:
  - 80
  - 8080
```

## workdir \[string\]

The working directory when starting the container. This doesn’t change
the Dockerfile but gets added as a command-line argument at runtime.

Example:

``` yaml
workdir: /home/user
```

## setup \[list\]

A list of requirements for installing apt, apk, R, Python, JavaScript
packages or specifying other Docker setup instructions. The order in
which these dependencies are specified determines the order in which
they will be installed.

### R requirements \[list\]

Specify which R packages should be available in order to run the
component.

Example:

``` yaml
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

### Python requirements \[list\]

Specify which Python packages should be available in order to run the
component.

Example:

``` yaml
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

### JavaScript requirements \[list\]

Specify which JavaScript packages should be available in order to run
the component.

Example:

``` yaml
setup:
  - type: javascript
    npm: [ packagename ]
    git: [ https://... ]
    github: [ owner/repository ]
    url: [ https://... ]
```

### Aptitude requirements \[list\]

Specify which apt packages should be available in order to run the
component.

Example:

``` yaml
setup:
  - type: apt
    packages: [ sl ]
```

### Alpine requirements \[list\]

Specify which apk packages should be available in order to run the
component.

Example:

``` yaml
setup:
  - type: apk
    packages: [ sl ]
```

### Docker requirements \[list\]

Specify which Docker commands should be run during setup.

Example:

``` yaml
setup:
  - type: docker
    build_args: [ GITHUB_PAT=hello_world ]
    run: [ git clone ... ]
    resources: 
      - resource.txt /path/to/resource.txt
```

## Decision tree

The following decision tree governs the use of `image` and
`target_image` when using the Docker platform:

**Customization required?** (i.e. `---dockerfile` return an empty
string)

  - **no**:
    
    Use available `image` (including version tags) to run

  - **yes**:
    
    **`target_image` present?**
    
      - **no**:
          - Docker image can be built with `---setup`
          - The image is tagged as `viash_autogen/<component_name>`
      - **yes**:
          - Docker image can be built with `---setup`
          - If the image exists locally or in a repository, it will be
            pulled
          - Image is tagged with `target_image` and `platform.version`
            as version.
