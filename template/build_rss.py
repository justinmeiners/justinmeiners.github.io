import sys
import re
from datetime import datetime
from operator import itemgetter

RFC_FORMAT="%a, %d %b %Y %H:%M:%S %z"
SITE='https://justinmeiners.github.io/'

entries = []
with open("README.md", 'r') as f:
    for line in f:
        m = re.search(r'\[([0-9\/]+) - ([^\]]+)\]\(([^\)]+)', line)
        if m:
            date = datetime.strptime(m[1], '%m/%d/%Y')
            entries.append((date, m[2], m[3]))

entries.sort(reverse=True, key=itemgetter(0))
w = sys.stdout.write

w('<?xml version="1.0" encoding="UTF-8" ?>\n')
w('<rss version="2.0">\n')
w('<title>Justin Meiners Site</title>\n')
w('<description>Welcome to my personal site about programming, math, and philosophy!</description>\n')
w('<link>{0}</link>\n'.format(SITE))
w('<lastBuildDate>{0}</lastBuildDate>\n'.format(datetime.now().strftime(RFC_FORMAT)))

for e in entries:
    w('<item>\n')
    w('<pubDate>{0}</pubDate>\n<title>{1}</title>\n'.format(e[0].strftime(RFC_FORMAT), e[1]))

    url = e[2]
    description = None

    if not e[2].startswith('http'):
        url = SITE + e[2]
        with open(e[2] + '/README.html', 'r') as cf:
            description = cf.read()

    w('<guid isPermaLink="true">{0}</guid>\n'.format(url))

    if description:
        w('<description><![CDATA[ \n{0}\n ]]></description>\n'.format(description))

    w('</item>\n')

w('</channel></rss>')



