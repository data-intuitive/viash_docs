---
title: "Frequently asked questions"
has_children: false
---

# Frequently Asked Questions

<!-- Why does this page exist?  -->

## Running Components

### Running a component throws an ‘Unable to find image’ error. How do I fix this?

Depending on how an executable was created, a Docker container might not
have been created.

To solve this issue, run the executable with a `---setup` flag attached.
This will automatically build the Docker container for you.

``` bash
$ target/docker/foo/foo ---setup
> docker build -t foo:0.0.1 /home/rcannood/workspace/viash_temp/viashsetupdocker-foo-KeBjFs
```

Or when working with `viash run`:

``` bash
$ viash run src/mnn/config.vsh.yaml -- ---setup
> docker build -t foo:0.0.1 /home/rcannood/workspace/viash_temp/viashsetupdocker-foo-KeBjFs
```
