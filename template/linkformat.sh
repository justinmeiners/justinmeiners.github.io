read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

TITLE=""
LINK=""
PUB=""

while read_dom; do
    if [[ $ENTITY = "title" ]]; then
        TITLE=$CONTENT
    fi
    if [[ $ENTITY = "pubDate" ]]; then
        PUB=$CONTENT
        DATETXT=$(date -j -f "%a, %d %b %Y %T %z" "$PUB" +"%m/%d/%Y")
        echo "<a href=\"$LINK\">$DATETXT - $TITLE</a>"
    fi
    if [[ $ENTITY = "link" ]]; then
        LINK=$CONTENT
    fi
done

