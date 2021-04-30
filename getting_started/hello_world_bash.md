---
title: "Hello World (Bash)"
parent: Getting started
nav_order: 2
---

# Hello World

We have provided a simple **Hello World** component as an introduction
to viash. Follow the steps below to learn how to run a component and get
a result back from it.

## Prerequisites

To follow along with this tutorial, you need to have this software
installed on your machine:

-   An [installation of viash](../installation).
-   A **Unix shell** like Bash or Zsh.

## Running the Component

You can run a simple ‘Hello World’ component by running the following
command:

``` bash
URL=http://www.data-intuitive.com/viash_docs/examples/hello_world/config.vsh.yaml
viash run $URL
```

    Hello world!

Every component accepts –help as an option, which outputs a description
of the component and a list of accepted options. Run the command below
to see the help for the ‘Hello World’ component:

``` bash
viash run $URL -- --help
```

    A very simple 'Hello world' component.

    Options:
        string1 string2 ...
            type: string, multiple values allowed

        --greeter=string
            type: string, default: Hello world!

As you can see, the ‘Hello World’ component accepts several string
arguments and a `--greeter` option. Run the command below and replace
NAME with your name to see what happens:

``` bash
viash run $URL -- NAME. --greeter="Hello there,"
```

    Hello there, NAME.

## How Does the Hello World Component Work?

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
    path: script.sh
  tests:
  - type: bash_script
    path: test.sh
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

The **functionality** attribute describes the core functionality of the
component, such as its inputs, outputs, arguments, and extra resources.
The ‘Hello World’ component accepts two arguments:

-   A `string` named **input** that accepts multiple space-separated
    arguments.
-   A second `string` named **–greeter** which defaults to “Hello
    world!”.

These arguments are passed on to the **resources**. In this case,
there’s a single reference to a file named
[`script.sh`](http://www.data-intuitive.com/viash_docs/examples/hello_world/script.sh).
This file is the ‘brain’ of the component, it’s small Bash script which
prints out two environment values: `par_input` and `par_greeter`:

``` bash
## VIASH START
par_input="I am debug!"
par_greeter="Hello world!"
## VIASH END

echo $par_greeter $par_input
```

Any variables defined in the config file will be automatically generated
between the `## VIASH START` and `## VIASH END` lines. You can add
pre-defined values here for debugging purposes by adding the variables
and adding the `par_` prefix, their values will automatically be
replaced at runtime with parameter values from the CLI.

Finally, there’s a **tests** section to put your test scripts. It’s a
good practice to write tests and run these every time you update your
component and/or the resources. You can read more about writing and
running viash tests [on the Testing
page](http://www.data-intuitive.com/viash_docs/good_practices/testing/).

### Platforms

The **platforms** attribute specifies the requirements to execute the
component on one or more platforms:

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

The list of currently supported platforms are
[Native](/config/platform-native/), [Docker](/config/platform-docker/),
and [Nextflow](/config/platform-nextflow/). If no platforms are
specified, a native platform with no system requirements is assumed.

You can specify what platform a component should run on by passing the
`-p` or `--platform` option. For example, try running the following
command:

``` bash
viash run -p native $URL -- NAME. --greeter="Hello there,"
```

    Hello there, NAME.

The results should be exactly the same as viash automatically picks the
first platform when you don’t pass the platform option, in this case
that’s `native`.

## Exporting a Component as an Executable

Components can be exported to executables, making it easy to share
scripted functionality without the need to have viash installed on the
target system.  
Run the following command to make viash parse the config file and export
the result to an executable called **hello\_world** in a (new) folder
named **my\_hello\_world**:

``` bash
viash build $URL -o my_hello_world
```

You can now run the following command to run the generated executable:

``` bash
my_hello_world/hello_world NAME. --greeter="Hello there,"
```

    Hello there, NAME.

## What’s Next?

Now that you understand the basics of how viash works, take a look at
how to write your own component:

-   [Bash example](/getting_started/example_bash)
-   [Python example](/getting_started/example_python)
-   [R example](/getting_started/example_r)
