Hello world
================

This component was written for the vignette [“Wrapping a Bash script
with viash”](../../wrapping_a_bash_script.md), which provides an
explanation of the files found in this folder.

## Alpine linux

``` bash
viash run config.vsh.yaml -p alpine -- ---setup
viash run config.vsh.yaml -p alpine
```

    ## > docker build -t hello_world:latest /home/rcannood/workspace/viash_temp/viashsetupdocker-hello_world-gWEYa0
    ## Sending build context to Docker daemon  15.36kB
    ## 
    ## Step 1/2 : FROM alpine
    ##  ---> e50c909a8df2
    ## Step 2/2 : RUN apk add --no-cache bash
    ##  ---> Using cache
    ##  ---> 4b7dc70b8fef
    ## Successfully built 4b7dc70b8fef
    ## Successfully tagged hello_world:latest
    ## Hello world!
