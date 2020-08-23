---
nav_order: 1
---

viash: from scripts to pipelines
================

This repository contains documentation for viash.

## First execution

You can run a simple ‘Hello World’ component by running the following
command.

``` bash
HELLO=https://raw.githubusercontent.com/data-intuitive/viash_docs/master/examples/hello_world/functionality.yaml
viash run -f $HELLO
```

    ## Hello world!

``` bash
viash run -f $HELLO -- --help
```

    ## A very simple 'Hello world' component.
    ## 
    ## Options:
    ##     string1 string2 ...
    ##         type: string, multiple values allowed
    ## 
    ##     --greeter=string
    ##         type: string, default: Hello world!

``` bash
viash run -f $HELLO -- General Kenobi. --greeter="Hello there."
```

    ## Hello there. General Kenobi.

Check out the vignette [“Wrapping a Bash
script”](wrapping_a_bash_script.md) to learn how this component was
written.

## More documentation

The following vignettes can help you get started with viash in a flash\!

  - [Viash sub-commands](viash_commands.md)
  - [Wrapping a Bash script](wrapping_a_bash_script.md)
  - [Wrapping an R script](wrapping_an_r_script.md)
  - [Wrapping a Python script](wrapping_a_python_script.md)
  - [Wrapping an R Markdown report](wrapping_an_rmarkdown_report.md)
  - [Wrapping an executable](wrapping_an_executable.md)
  - [Description of the functionality.yaml format](functionality.md)
  - [Description of the platform.yaml format](platform.md)

For more real-world examples, check out [examples](examples).
