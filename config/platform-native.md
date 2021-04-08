---
title: "Native platform"
nav_order: 2
parent: Config
---

# Native platform

{: .no\_toc }

## Table of contents

{: .no\_toc .text-delta }

1.  TOC {:toc}

-----

Running a viash component on a native platform means that the script
will be executed in your current environment.

Any dependencies are assumed to have been installed by the user, so the
native platform is meant for developers (who know what they’re doing) or
for simple bash scripts (which have no extra dependencies).

## Example

An example of a native platform yaml can be found below, each part of
which is explained in more depth in the following sections.

``` yaml
platforms:
  - type: native
    id: native_platform
    version: "1.0.0"
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

The version of the platform specifications. Has no significant impact
when using the native platform.

Example:

``` yaml
version: "0.1.0"
```
