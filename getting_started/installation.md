---
title: "Installation"
parent: Getting started
nav_order: 1
output:
  md_document:
    variant: markdown_github
    preserve_yaml : true
---

# Installation

## Supported Operating Systems

You can run viash on the following operating systems:

-   linux
-   macOS
-   Windows using [Windows Subsystem for
    Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

## Prerequisites

-   viash is developed in [Scala 2.12](https://www.scala-lang.org/), so
    you’ll need an [Oracle Java SE Runtime Environment 8
    installation](https://www.oracle.com/java/technologies/javase-jre8-downloads.html)
    in order to use it.

## Installing viash

### Packaged Release

To install viash, download the [latest
release](https://github.com/data-intuitive/viash/releases/latest) and
save it to the `~/bin` folder or any other directory that is specified
your `$PATH` variable.

Here’s a one-liner command to download the latest release of viash to
your `~/bin` folder:

``` bash
sudo wget "https://github.com/data-intuitive/viash/releases/latest/download/viash" -O /usr/bin/viash
```

To verify your installation, run the following command:

``` bash
viash --help
```

### Build from Source

The following needs to be installed on your system in order to install
viash:

-   GNU
    [Autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html#Autotools-Introduction)
-   [Oracle Java SE Runtime Environment 8
    installation](https://www.oracle.com/java/technologies/javase-jre8-downloads.html)
-   [sbt](https://www.scala-sbt.org/)

To build and install viash, run the following commands.

``` bash
./configure --prefix=~
make
make install
```

If you wish to install viash for all users and not just yourself, run
the following commands instead.

``` bash
./configure
make
sudo make install
```

To verify your installation, run the following command:

``` bash
viash --help
```

### Build from Source using Docker

If you have Java and Docker installed, but not `sbt`, run this instead:

``` bash
./configure --prefix=~
make docker
make install
```

To verify your installation, run the following command:

``` bash
viash --help
```
