---
title: "Nextflow pipeline"
nav_order: 3
parent: Platforms
---

... introduction ... 

## Filenames

It's important in a pipeline that input and output filenames are explicitly declared. We try to generalize this as much as possible keeping in mind that no clashes between filenames (in parallel runs) should collide.

In order to do that, we make the assumption that a module `moduleX` transforms the filenames in the following way:

```
file.ext      -> file.moduleX.ext'
file.int.ext  -> file.moduleX.ext'
```

At least, for modules/functions that turn one input file into one output file (not taking into account logging etc.).

## `function_type`

The `function_type` attempts to capture some high-level functionality of the _function_ at hand. There are two things to consider for this:

- What is the input/output signature of the function? In other words, is the input one or more files? Is the output one or more files?
- How should the output files be named (based on the input)

For instance, a tool that creates a full directory structure as output has a different _signature_ than one that unzips one file.

__Note__: If no function type is declared, by default the `transform`/`convert` type is used.

### `transform`

The `transform` type modifies a file such that the result is of the same type as the original.

Examples are:

- A TOC is added to a Markdown file. Bot input and output are Markdown format.
- An `h5ad` file is loaded and additional annotations are added to it.

### `convert`

The `convert` function type converts one format into an other. The type of a file is usually expressed by means of the extension. The extension of the target file is based upon the extension of the default output file value as specified in `functionality.yaml`.

Examples are:

- Generate a PDF file from a Markdown.
- Convert an `h5ad` file into a `loom` file

Please note that `transform` and `convert` are implemented in exactly the same way, so they can be interchanged.
In a future version of the NXF Target, we plan on allowing users to specify the output file name by means of other ways.

### `todir`

In this case, a tool writes multiple files and we ideally store those in a dedicated (sub) directory. This could correspond to a _fork_ in the pipeline DAG, but not necessarily so.

It should be noted that the downstream transformations or processes should take this forking into account.

### `join`

A pipeline DAG usually contains forks as well as joins. This function type combines things. Tools like, e.g. Pandoc, allow the user to combine several files into one output file.

## How to specify a join?

A component can be tagged as being a `join` module in NextFlow, i.e. by adding the following to `functionality.yaml`:

```yaml
function_type: join
```

In order for a module to be of type join, it effectively needs to:

1. Take a number of input files in the form of an argument or an option with multiple values, or
2. Take multiple options, each requiring a file as parameter. An example is providing a reference file on top of the input file to be processed, a template, ...

The reason point 2. is also of type `join` is that we want to explicitly keep track of input/output files and provide NextFlow the option to do so as well.

Next, the two possible join types above result in two different ways of handling the IO in NextFlow. Let's give an example of both.

First, suppose we use `cat` and we just want to concatenate multiple files one after the other. The way to express this in NextFlow would be something like:

```groovy
concatenate_ = singleSample_ \
    | toList \
    | map{ it -> [ it.collect{ b -> b[0]}, it.collect{ a -> a[1] }, params ]} \
    | concatenate
```

In other words, we pass a `List`of Path objects to the concatenate module.

The second approach, for instance can be used to merge meta information (from a file) to an `h5ad` file. This would be expressed like so:

```groovy
    singleSample_ = input_ \
        ...
        | combine(meta_) \
        | map{ id, output, params, meta ->
            [ id, [ "input" : output, "meta" : meta ], params ]
        } \
        | annotate
```

Where the `meta_` `Channel` points to the meta file to be used.

In other words, we either provide a `List` of Path values or in the case multiple options take different files we use a `HashMap`.

Remark: Be sure to mark the options in `functionality.yaml` as being of `type: file` and `direction: input`.

## Specific Functionality

### Labels

NXF allows the use of labels for processes as a way to refer to a set of processes by means of this label. In order to use this functionality, add the following to the NXF `platform.yaml`:

```yaml
label: myFancyLabel
```

And then in the main `nextflow.config`, use:

```
process {
  ...
  withLabel: myFancyLabel {
     maxForks = 5
     ...
  }
}
```

### Publish or not

One does not always want to keep all intermediate results. Usually you want to keep the end results and for instance reports that are generated.

The default is to publish everything, but if you specifically do _not_ want the output of a step to be published, use:

```yaml
publish: false
```

Please note that NXF always keeps a cache of all input/output files for allowing `-resume` runs.

### PublishDir

In some cases it may make sense to have the output data _published_ (not cached) in a directory _per sample_. This can be achieved using the following attribute:

```yaml
publishSubDir: true
```

## Docker Images

In order to run a step, the appropriate execution context is required. We provide this environment by means of a Docker container.

We will use the `filter_table` atom included with the `viash` codebase. The Docker container should be specified in the NextFlow Platform YAML file, like so:

```yaml
type: nextflow
image: viash_autogen/filter_table
```

This image, as the name says, is auto-generated using `viash`. It's autogenerated from the Docker platform YAML description:

```yaml
type: docker
image: rocker/tidyverse
r:
  cran:
  - optparse
...
```

Running the pipeline, now consists of the following steps:

```sh
viash export -f atoms/filter/functionality.yaml -p atoms/filter/platform_nextflow.yaml -o output/filter
viash export -f atoms/filter/functionality.yaml -p atoms/filter/platform_docker.yaml -o output/filter/setup
output/filter/setup/filter_table ---setup
```

In the scope of a pipeline, when multiple _atoms_ are converted, it may make sense to alter the two last statements as such:

```sh
viash export -f atoms/filter/functionality.yaml -p atoms/filter/platform_docker.yaml -o setup/
setup/filter_table ---setup
```

The last instruction above builds the Docker image and tags it as `viash_autogen/filer_table`, which can now be picked up by our pipeline.

Alternatively, with a recent version of `viash`, it is also possible to _name_ the docker image that should be used after setup. The example above becomes:

```yaml
type: nextflow
image: viash/filter_table
```

The image used is defined in this way:

```yaml
type: docker
image: rocker/tidyverse
target_image: viash/filter_table
r:
  cran:
  - optparse
...
```

The `viash/` prefix can be omitted, or in some cases aligned to the private repository running at your site.

Remarks:

- This procedure works locally on an instance, if will not work when running this in a clustered environment
- We are working on functionality to automate and improve this procedure

## TODO

### Packages

The NXF target inherits the R and Python platforms. This should _in principle_ allow a user to specify additional packages to be installed prior to running the function/module. This functionality is not yet available, though.
