---
layout: default
title: Commands
nav_order: 3
has_children: true
---

# Commands

viash has three main commands:

* [`viash run config.vsh.yaml`](../run): Run a component from the provided config file.
* [`viash build config.vsh.yaml`](../build): Build a component to an executable using a specified platform.
* [`viash test config.vsh.yaml`](../test): Test a component.
* [`viash ns build`](../ns-build): Build many viash components.

A [viash config](../../config) file describes the functionality of the component (e.g. arguments, extra resources),
as well as the platform which will execute the component (e.g. native, docker, nextflow).
Usually, the config file is accompanied by a script which contains the actual code for the
component.
