---
title: "Installation"
nav_order: 2
---


Viash is developed in Scala (2.12). You'll need a working Java installation (tested with version 1.8) in order to use it. Viash is tested and used on MacOS and Linux systems. Windows is currently not tested, although there is no reason is shouldn't run on [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

Make sure Viash (`viash`) is available in your `$PATH` and run:

```bash
viash --help
```

## Install

### Packaged Release

To install viash, download the [latest release](https://github.com/data-intuitive/Viash/releases) and save it to the `~/bin` folder or any other directory that is on your `$PATH`.

### Build from Source

The following needs to be installed on your system in order to install Viash:

- GNU [Autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html#Autotools-Introduction)
- Java 1.8
- `sbt`

To build and install viash, run the following commands.
```bash
./configure --prefix=~
make
make install
viash --help
```

If you wish to install viash for all users and not just yourself, run the following commands instead.
```bash
./configure
make
sudo make install
viash --help
```

### Build from Source using Docker

If you have Java and Docker installed, but not `sbt`, run this instead:

```bash
./configure --prefix=~
make docker
make install
viash --help
```
