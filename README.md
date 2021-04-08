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

To update an Rmd file, change its content and run:
```bash
Rscript R/build.R
```
