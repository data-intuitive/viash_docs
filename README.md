## Running a local server

First time setup:

```bash
bin/run_server ---setup
```

To run the server locally, run:
```
bin/run_server
docker kill $(docker ps -q)
```

Open [http://0.0.0.0:4000](http://0.0.0.0:4000).

FYI: `bin/run_server` was built with `viash build src/run_server/config.vsh.yaml -o bin`

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
