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

echo ""
echo "$par_inputfile has been checked and a report named $par_output has been generated.
$amount_of_errors of $amount_of_urls URLs could not be resolved."
