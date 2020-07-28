viash: from scripts to pipelines
================

  - [Motivation](#motivation)
  - [Install](#install)
      - [Packaged Release](#packaged-release)
      - [Build from Source](#build-from-source)
      - [Build from Source using
        Docker](#build-from-source-using-docker)
  - [First execution](#first-execution)
  - [More documentation](#more-documentation)

Viash helps you turn a Bash/R/Python script into a reusable component.
By providing some meta-data regarding its functionality and the platform
on which you want to run the software, viash can help you:

  - wrap your script in an executable with a CLI and –help
    functionality,
  - seamlessly execute your component natively on the host platform or
    in a Docker container
  - combine multiple components in a Nextflow pipeline, and
  - unit-test your component to ensure that it works at all times.

## Motivation

Here are a few use cases which serve as motivation for viash.

  - You developed a Jupyter notebook report for a data analysis. You
    wish to share it with your colleague, only to spend two hours
    installing your Conda stack on their laptop.
  - You want to combine a couple of tools in a pipeline and every tool
    has specific requirements on how they should be run. Even worse:
    some requirements might directly conflict with eachother.
  - Your next data analysis project is very similar to the previous
    project, so you copy and paste the source code. Unfortunately, you
    detect a bug in some of your code, so now you need to go back and
    fix the same bug in all the different projects.
  - You want to look back at a data analysis you performed two years
    ago. Unfortunately, the software you used back then is not supported
    anymore, or the newest version produces totally different results.

## Install

Viash is developed in Scala (2.12). You’ll need a working Java
installation (tested with version 1.8) in order to use it. Viash is
tested and used on MacOS and Linux systems. Windows is currently not
tested, although there is no reason it should not run on
[WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

### Packaged Release

To install viash, download the [latest
release](https://github.com/data-intuitive/Viash/releases) and save it
to the `~/.local/bin` folder or any other directory that is on your
`$PATH`.

### Build from Source

The following needs to be installed on your system in order to install
Viash:

  - GNU
    [Autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html#Autotools-Introduction)
  - Java 1.8
  - `sbt`

To build and install viash, run the following commands.

``` bash
./configure --prefix=~/.local
make
make install
viash --help
```

If you wish to install viash for all users and not just yourself, run
the following commands instead.

``` bash
./configure
make
sudo make install
viash --help
```

### Build from Source using Docker

If you have Java and Docker installed, but not `sbt`, run this instead:

``` bash
./configure --prefix=~/.local
make with-docker
make install
viash --help
```

## First execution

You can run a simple ‘Hello World’ component by running the following
command.

``` bash
HELLO=https://raw.githubusercontent.com/data-intuitive/viash_docs/master/docs/examples/hello_world/functionality.yaml
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
script”](docs/wrapping_a_bash_script.md) to learn how this component
was written.

## More documentation

The following vignettes can help you get started with viash in a flash\!

  - [Viash sub-commands](docs/viash_commands.md)
  - [Wrapping a Bash script](docs/wrapping_a_bash_script.md)
  - [Wrapping an R script](docs/wrapping_an_r_script.md)
  - [Wrapping a Python script](docs/wrapping_a_python_script.md)
  - [Wrapping an R Markdown
    report](docs/wrapping_an_rmarkdown_report.md)
  - [Wrapping an executable](docs/wrapping_an_executable.md)
  - [Description of the functionality.yaml
    format](docs/functionality.md)
  - [Description of the platform.yaml format](docs/platform.md)

For more real-world examples, check out [docs/examples](docs/examples).
