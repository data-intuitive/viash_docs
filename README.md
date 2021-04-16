## Running a local server

Add to .bashrc:
```bash
export GEM_HOME=/home/<username>/.gem
export PATH="$PATH:$HOME/.gem/bin"
```

Execute the following:

```bash
bundle install
bundle exec jekyll serve --port 4070 --host 127.0.0.1
```

## Building Rmd files to md



First time setup:

```bash
bin/build_rmd ---setup
```

To update an Rmd file, change its content and run:
```bash
bin/build_rmd
```

FYI: `bin/build_rmd` was built with `viash build src/build_rmd/config.vsh.yaml -o bin`
