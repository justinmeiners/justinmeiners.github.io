#!/bin/sh

SITE="https://www.jmeiners.com"

title_of_html() {
    # query first h1 or h2 element
    NS='http://www.w3.org/1999/xhtml'
    tidy -asxml -quiet  --show-warnings 0 "$1" > "$1.temp"
    (cat "$1.temp" | xmlstarlet sel -N "n=$NS" -t -v "//n:h1[1]") || (cat "$1.temp" | xmlstarlet sel -N "n=$NS" -t -v "//n:h2[1]")
    rm -f "$1.temp"
}

md_pages() {
    # Convert markdown to HTML.
    # note that not all pages are markdown. 
    ALL_MD="$(find . -type f -name '*.md')"
    for MD in $ALL_MD
    do
        D="$(dirname "$MD")"
        BODY="$D/README.body.html"
        markdown "$MD" > "$BODY"

        HTML="$D/index.html"
        export TITLE="$(title_of_html "$BODY")"

        echo "$HTML"

        {
            cat template/prefix.html | envsubst '$TITLE'
            cat "$BODY"
            cat template/suffix.html
        } > "$HTML"
    done
}

rss_items() {
    # Build RSS from all HTML 
    ALL_HTML="$(find . -type f -name '*body.html')"
    for BODY in $ALL_HTML
    do
        D="$(dirname "$BODY")"
        ITEM="$D/body.item.xml"

        echo "$ITEM"

        # date format: RFC822
        DATE_FILE="$D/date.txt"

        export TITLE="$(title_of_html "$BODY")"
        export LINK="$SITE/$(echo "$D" | cut -c 3-)/"
        export DATE="$(head -n 1 "$DATE_FILE")"

        if [ -z "$DATE" ] 
        then
            echo "missing date. skipping"
            continue
        fi

        {
            cat template/rss_prefix.xml | envsubst '$TITLE $LINK $DATE'
            cat "$BODY"
            cat template/rss_suffix.xml
        } > "$ITEM"
    done
}

date_from_item() {
    cat "$1" | xmlstarlet sel -t -v "//pubDate"
}

rss_feed() {
    # first we need to sort everything by date
    mkdir -p temp_feed
    ALL_ITEMS="$(find . -type f -name '*item.xml')"

    for ITEM in $ALL_ITEMS
    do
        RFC_DATE="$(date_from_item "$ITEM")"
        FNAME="temp_feed/$(gdate -d "$RFC_DATE" +%s)"
        echo "$ITEM"
        cat "$ITEM" > "$FNAME"
    done

    ALL_ITEMS="$(find temp_feed -type f | sort -r)"

    # date format: RFC822
    export DATE="$(date +"%a, %d %b %Y %H:%M:%S %z")"
    {

        cat template/rss_header.xml | envsubst '$DATE'
        for ITEM in $ALL_ITEMS
        do
            cat "$ITEM"
        done
        cat template/rss_footer.xml
    } | tidy -w -xml -asxml -quiet > "feed.xml"

    rm -rf temp_feed
}

echo "MARKDOWN"
md_pages

echo "RSS"
rss_items

echo "FEED"
rss_feed

