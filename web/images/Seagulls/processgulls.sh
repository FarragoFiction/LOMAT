#!/bin/bash
number=6
for f in *.png
do
  tempfile="${f##*/}"

  ## display filename
  fileName="${f%.*}"
  echo "Processing $f file...I think it should be ${fileName}/${number}.png so i'll make a new dir"

  mkdir "${fileName}"
  # take action on each file. $f store current file name
  mv "$f" "${fileName}/${number}.png"

done
