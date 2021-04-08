---
title: "Namespaces"
parent: "Good practices"
---

# Namespaces

Sometimes you just need one tool wrapped in a container. That’s where
`viash` can help. Using the CLI interface, one can export the component
spec to a runnable (Docker) script.

In many cases though a *toolbox* is required. Either as a set of tools
to manually call or to combine them in a workflow/pipeline. That’s where
namespaces come in. They are a *collection* of tools.

Better even, we would like to combine tools from different toolboxes and
ideally not run into the issue of clashes in names etc.

What we want to achieve with *namespaces* is to be able to group
tools/components and share the toolbox rather than the individual tool
but without the hassle of a complex and error-prone dependency system
behind it.

## Use

### Component sources under `src/<namespace>/<component>`.

Component sources go under `src/<namespace>/<component>`. For instance,
the components bundled with `viash` are under `src/viash/...` because
they are part of the `viash` namespace. Processing the complete
namespace is as simple as:

``` sh
$ viash ns build
```

By default sources are taken from `src/` (or from `-s ...`) and the
target it `target/` (unless specified with `-t ...`).

Components can be nested as well and this is represented in the
namespace reference. For instance, a set of components in a namespace
defined as follows:

    src/
      ns1/
        group1/
          tool1
          tool2

### Builds go under `target/<platform>/<namespace>`

`viash` checks the spec (either as a standalone YAML file or as included
in the header of a script) to decide which *platforms* are supported.

For very platform that occurs in the platform part of the specification,
a directory `target/<platform>` is created. Under this, the namespaces
target builds are stored.

Furthermore, the structure under `target/` follows the one under `src/`,
i.e., in the case of a nested namespaces, the build will go as follows:

    target/
      docker/
        subdir/
          ns1/
            tool1
            tool2
      nextflow/
        subdir/
          ns1/
            tool1
            tool2

### Proper namespacing

The `ns build` command generates subdirectories per namespaces. But it
also generates unique entry commands on the level of `target/PL` by
prepending `<namespace>-` to the component name.

*Please note*: We use a `-` sign between namespace and tool names. We
strongly suggest to use the `_` character to distinguish words in either
namespace or tool names. In other words, say we have component
`src/test_namespace/test_component`, then the Docker target will be
under `target/docker/test_namespace/test_component` but the script to
launch the process in the container itself will also be available as
`target/test_namespace-test_component`. This also means that if both a
native and a Docker platform spec are provided, the Docker target script
will be put here.

**Remark**: Please note that these conventions could be changed/updated
later or eventually become a configuration parameter.

### A note about the `viash` namespace

The components that come with `viash` are handled using namespaces with
only one difference: Instead of using `target/` as the build directory,
we use `bin/`, so we effectively run:

    viash ns build -n viash -t bin

In combination with the logic described above, this means that we end up
with the script under `bin/` directly which makes sense for the `viash`
stuff.

### Combining namespaces

Please note that it now becomes easy to combine namespaces/toolboxes
without having name clashes. It even becomes possible to split large
component databases in groups. We have an example of a Single Cell
component library that is grouped along the *function*: cluster,
normalize, filter, … Each of these types of functionality contain
multiple *methods*, possibly using complete different programming
languages, libraries, versions, etc.

The layout simply looks like:

    src/
      filter/
      cluster/
      ...

In effect, we could as well split them into different repositories. The
builds (under `target/`) can be combined per platform as well because
they are all properly namespaced. And in the root, one can still access
the native or Docker version of the script by prepending the namespace.
