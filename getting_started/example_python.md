---
title: "Python example"
parent: Getting started
---

WIP. Example copied from functionality.Rmd.

```python
## VIASH START
par = {
  'input': 'script.py',
  'output': 'output.txt',
  'remove_odd_lines': True
}
resource_dir = "."
## VIASH END

with open(par['input'], 'r') as fin:
  with open(par['output'], 'w') as fout:
    for count, line in enumerate(fin, start=1):
      if count % 2 == 0 or not par['remove_odd_lines']:
        fout.write(line)
```
