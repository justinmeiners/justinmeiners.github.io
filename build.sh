#!/bin/sh

MD=$(find * -type f -name '*.md')

for FN in $MD
do 
    # build HTML

    TITLE=$(head -n 1 $FN)
    HN="$(dirname $FN)/index.html"
    cat "template/prefix.html" | sed "s/\$TITLE/$TITLE/g" > $HN
    markdown $FN >> $HN
    cat "template/suffix.html" >> $HN
done


# build rss feed
FEED="feed.xml"
SITE="https://justinmeiners.github.io"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"  > $FEED
echo "<rss version=\"2.0\">" >> $FEED
echo "<channel>" >> $FEED
echo "<title>Justin Meiners</title>" >> $FEED
echo "<description>Welcome to my personal site about programming, mathematics, and philosophy!</description>" >> $FEED
echo "<link>https://justinmeiners.github.io</link>" >> $FEED
echo "<lastBuildDate>$(date +"%a, %d %b %Y %T %z")</lastBuildDate>" >> $FEED


IFS=,

while read LINE
do
    echo "<item>" >> $FEED
    echo -n "["

    COL=0
    for PART in $LINE
    do
        if [ $COL -eq 0 ]
        then
            PUB=$(date -j -f "%m/%d/%Y"  "$PART" +"%a, %d %b %Y 00:00:00 -0600")
            echo "<pubDate>$PUB</pubDate>" >> $FEED
            echo -n "$PART - "
        elif [ $COL -eq 1 ]
        then
            echo "<title>$PART</title>" >> $FEED
            echo -n "$PART]"
        elif [ $COL -eq 2 ]
        then
            if expr "$PART" : "http" > /dev/null
            then
                echo "<guid isPermaLink=\"true\">$PART</guid>" >> $FEED
            else
                echo "<guid isPermaLink=\"true\">$SITE/$PART</guid>" >> $FEED

                CONTENTS=$(cat $PART/README.md | markdown)
                echo "<description><![CDATA[ \n $CONTENTS \n ]]></description>" >> $FEED
            fi
            echo -n "($PART)"
        fi
        echo ""

        COL=$(($COL + 1))
    done

    echo "</item>" >> $FEED
done < template/links

IFS=$SAVE

echo "</channel>" >> $FEED
echo "</rss>" >> $FEED

