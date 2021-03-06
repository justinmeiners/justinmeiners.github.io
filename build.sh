#!/bin/sh

ALL_MD=$(find * -type f -name '*.md')

for MD in $ALL_MD
do 
    # build HTML

    TITLE=$(head -n 1 $MD)
    BODY_HTML="$(dirname $MD)/README.html"
    HTML="$(dirname $MD)/index.html"

    markdown $MD >> $BODY_HTML

    export TITLE
    cat "template/prefix.html" | envsubst '$TITLE' > $HTML
    cat $BODY_HTML >> $HTML
    cat "template/suffix.html" >> $HTML
done


# build rss feed
python3 template/build_rss.py > "feed.xml"

for MD in $ALL_MD
do 
    BODY_HTML="$(dirname $MD)/README.html"
    rm $BODY_HTML
done
