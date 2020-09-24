---
title: "Introduction"
nav_order: 1
---

# Introduction

viash is a spec and a tool for defining execution contexts and converting execution instructions to concrete instantiations.

## Toward Building Blocks of Processing

We can look at this from a myriad of angles, but let's cover a few ones:

- How many times have you downloaded a tool from the net because you wanted to try it out, only to find out that getting the dependency requirements right takes a few days?
- Have you encountered the situation where you want to combine a couple of tools in a pipeline and every tools has dedicated specs on how they should be run?
- You're developing a jupyter notebook report for a data analysis. You want your colleague to take a look but she does not have the proper tools installs. You spend 2 hours installing your Jupyter/Conda/... stack on her laptop.
- etc.

And the list indeed goes on. We thought it time to revisit the whole dependency management thing. Not just by stating that docker is the solution (it may be part of the solution) but to rethink the whole challenge from scratch.

## What can Viash do for you?

- **Pimp my script**: Given a script and some meta-information of its parameters, Viash will generate a complete CLI for you. Currently supported scripting languages are R, Python and Bash.
- **(W)rap it up**: In addition, given more meta-information on the platform on which to run it, Viash will wrap the script in an executable which uses the provided platform as backend. Currently supported platforms are Native, Docker and Nextflow.
