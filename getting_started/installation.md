---
title: "Installation"
parent: Getting started
nav_order: 1
---

# Installation

## Supported Operating Systems

You can run viash on the following operating systems:

-   Linux
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
your `$PATH` variable. To verify what directories are included, run this
command:

``` bash
echo $PATH
```

#### Installing viash to \~/bin

In order to add `~/bin` to your $PATH, you need to edit `~/.bashrc` or
`~/.zshrc` (depending on the shell you are using) and add the following
line to the end of it:

``` bash
export PATH="$HOME/bin:$PATH"
```

You can use nano for this for example:

``` bash
nano ~/.bashrc
```

Next, create a `~/bin` folder, reload $PATH, download the latest release
of viash to `~/bin` and add executable permissions to viash. Here’s a
one-liner command that does this for you:

``` bash
mkdir ~/bin ; source ~/.bashrc &&
wget "https://github.com/data-intuitive/viash/releases/latest/download/viash" -O ~/bin/viash &&
chmod +x ~/bin/viash
```

**Note**: Replace `~/.bashrc` with `~/.zshrc` in the command above if
you’re using ZSH instead of Bash.

To verify your installation, run the following command:

``` bash
viash --help
```

#### Installing viash to /usr/bin

If you wish to install viash to your usr/bin folder instead, run the
following command:

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
