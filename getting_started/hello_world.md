---
title: "Hello World"
parent: Getting started
nav_order: 2
output:
  md_document:
    variant: markdown_github
    preserve_yaml : true
---

# Hello World

We have provided a simple **Hello World** component as an introduction
to viash. Follow the steps below to learn how to run a component and get
a result back from it.

## Running the Component

You can run a simple ‘Hello World’ component by running the following
command:

``` bash
URL=http://www.data-intuitive.com/viash_docs/examples/hello_world/config.vsh.yaml
viash run $URL
```

    ## Hello world!

Every component accepts –help as an option, which outputs a description
of the component and a list of accepted options. Run the command below
to see the help for the ‘Hello World’ component:

``` bash
viash run $URL -- --help
```

    ## A very simple 'Hello world' component.
    ## 
    ## Options:
    ##     string1 string2 ...
    ##         type: string, multiple values allowed
    ## 
    ##     --greeter=string
    ##         type: string, default: Hello world!

As you can see, the ‘Hello World’ component accepts several string
arguments and a `--greeter` option. Run the command below and replace
NAME with your name to see what happens:

``` bash
viash run $URL -- NAME. --greeter="Hello there,"
```

    ## Hello there, Mike.

## How does the Hello World component work?

When you call ‘viash run’, viash parses the
[`config.vsh.yaml`](http://www.data-intuitive.com/viash_docs/examples/hello_world/config.vsh.yaml)
file, which is a meta description of the component written in the yaml
serialization language:

``` yaml
functionality:
  name: hello_world
  description: A very simple 'Hello world' component.
  arguments:
  - type: string
    name: input
    multiple: true
    multiple_sep: " "
  - type: string
    name: --greeter
    default: "Hello world!"
  resources:
  - type: bash_script
    path: hello_world.sh
  tests:
  - type: bash_script
    path: test_hello_world.sh
platforms:
  - type: native
  - type: docker
    image: bash:4.0
  - type: docker
    id: alpine
    image: alpine
    setup:
      - type: apk
        packages: [ bash ]
```

This config file describes the behavior of a script and the platform it
runs on. Every config file consists of two main sections:
**functionality** and **platforms**.

### Functionality

The **functionality** section describes the core functionality of the
component, such as its inputs, outputs, arguments, and extra resources.
The ‘Hello World’ component accepts two arguments:

-   A `string` named **input** that accepts multiple space-separated
    arguments.
-   A second `string` named **–greeter** which defaults to “Hello
    world!”.

These arguments are passed on to the **resources**. In this case,
there’s a single reference to a file named
[`hello_world.sh`](http://www.data-intuitive.com/viash_docs/examples/hello_world/hello_world.sh).
This file is the ‘brain’ of the component, it’s small Bash script which
prints out two environment values: `par_input` and `par_greeter`:

``` bash
#!/usr/bin/env bash

## VIASH START

par_input="I am debug!"
par_greeter="Hello world!"

## VIASH END

echo $par_greeter $par_input
```

The values of these variables are edited by viash at runtime.

### Platforms
