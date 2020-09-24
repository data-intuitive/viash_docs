---
layout: default
title: Config
nav_order: 4
has_children: true
---



# The viash config file

A viash config file describes the functionality of the component (e.g. arguments, extra resources),
as well as the platform which will execute the component (e.g. native, docker, nextflow).
Usually, the config file is accompanied by a script which contains the actual code for the
component.

Only a small example of a viash config file is shown below, but check out the more detailed documentation regarding 
the [functionality](functionality), [native platform](platform-native), [docker platform](platform-docker), and [nextflow platform](platform-nextflow) for the full specifications for each of these subsections.

Contents of [`config.vsh.yaml`](../../examples/standalone/addrowlines/config.vsh.yaml):
```yaml
functionality:
  name: addrowlines
  description: Add rowlines to a text file.
  arguments:
  - name: --input                           
    type: file
    description: The input file.
  resources:
  - type: bash_script
    path: script.sh
platforms:
  - type: native
  - type: docker
    image: bash:4.0
  - type: nextflow
    image: bash:4.0
```

Contents of [`script.sh`](../../examples/standalone/addrowlines/script.sh):
```bash
cat -n $par_input
```

The output of simply running this component.

{% highlight bash %}
viash run config.vsh.yaml -- --help
{% endhighlight %}

{% highlight text %}
## Add rowlines to a text file.
## 
## Options:
##     --input=file
##         type: file
##         The input file.
{% endhighlight %}


{% highlight bash %}
viash run config.vsh.yaml -- --input config.vsh.yaml
{% endhighlight %}

{% highlight text %}
##      1	functionality:
##      2	  name: addrowlines
##      3	  description: Add rowlines to a text file.
##      4	  arguments:
##      5	  - name: --input                           
##      6	    type: file
##      7	    description: The input file.
##      8	  resources:
##      9	  - type: bash_script
##     10	    path: script.sh
##     11	platforms:
##     12	  - type: native
##     13	  - type: docker
##     14	    image: bash:4.0
##     15	  - type: nextflow
##     16	    image: bash:4.0
{% endhighlight %}

See the [commands documentation](../../commands) for more information on the different viash commands.
