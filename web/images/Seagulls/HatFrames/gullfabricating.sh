#!/bin/bash
echo "Which gull number is this for???"
read gullNumber
for f in *.png
do
  tempfile="${f##*/}"

  ## display filename
  tmp2="${tempfile%.*}"
  frameNumber="${tmp2:(-2)}"
  location="../Frame${frameNumber}/${gullNumber}.png";
    echo "Processing $f file... for gullnumber $gullNumber I should put it in frame: ${location}"

  # take action on each file. $f store current file name
  mv "$f" $location
  
  
done
