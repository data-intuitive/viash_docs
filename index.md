---
title: "Getting started"
nav_order: 1
has_children: true
---

# Introduction

viash helps you turn a script (Bash/R/Python/Scala/JavaScript) into a reusable component. 
By providing some meta-data regarding its functionality and
the platform on which you want to run the software, viash can help you:

* wrap your script in an executable with a CLI and --help functionality,
* seamlessly execute your component natively on the host platform or in a Docker container
* combine multiple components in a Nextflow pipeline, and
* unit-test your component to ensure that it works at all times.

## Toward building blocks of processing

Here are a few use cases which serve as motivation for viash.

* You developed a Jupyter notebook report for a data analysis. You wish to share it with your colleague, only to spend two hours installing your Conda stack on their laptop.
* You want to combine a couple of tools in a pipeline and every tool has specific requirements on how they should be run. Even worse: some requirements might directly conflict with eachother.
* Your next data analysis project is very similar to the previous project, so you copy and paste the source code. Unfortunately, you detect a bug in some of your code, so now you need to go back and fix the same bug in all the different projects.
* You want to look back at a data analysis you performed two years ago. Unfortunately, the software you used back then is not supported anymore, or the newest version produces totally different results.

## Hello world

You can run a simple 'Hello World' component by running the following command.


{% highlight bash %}
URL=http://www.data-intuitive.com/viash_docs/examples/hello_world/config.vsh.yaml
viash run $URL
{% endhighlight %}




{% highlight text %}
## Hello world!
{% endhighlight %}

{% highlight bash %}
viash run $URL -- --help
{% endhighlight %}

{% highlight text %}
## A very simple 'Hello world' component.
## 
## Options:
##     string1 string2 ...
##         type: string, multiple values allowed
## 
##     --greeter=string
##         type: string, default: Hello world!
{% endhighlight %}

{% highlight bash %}
viash run $URL -- General Kenobi. --greeter="Hello there."
{% endhighlight %}

{% highlight text %}
## Hello there. General Kenobi.
{% endhighlight %}

How does this component work?

The [`config.vsh.yaml`](http://www.data-intuitive.com/viash_docs/examples/hello_world/config.vsh.yaml) is a meta description of the component, containing information such as the name, a description, and the various input and output arguments it has. It also contains a reference to a Bash script 'hello_world.sh'.

```yaml
functionality:
  name: hello_world
  description: A very simple 'Hello world' component.
  arguments:
  - type: string
    name: input
    multiple: true
    multiple_sep: " "
  - type: string
    name: --greeter
    default: "Hello world!"
  resources:
  - type: bash_script
    path: hello_world.sh
  tests:
  - type: bash_script
    path: test_hello_world.sh
platforms:
  - type: native
  - type: docker
    image: bash:4.0
```

The Bash script [`hello_world.sh`](http://www.data-intuitive.com/viash_docs/examples/hello_world/hello_world.sh) are the 'brains' of the componet. It is a very simple bash script which prints out two environment values, `par_greeter` and `par_input`. Where do these variables come from? When executing a component, these values are inserted into the script at runtime.

```bash
#!/usr/bin/env bash

echo $par_greeter $par_input
```

## Further reading
If you want to install viash (which is a super easy thing to do, by the way!) or have a look at some of the other examples we have, click on one of the links below.

If you want more information on more advanced topics, use the navigation bar on the left.
