---
layout: default
title: Getting started
nav_order: 2
has_children: true
---

# Getting started

You can run a simple 'Hello World' component by running the following command.


{% highlight bash %}
URL=https://raw.githubusercontent.com/data-intuitive/viash_docs/master/examples/toys/hello_world/config.vsh.yaml
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
