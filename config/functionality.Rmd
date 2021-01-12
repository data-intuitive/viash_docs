---
title: "Functionality"
nav_order: 1
parent: Config
---

# Functionality
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---


The functionality-part of the config file describes the behaviour of the script in terms of arguments and resources. 
By specifying a few restrictions (e.g. mandatory arguments) and adding some descriptions, viash will automatically generate a stylish command-line interface for you.

## Example
An example of such a functionality yaml can be found below, each part of which is explained in more depth in the following sections. 

```yaml
functionality:
  name: exe
  version: "1.0.0"
  description: |
    This component performs function Y and Z.
    It is possible to make this a multiline string.
  arguments:
    - name: --input
      type: file
      direction: input
      alternatives: [-i]
      description: Input file(s)
      default: input.txt
      must_exist: true
      required: false
      multiple: true
      multiple_sep: ","
    - name: --output                           
      type: file
      direction: output
      alternatives: [-o]
      description: Output file
      default: output.txt
      required: true
      multiple: false
  resources:
    - type: bash_script
      path: script.sh
    - path: additional_resource.txt
  tests:
    - type: bash_script
      path: tests/first_unit_test.sh
    - type: r_script
      path: tests/second_unit_test.R
    - path: tests/test_resource.txt
  authors:
    - name: Bob Cando
      roles: [maintainer, author]
      email: bob@can.do
      props: {github: bobcando, orcid: 0000-0001-0002-0003}
    - name: Tim Farbe
      roles: [author]
      email: tim@far.be
```

## name [string] {#name}
Name of the component and the filename of the executable when built with `viash build`.

Example:
```yaml
name: exe
```

## version [string] {#version}
Version of the component. This field will be used to version the executable and 
the Docker container.

## description [string] {#description}
A description of the component. This will be displayed with `--help`.

Example:
```yaml
description: |
  This component performs function Y and Z.
  It is possible to make this a multiline string.
```

## arguments [list] {#arguments}
A list of arguments for this component. For each argument, a type and a name must be specified. 
Depending on the type of argument, different properties can be set. Common properties for all argument types are the following.

* `type: string/file/integer/double/boolean/boolean_true/boolean_false`, the type of argument determining to what object type the value will be cast in the downstream scripts.
* `direction: input/output`, the directionality of the argument. Only needs to be specified for output files. Default: "input".
* `name: --foo`, the name of the argument. Can also be `-foo` or `foo`. The number of dashes determines how values can be passed: 
  - with `--foo`: long option, e.g. `exe --foo=bar` or `exe --foo bar`
  - with `-foo`: short option, e.g. `exe -foo bar`
  - with `foo`: argument, e.g. `exe bar`
* `alternatives: [-f]`, list of alternative names. Typically only used to provide a short alternative option.
* `description: Description of foo`, a description of the argument. Multiline descriptions are supported.
* `default: bar`, the default value when no argument value is provided. Not allowed when `required: true`.
* `required: true/false`, whether the argument is required. If true and the functionality is executed, an error will be produced if no value is provided. Default = false.
* `multiple: true/false`, whether to treat the argument value as an array or not. Arrays can be passed using the delimiter `--foo=1:2:3` or by providing the same argument multiple times `--foo 1 --foo 2`. Default = false.
* `multiple_sep: ":"`, the delimiter for providing multiple values. Default = ":".

On types: 
* `type: string`, The value passed through an argument of this type is converted to an 'str' object in Python, and to a 'character' object in R. 
* `type: integer`, The resulting value is an 'int' in Python and an 'integer' in R. 
* `type: double`, The resulting value is a 'float' in Python and an 'double' in R. 
* `type: boolean`, The resulting value is a 'bool' in Python and a 'logical' in R.
* `type: boolean_true/boolean_false`, Arguments of this type can only be used by providing a flag `--foo` or not. The resulting value is a 'bool' in Python and a 'logical' in R. These properties cannot be altered: required is false, default is undefined, multiple is false.
* `type: file`, The resulting value is still an 'str' in Python and a 'character' in R. In order to correctly pass files in some platforms (e.g. Docker and Nextflow), viash needs to know which arguments are input/output files. Additional property values:
  - `must_exist: true/false`, denotes whether the file or folder should exist at the start of the execution.

Example:
```yaml
- name: --foo                           
  type: file
  alternatives: [-f]
  description: Description of foo
  default: "/foo/bar"
  must_exist: true
  required: false
  multiple: true
  multiple_sep: ","
```

## resources [list] {#resources}
The first resource should be a script (`bash_script`, `r_script`, `python_script`, `javascript_script`, `scala_script`) which is what will be executed when the functionality is run. Additional resources will be copied to the same directory.

Common properties:

* `type: file/r_script/python_script/bash_script/javascript_script/scala_script`, the type of resource. The first resource cannot be of type `file`. When the type is not specified, the default type is simply `file`. For more information regarding how to write a script in Bash, R or Python with viash, check out the [Guides](../../guides) for the respective languages.
* `name: filename`, the resulting name of the resource.
* `path: path/to/file`, the path of the input file. Can be a relative or an absolute path, or a URI.
* `text: ...multiline text...`, the raw content of the input file. Exactly one of `path` or `text` must be defined, the other undefined.
* `is_executable: true/false`, whether the resulting file is made executable.

Example:

```yaml
resources:
  - type: r_script
    path: script.R
  - type: file
    path: resource1.txt
```

## tests [list] {#tests}

One or more Bash/R/Python scripts to be used to test the component behaviour when `viash test` is invoked. 
Additional files of type `file` will be made available only during testing. Each test script should expect no command-line inputs,
be platform-independent, and return an exit code >0 when unexpected behaviour occurs during testing. See [Testing](../../good_practices/testing)
for more information on how to write tests in each of the different scripting languages.

Example:

```yaml
tests:
  - type: bash_script
    path: tests/test1.sh
  - type: r_script
    path: tests/test2.R
  - path: resource1.txt
```


## authors [list] {#authors}
A list of authors (introduced in viash 0.3.1). An author must at least have a name, but can also have a list of roles, an e-mail address, and a map of custom properties. 

Suggested values for roles are:

Role | Abbrev. | Description
---|---|---
maintainer | mnt | for the maintainer of the code. Ideally, exactly one maintainer is specified.
author | aut | for persons who have made substantial contributions to the software.
contributor | ctb | for persons who have made smaller contributions (such as code patches).
datacontributor | dtc | for persons or organisations that contributed data sets for the software
copyrightholder | cph | for all copyright holders. This is a legal concept so should use the legal name of an institution or corporate body.
funder | fnd | for persons or organizations that furnished financial support for the development of the software

Example:

```yaml
authors:
  - name: Bob Cando
    roles: [maintainer, author]
    email: bob@can.do
    props: {github: bobcando, orcid: 0000-0001-0002-0003}
  - name: Tim Farbe
    roles: [author]
    email: tim@far.be
```
