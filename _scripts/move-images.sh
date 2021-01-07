#!/bin/bash

# Moves JPGs into a subdirectory of the current directory with the same name
# as the original file; file renamed to index.jpg.
#
# i.e. ./galadean.jpg becomes ./galadean/index.jpg
#
# Used to update images to match HTTrack's default file location output.

for f in *.jpg; do
  [[ -f "$f" ]] || continue # skip if not regular file
  dir="${f%.*}" # set the name of the directory to the filename minus extension
  mkdir -p ./"$dir" # create the directory if it doesn't exist
  mv "$f" "$dir/index.jpg" # move the file and rename the image
done