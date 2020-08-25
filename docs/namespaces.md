---
title: "Namespaces"
---

## Background

Sometimes you just need one tool wrapped in a container or a pimped script. That's where `viash` can help. Using the CLI interface, one can export the component spec to a runnable (Docker) script.

In many cases though a _toolbox_ is required. Either as a set of tools to manually call or to combine them in a workflow/pipeline. That's where namespaces come in. They are a _collection_ of tools.

Better even, we would like to combine tools from different toolboxes and ideally not run into the issue of clashes in names etc.

What we want to achieve with _namespaces_ is to be able to group tools/components and share the toolbox rather than the individual tool but without the hassle of a complex and error-prone dependency system behind it.

## Idea

From version `viash` 0.2.0-rc3 onwards, namespaces are managed using the `viash ns` subcommand:

```sh
$ viash ns -h
  -h, --help   Show help message

Subcommand: build
  -n, --namespace  <arg>   The name of the namespace.
  -s, --src  <arg>         An alternative source directory if not under
                           src/<namespace>. Default = source/<namespace>.
  -t, --target  <arg>      An alternative destination directory if not target/.
                           Default = target/.
  -h, --help               Show help message
```

## Use

### Component sources under `src/<namespace>/<component>`.

Component sources go under `src/<namespace>/<component>`. For instance, the components bundled with `viash` are under `src/viash/...` because they are part of the `viash` namespace. Processing the complete namespace is as simple as:

```sh
$ viash ns build -n viash
```

By default sources are taken from `src/` (or from `-s ...`) and the target it `target/` (unless specified with `-t ...`).

Components can be nested as well and this is represented in the namespace reference. For instance, a set of components in a namespace defined as follows:

```
src/
  subdir/
    ns1/
      tool1
      tool2
```

This namespace should be referred to as:

```sh
$ viash ns build -n subdir/ns1
```

### Builds go under `target/<platform>/<namespace>`

`viash` checks the spec (either as a standalone YAML file or as included in the header of a script) to decide which _platforms_ are supported.

For very platform that occurs in the platform part of the specification, a directory `target/<platform>` is created. Under this, the namespaces target builds are stored.

Furthermore, the structure under `target/` follows the one under `src/`, i.e., in the case of a nested namespaces, the build will go as follows:

```
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
```

### Proper namespacing

The build script generates subdirectories per namespaces. But it also generates unique entry commands on the level of `target/PL` by prepending `<namespace>-` to the component name.

_Please note_: We use a `-` sign between namespace and tool names. We strongly suggest to use the `_` character to distinguish words in either namespace or tool names. In other words, say we have component `src/test_namespace/test_component`, then the Docker target will be under `target/docker/test_namespace/test_component` but the script to launch the process in the container itself will also be available as `target/test_namespace-test_component`. This also means that if both a native and a Docker platform spec are provided, the Docker target script will be put here.

__Remark__: Please note that these conventions could be changed/updated later or eventually become a configuration parameter.

### A note about the `viash` namespace

The components that come with `viash` are handled using these scripts with only one difference: Instead of using `target/` as the build directory, we use `bin/`, so we effectively run:

```
viash ns build -n viash -t bin
```

In combination with the logic described above, this means that we end up with the script under `bin/` directly which makes sense for the `viash` stuff.

- - -

### Documentation

Documentation can be generated for the target builds by using the script:

```
❯ bin/viash-doc_namespace --help
Generate namespace documentation based on the effective contents of
the target/ build directory (or different if configured like this).

Options:
    -n string, --namespace=string
        type: string, required parameter, default: viash
        The name of the namespace

    -t string, --target=string
        type: string, default: target
        An alternative location if not target/
```

### Combining namespaces

Please note that it now becomes easy to combine namespaces/toolboxes without having name clashes. It even becomes possible to split large component databases in groups. We have an example of a Single Cell component library that is grouped along the _function_: cluster, normalize, filter, ... Each of these types of functionality contain multiple _methods_, possibly using complete different programming languages, libraries, versions, etc.

The layout simply looks like:

```
src/
  filter/
  cluster/
  ...
```

In effect, we could as well split them into different repositories. The builds (under `target/`) can be combined per platform as well because they are all properly namespaced. And in the root, one can still access the native or Docker version of the script by prepending the namespace.

## TODO

- Split the namespace code in code relevant for 1 component and call that component instead of doing everything in the main script
- Add functionality to process a number of namespaces as well.
