#!/bin/bash

cd ../
MD=$(find . -type f -name '*.md')

for FN in $MD; do 
    LINE=$(head -n 1 $FN)
    HN="$(dirname $FN)/index.html"
    cat "template/prefix.html" | sed "s/\$TITLE/${LINE}/g" > $HN
    markdown $FN >> $HN
    cat "template/suffix.html" >> $HN
done

# RSS and home feed

FEED="feed.xml"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"  > $FEED
echo "<rss version=\"2.0\">" >> $FEED
echo "<channel>" >> $FEED
cat "template/channel.xml" >> $FEED
echo "<lastBuildDate>$(date -R)</lastBuildDate>" >> $FEED

cat "template/articles.xml" >> $FEED
echo "</channel>" >> $FEED

cat "template/articles.xml" | ./template/linkformat.sh 

