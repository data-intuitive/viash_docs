# Civ6 Post-Game Summary

This is a toy dataset which uses savefiles from a game called Civilization VI and generates a post-game video of the in-game tile ownership over time.

## Build
First build the pipeline. This might take a while.
```bash
viash ns build -s src -t target -P docker --setup
```

## Run
Generate the post-game summary movie (stored at `output/output.webm`) by running:
```bash
./main.sh
```