---
layout: default
title: Config
nav_order: 4
has_children: true
---

# The viash config file

A viash config file describes the behaviour of a script and the platform
it runs on. It consists of two main sections: `functionality` and
`platforms`.

The [functionality](functionality) section describes the core
functionality of the component, such as its inputs, outputs, arguments,
and extra resources. For each of the arguments, specifying a description
and a set of argument restrictions help create a useful command-line
interface. To ensure that your component works as expected, writing one
or more tests is essential.

The platforms section specifies the requirements to execute the
component on zero or more platforms. The list of currently supported
platforms are [Native](platform-native), [Docker](platform-docker), and
[Nextflow](platform-nextflow). If no platforms are specified, a native
platform with no system requirements is assumed.

Usually, the config file is accompanied by a script which contains the
actual code for the component.

Only a small example of a viash config file is shown below, but check
out the more detailed documentation regarding the
[functionality](functionality), the [Native platform](platform-native),
the [Docker platform](platform-docker), and the [Nextflow
platform](platform-nextflow) for the full specifications for each of
these subsections.

## Example

Contents of [`config.vsh.yaml`](config.vsh.yaml):

``` yaml
functionality:
  name: addrowlines
  description: Add rowlines to a text file.
  arguments:
  - name: input                           
    type: file
    description: The input file.
  resources:
  - type: bash_script
    path: script.sh
platforms:
  - type: native
  - type: docker
    image: bash:4.0
  - type: nextflow
    image: bash:4.0
```

Contents of [`script.sh`](script.sh):

``` bash
cat -n $par_input
```

The component can be executed as follows.

``` bash
viash run config.vsh.yaml -- config.vsh.yaml | head -5
```

         1  functionality:
         2    name: addrowlines
         3    description: Add rowlines to a text file.
         4    arguments:
         5    - name: input                           

Would you rather use Docker as a backend? Easy as pie!

``` bash
viash run -P docker config.vsh.yaml -- config.vsh.yaml | head -5
```

    Unable to find image 'addrowlines:latest' locally
    docker: Error response from daemon: pull access denied for addrowlines, repository does not exist or may require 'docker login': denied: requested access to the resource is denied.
    See 'docker run --help'.

``` bash
viash run config.vsh.yaml -- --help
```

    Add rowlines to a text file.

    Options:
        file
            type: file
            The input file.
