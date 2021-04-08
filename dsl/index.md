---
layout: default
title: Command DSL
nav_order: 5
has_children: true
---

# Command DSL

Since version 0.4.0, viash supports modifying a [viash config](/config)
YAML at runtime using a custom DSL. This allows making dynamic changes
to your projects. All viash subcommands have support for the DSL through
the `-c` parameter.

The easiest way to explain is perhaps by showing some examples. The
following statements are all valid under the DSL definition.

Changing the version of a component:

    .functionality.version := "0.3.0"

Changing the registry of docker containers.

    .platforms[.type == "docker"].container_registry := "url-to-registry"

Adding an author to the list:

    .functionality.authors += { name: "Mr. T", role: "sponsor" }

These commands come in really handy when building a lot of components,
for example using the following command:

``` bash
viash ns build \
  -c '.functionality.version := "0.3.0"' \
  -c '.platforms[.type == "docker"].container_registry := "url-to-registry"' \
  -c '.functionality.authors += { name: "Mr. T", role: "sponsor" }'
```
