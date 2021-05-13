#!/usr/bin/env bash

## VIASH START

par_inputfile="test.md"
par_domain="http://www.data-intuitive.com/viash_docs"

## VIASH END

titles=$(sed -rn 's@^.*\[(.*)\]\((.*)/.*$@\1@p' $par_inputfile)
urls=$(sed -rn 's@^.*\[(.*)\]\((.*)/.*$@\2@p' $par_inputfile)

while IFS= read -r line; do
    url=$line

    if [[ $line != http* ]]; then
        url="$par_domain$line"
    fi

    echo $url

    ## Do a cURL and get the status code from the last response after following any redirects
    status_code=$(curl -ILs --max-redirs 5 $url | tac | grep -m1 HTTP)
    expected_code="200"

    ## Check if status code obtained via cURL contains the expected code
    if [[ $status_code == *$expected_code* ]]; then
        echo "URL is reachable!"
    else
        echo "URL is NOT reachable! Status Code: $status_code"
    fi

done <<<"$urls"
