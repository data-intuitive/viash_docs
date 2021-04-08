Add to .bashrc:
```bash
export GEM_HOME=/home/<username>/.gem
export PATH="$PATH:$HOME/.gem/bin"
```

To run from R, execute the following:

```bash
bundle install
bundle exec R
```

Once in R:
```R
blogdown::serve_site()
```
