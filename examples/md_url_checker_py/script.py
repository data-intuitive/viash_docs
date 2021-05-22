# Dependancies:
# packages: python3-lxml
# pip: markdown, lxml, requests

## VIASH START

par = {
  "inputfile": "Testfile.md",
  "domain": "http://www.data-intuitive.com/viash_docs",
  "output": "output.txt"
}

## VIASH END

import markdown
from lxml import etree
import requests

with open(par["inputfile"], encoding="utf8") as file:
    md = file.read().replace('\n', '')

doc = etree.fromstring(markdown.markdown(md))

output_file = open(par['output'], 'a')
output_file.truncate(0)

amount_of_urls = len(doc.xpath('//a'))
amount_of_errors = 0

for index, link in enumerate(doc.xpath('//a')):
    title = link.text
    url = link.get('href')

    if not url.startswith('http'):
        url = par["domain"] + url

    print(str(index+1) + ": " + url)

    output_file.write("Link name: " + title + "\n")
    output_file.write("URL: " + url + "\n")

    expected_code = 200

    try:
        req = requests.head(url, allow_redirects=True)

        if req.status_code == 200:
            print('OK')
            output_file.write("Status: OK, can be reached.\n")
        else:
            print(req.status_code) 
            output_file.write("Status: ERROR! URL cannot be reached. Status code: " + str(req.status_code) + "\n")
            amount_of_errors+=1

    except requests.ConnectionError:
        print("Could not connect")
        output_file.write("Status: ERROR! URL cannot be reached. A connection error occured.\n")
        amount_of_errors+=1

    output_file.write("---\n")

print("\n" + par["inputfile"] + " has been checked and a report named " + par["output"] + " has been generated.\n" +
str(amount_of_errors) + " of " + str(amount_of_urls) + " URLs could not be resolved.")