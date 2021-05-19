---
title: "Creating a Bash component"
parent: Creating components
---

# Developing a new viash component

In this tutorial, you’ll create a component that does the following:

-   Extract all hyperlinks from a markdown file
-   Check if every URL is reachable
-   Create a text report with the results

The component will be able to run locally and as a docker container. In
order to create a component you need two files: a script for the
functionality and a config file that describes the component. Let’s get
started!

## Prerequisites

To follow along with this tutorial, you need to have this software
installed on your machine:

-   An [installation of viash](/getting_started/installation).
-   A **Unix shell** like Bash or Zsh.

We recommend you take a look at the [hello world
example](/getting_started/hello_world_bash) first to understand how
components work.

## Write a script in Bash

The first step of developing this component, is writing the core
functionality of the component, in this case a bash script.  
Create a new folder named “my\_viash\_component” and open it. Now create
a new file named **script.sh** in there and add this code as its
content:

``` bash
#!/usr/bin/env bash

## VIASH START

par_inputfile="Testfile.md"
par_domain="http://www.data-intuitive.com/viash_docs"
par_output="output.txt"

## VIASH END

amount_of_errors=0

echo "Extracting URLs"

# Extract the titles and URLs from the markdown file with sed and put them into arrays
readarray -t title_array <<<$(sed -rn 's@^.*\[(.*)\]\((.*)\).*$@\1@p' $par_inputfile)
readarray -t url_array <<<$(sed -rn 's@^.*\[(.*)\]\((.*)\).*$@\2@p' $par_inputfile)

# Get length of array
amount_of_urls=$(echo "${#url_array[@]}")

echo "Checking $amount_of_urls URLs"

# Clear file
>$par_output

# Print each value of the array by using loop
for ((n = 0; n < ${#title_array[*]}; n++)); do
    title="${title_array[n]}"
    url="${url_array[n]}"

    # If an URL doesn't start with 'http', add the domain before it
    if [[ $url != http* ]]; then
        url="$par_domain${url_array[n]}"
    fi

    echo "$(($n + 1)): $url"

    echo -e "Link name: $title" >>$par_output
    echo -e "URL: $url" >>$par_output

    # Do a cURL and get the status code from the last response after following any redirects
    status_code=$(curl -ILs --max-redirs 5 $url | tac | grep -m1 HTTP)
    expected_code="200"

    # Check if status code obtained via cURL contains the expected code
    if [[ $status_code == *$expected_code* ]]; then
        echo "OK"
        echo -e "Status: OK, can be reached." >>$par_output
    else
        echo $status_code
        echo -e "Status: ERROR! URL cannot be reached. Status code: $status_code" >>$par_output
        amount_of_errors=$(($amount_of_errors + 1))
    fi

    echo -e "---" >>$par_output
done

echo "$par_inputfile has been checked and a report named $par_output has been generated. $amount_of_errors of $amount_of_urls URLs could not be resolved."
```

## Describe the component using YAML

## Run the component

## Building an executable

#### Write a script in Bash

This is a simple script which prints a simple message, along with any
input provided to it through the `par_input` parameter. Optionally, you
can override the greeter with `par_greeter`.

Anything between the `## VIASH START` and `## VIASH END` lines will
automatically be replaced at runtime with parameter values from the CLI.
Anything between these two lines can be used to test the script without
viash:

``` bash
./script.sh
```

    Extracting URLs
    Checking 6 URLs
    1: https://www.google.com
    OK
    2: https://www.reddit.com
    OK
    3: http://microsoft.com/random-link
    HTTP/2 404 
    4: http://www.data-intuitive.com/viash_docs/
    OK
    5: http://www.data-intuitive.com/viash_docs/getting_started/installation
    OK
    6: http://www.data-intuitive.com/viash_docs/good_practices/testing
    OK
    Testfile.md has been checked and a report named output.txt has been generated. 1 of 6 URLs could not be resolved.

Next, we write a meta-file describing the functionality of this
component in YAML format.

#### Describe the component with as a YAML

A [viash config](/config) file describes the behaviour of a script and
the platform it runs on. It consists of two main sections:
`functionality` and `platforms`.

Contents of [`yaml`](config.vsh.yaml):

``` bash
functionality:
  name: check_if_urls_reachable
  description: Check URLs in a markdown are reachable and create a text report with the results.
  arguments:                     
  - type: file
    name: --inputfile
    description: The input markdown file.
    required: true
    must_exist: true
  - type: string                           
    name: --domain
    description: The domain URL that gets inserted before any relative URLs.
  - type: string                           
    name: --output
    description: The path of the output text file.
    default: "output.txt"
  resources:
  - type: bash_script
    path: script.sh
platforms:
  - type: native
  - type: docker
    image: bash:latest
    setup:
      - type: apk
        packages: [ curl ]
```

The [functionality](config/functionality) section describes the core
functionality of the component, such as its inputs, outputs, arguments,
and extra resources. For each of the arguments, specifying a description
and a set of argument restrictions help create a useful command-line
interface. To ensure that your component works as expected, writing one
or more tests is essential.

The platforms section specifies the requirements to execute the
component on zero or more platforms. The list of currently supported
platforms are [Native](config/platform-native),
[Docker](config/platform-docker), and
[Nextflow](config/platform-nextflow). If no platforms are specified, a
native platform with no system requirements is assumed.

### Writing a first unit test

Writing a unit test for a viash component is relatively simple. You just
need to write a Bash script (or R, or Python) which runs the executable
multiple times, and verifies the output. Take note that the test needs
to produce an error code not equal to 0 when a mistake is found.

TODO: Add unit test

When running the test, viash will automatically build an executable and
place it – along with other resources and test resources – in a
temporary working directory.
