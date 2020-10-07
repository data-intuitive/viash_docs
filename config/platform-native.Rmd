---
title: "Native platform"
nav_order: 2
parent: Config
---


# Native platform
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

Running a viash component on a native platform means that the script will be executed in your current environment. 

Any dependencies are assumed to have been installed by the user, so the native platform is meant for developers (who know what they're doing) or for simple bash scripts (which have no extra dependencies). Still, for R and Python dependencies the commands to install dependencies can be displayed by running the setup using any of the [viash commands](../../commands).

## Example
An example of a native platform yaml can be found below, each part of which is explained in more depth in the following sections. 

```yaml
platforms:
  - type: native
    id: native_platform
    version: "1.0.0"
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
As with all platforms, you can give a platform a different name. By specifying `id: foo`, you can target this platform (only) by specifying `-P foo` in any of the viash commands.

Example:
```yaml
id: foo
```

## version [string] {#version}
The version of the platform specifications. Has no significant impact when using the native platform.

Example:
```yaml
version: "0.1.0"
```

## setup [list] {#setup}
A list of requirements. The native platform only supports specifying `r` and `python` requirements.

### r requirements [list] {#r-reqs}
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

### Python requirements [list] {#py-reqs}
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

### JavaScript requirements [list] {#js-reqs}
Specify which JavaScript packages should be available in order to run the component.

Example: 
```yaml
type: javascript
npm: [ packagename ]
git: [ https://... ]
github: [ owner/repository ]
url: [ https://... ]
```
