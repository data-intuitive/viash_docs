---
title: "Workflow"
---

## Introduction

When it comes to dealing with multiple components in scripts or pipelines, [namespaces](/docs/namespaces/) can get you started to cope with that. What namespaces does not solve (at least not out of the box and in the current versions of `viash`) is the management of containers.

If you want to run a component in a container and the container exists, it's as simple as adding `image: ...` to the docker platform specification. When modifications are required, you could make a habit of creating the container first and using that. But when other people, possibly on other compute nodes need to use the same container its build definition has to be shared and should be kept close to the component sources. That would quickly become a maintenance nightmare.

In order to avoid this situation, `viash` can be configured so the development and deployment workflow be as smooth as possible.

## Docker platform spec

`viash` version 0.2.0 allows for a number of Docker-specific build instructions. Let us take a look at an example to get a feeling of what is possible. This example is for a component that runs [CellRanger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger):

```yaml
functionality:
  name: cellranger
  description: Run CellRanger count or other methods
  (...)
  resources:
  - type: bash_script
    path: script.sh
  - type: file
    path: resources/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm
  - type: file
    path: resources/cellranger-4.0.0.tar.gz
  (...)
platforms:
- type: docker
  image: ubuntu:bionic
  target_image: itx-aiv.artifactrepo.jnj.com/mapping-cellranger
  apt:
    packages: [ bsdtar, p7zip, cpio, wget, unzip ]
  docker:
    resources:
    - bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm /tmp
    - cellranger-4.0.0.tar.gz /opt
    run:
    - |
      cd /tmp && \
          7zr x bcl2fastq2-v2.20.0*-Linux-x86_64.rpm && \
          cpio -idmv "./usr/local/bin/bcl2fastq" < bcl2fastq2-v2.20.0.422-Linux-x86_64 && \
          mv usr/local/bin/bcl2fastq /usr/bin
    - |
      cd /opt && \
          tar -xzvf cellranger-4.0.0.tar.gz && \
          export PATH=/opt/cellranger-4.0.0:$PATH && \
          ln -s /opt/cellranger-4.0.0/cellranger /usr/bin/cellranger && \
          rm -f /opt/cellranger-4.0.0.tar.gz
  (...)
- type: nextflow
  image: itx-aiv.artifactrepo.jnj.com/mapping-cellranger
```

Let us strip down what happens above step by step:

- We start from the `ubuntu:bionic` image.
- We install additional packages (`apt: ...`)
- We copy some _resources_ to be used during build[^1] which can be seen in `functionality.resources`
- We specify under `docker.resources` what resources should be copied where in the `Dockerfile`
- We add the installation scripts (`docker.run`) for these two tools/packages
- We specify a Docker prefix in the target image. This prefix is specific for the Janssen `itx-aiv` account
- The NextFlow target is configured to use the generated image

[^1]: Please note that `viash` currently does not have a notion of a build resource or runtime resource. This means that all resources are currently copied along to all targets. We will tackle this in a future version of `viash`.

## Workflow

And now comes the fun part. What happens when you want to run such a component?

1. Clone the component
2. Run `viash` to generate the `docker` target build
3. Make sure the container is available. run e.g. `target/mapping/cellranger/cellranger ---setup` which will build the container _unless_ it is available either locally or via the configured registry (in this case the Artifactory Docker registry).
4. If the container _is_ available but needs to be pulled from a registry, this will happen automatically. Given the right credentials are configured for Docker to work.

Please note that we could also specify a Docker HUB organization registry, i.e.:

```yaml
platforms:
- type: docker
  image: dataintuitive/viash:0.2.0-rc3
  target_image: dataintuitive/viash_docs
```

## Janssen

The above workflow fits nicely within the Janssen/Artifactory setup. Using the `viash_jnj` component to convert a repository of Docker targets to an SCM build repository all the components can be built. During development, the image can be built locally and tested with the same name/tag that will later appear in Artifactory.

## Caveat

Since we do not have a distinction between build resources and runtime resources, all of these are copied with the builds and thus end up under `target/`. Even though, once the container is built, we don't need the original sources anymore.
