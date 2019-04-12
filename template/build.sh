#!/bin/bash

cd ../
MD=$(find . -type f -name '*.md')

for FN in $MD; do 
    LINE=$(head -n 1 $FN)
    HN="$(dirname $FN)/index.html"
    cat "template/prefix.temp" | sed "s/\$TITLE/${LINE}/g" > $HN
    markdown $FN >> $HN
    cat "template/suffix.temp" >> $HN
done
