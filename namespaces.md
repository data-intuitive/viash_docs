# Namespaces

## Background

Sometimes you just need one tool, wrapped in a container or a pimped script. That's where `viash` can help. Using the CLI interface, one can export the component spec to a runnable (Docker) script.

In many cases, though, a _toolbox_ is required. Either as a set of tools to manually call or to combine them in a workflow/pipeline. That's where namespaces come in. They are a collection of tools, a way to group related.

Better even, we would like to combine tools from different toolboxes and ideally not run into the issue of clashes in names etc.

What we want to achieve with namespaces is to be able to group tools/components and share the toolbox rather than the individual tool but without the hassle of a complete but still error-prone dependency system behind it.

## Idea

From version 0.2.0 we support namespaces in `viash` natively by means of ... `viash` components: `viash` itself implements a namespace with a set of tools to help you deal with namespaces...

## Use

### Component sources under `src/<namespace>/<component>`.

Component sources go under `src/<namespace>/<component>`. For instance, the components bundled with `viash` are under:

```
src/viash/...
```

### Builds under `target/<platform>/<namespace>`

In order to build the components under `src/<namespace>`, use the `build_namespace` component:

```
❯ bin/viash_doc_namespace --help
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

The scripts checks for platform files for platform `PL` being `native`, `docker` and `nextflow` as follows:

- If a `platform_PL.yaml` exists in the component directory, use it
- If this file does not exist, check if there is a file `platforms/PL.yaml`, use it
- Else, just skip this component for this platform

`viash_build_namespaces` by default stores the result under `target/PL/<namespace>/<component>`, but this can be overridden using the command line parameter `-t`.

### Proper namespacing

The build script generates subdirectories per namespaces. But it also generates unique entry commands on the level of `target/PL` by prepending `<namespace>_` to the component name.

In other words, say we have component `src/test_namespace/test_component`, then the Docker target will be under `target/docker/test_namespace/test_component` but the script to launch the process in the container itself will also be available as `target/test_namespace_test_component`. This also means that if both a native and a Docker platform spec are provided, the Docker target script will be put here.

__Remark__: Please note that these assumptions could be changed/updated later or eventually become a configuration parameter.

### A note about the `viash` namespace

The components that come with `viash` are handled using these scripts with only one difference: Instead of using `target/` as the build directory, we use `bin/`.

In combination with the logic in the `build_viash_namespace` component, this means that we end up with the script under `bin/` directly which makes sense for the `viash` stuff.

### Documentation

Documentation can be generated for the target builds by using the script:

```
❯ bin/viash_doc_namespace --help
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
