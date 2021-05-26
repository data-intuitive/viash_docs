---
title: "Getting started"
nav_order: 1
has_children: true
editor_options: 
  chunk_output_type: inline
---

# Introduction

<!-- TODO: What is viash if you would describe it in one or two sentences?
viash is a ... -->

viash helps you turn a script (Bash/R/Python/Scala/JavaScript) into a
reusable component. By providing some meta-data regarding its
functionality and the platform on which you want to run the software,
viash can help you:

-   Wrap your script in an executable with a CLI and `--help`
    functionality.
-   Seamlessly execute your component natively on the host platform or
    in a **Docker** container.
-   Combine multiple components in a **Nextflow** pipeline.
-   Unit-test your component to ensure that it works at all times.

## Example use cases

Here are a few use cases which serve as motivation for viash:

<!-- TODO: Rewrite use cases, the reason why viash helps in those situations should be crystal clear to someone that has never seen viash before, this part of the docs is presented before the installation after all. Ideally each of these should have "viash can help here by../In this case, viash can.../etc." -->

-   You want to combine several tools in a pipeline and every tool has
    specific requirements on how they should be run. Even worse: some
    requirements might directly conflict with each other.
-   Your next data analysis project is very similar to the previous
    project, so you copy and paste the source code. Unfortunately, you
    detect a bug in some of your code, so now you need to go back and
    fix the same bug in all the different projects.
-   You want to look back at a data analysis you performed two years
    ago. Unfortunately, the software you used back then is not supported
    anymore, or the newest version produces totally different results.
    With viash you can package the older version together with its
    dependencies in an executable so you don’t have to worry about
    conflicts or deprecated versions
-   You developed a [Jupyter](https://jupyter.org/) notebook report for
    a data analysis. You wish to share it with your colleague, only to
    spend two hours installing your [Conda](https://docs.conda.io/)
    stack on their laptop.

## Getting started

Here are some links to get you started with viash:

-   [Installing viash](/getting_started/installation): This guide walks
    you through the steps to install viash on your machine.
-   [Running your first component
    (Bash)](/getting_started/hello_world_bash): Get a feel for viash
    with a classic **Hello World** tutorial, written in Bash.
-   [Running your first component
    (Python)](/getting_started/hello_world_python): Get a feel for viash
    with a classic **Hello World** tutorial, written in Python.
-   [Running your first component (R)](/getting_started/hello_world_r):
    Get a feel for viash with a classic **Hello World** tutorial,
    written in R.

## Documentation

Once you understand how viash works and what it could do for you, take a
look at our docs:

-   [Commands](/commands)
-   [Config files](/config)
-   [Good practices](/good_practices)

Check out the navigation menu on the left for more in-depth information
about each topic.
