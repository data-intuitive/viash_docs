---
title: "Nextflow platform"
nav_order: 4
parent: Config
---

## Introduction

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

Publishing in NextFlow means that results of a computation are stored in a specific location. One does not always want to keep all intermediate results: Usually you want to keep the end results and for instance reports that are generated. Under the hood, NextFlow _will_ keep intermediate results for the `-resume` function to work properly.

The default is to publish nothing. Steps that require publishing can be configured by adding this to the NextFlow platform spec:

```yaml
publish: true
```

### Publish Location

Output is stored under the directory provided on the CLI with the parameter `--output <output>`.

By default, a subdirectory is created corresponding to the unique ID that is passed in the triplet. Let us illustrate this with an example. The following code snippet uses the value of `--input` as an input of a workflow. The input can include a wildcard so that multiple samples can run in parallel. We use the parent directory name (`.getParent().baseName`) as an identifier for the sample. We pass this as the first entry of the triplet:

```groovy
Channel.fromPath(params.input) \
    | map{ it -> [ it.getParent().baseName , it ] } \
    | map{ it -> [ it[0] , it[1], params ] }
    | ...
```

Say the resulting sample names are `SAMPLE1` and `SAMPLE2`. The next step in the pipeline will be published (at least by default) under:

```
<output>/SAMPLE1/
<output>/SAMPLE2/
```

Please note that in general, the first entry of the triplet is a unique ID for this _event_ in the `Channel` and thus will not always be a _sample_ ID.

#### `per_id`

Publishing the results in a subdirectory with this (unique) ID can be avoided using the following attribute in the NextFlow platform spec:

```yaml
per_id: false
```

#### `path`

One more option is available for publishing data during the pipeline run: Sometimes we want to have a bit more control over where things end up inside the `<output>` directory. We can choose to not store the results in ID-specific directories but we can also specify an explicit hierarchy in which the results need to be stored:

```yaml
path: raw_data
```

Or even:

```yaml
path: raw_data/bcl
```

Please note that `per_id` and `path` can be combined.

## TODO

### Packages

The NXF target inherits the R and Python platforms. This should _in principle_ allow a user to specify additional packages to be installed prior to running the function/module. This functionality is not yet available, though.

## Remarks

- A join operation requires a default value for the output file in order to extract the proper extension to be used for the output file.
