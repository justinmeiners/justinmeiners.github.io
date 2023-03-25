#!/usr/bin/perl

use warnings;
use strict;
use autodie;
use DateTime; 
use feature 'say';

my $site="https://www.jmeiners.com";
my @all_md = `find * -type f -name *.md`;
chomp @all_md;

my @to_cleanup = ();

foreach (@all_md) {
	say;

	open(my $file, '<', $_);
	chomp(my $title = <$file>);
	close($file);

	say $title;

	if ($title =~ /^(!|#).*/) {
		$title = "Justin Meiners";
	}

  local $ENV{TITLE} = $title;

  $ENV{MD} = $_;
  s/README.md/README.html/;
  local $ENV{BODY_HTML} = $_;
  push(@to_cleanup, $_);
  s/README.html$/index.html/;
  $ENV{HTML} = $_;

	system('markdown $MD > $BODY_HTML');
	system('cat template/prefix.html | envsubst \'$TITLE\' > $HTML');
  system('cat $BODY_HTML >> $HTML');
	system('cat template/suffix.html >> $HTML');

}

open(my $index, "<", "README.md");

my @entries = ();

while (<$index>) {
	if (/\[([0-9\/]+) - ([^\]]+)\]\(([^\)]+)/) {
		my @date_parts = split(/\//, $1);

		my $datetime = DateTime->new(  
				day        => $date_parts[1],  
				month      => $date_parts[0],  
				year       => $date_parts[2], 
				);  
		push(@entries, [$datetime, $2, $3]);
	}
}


my @sorted =
map { $_->[0] }
sort { $b->[1] cmp $a->[1] }
map { [$_, $_->[0]->strftime('%Y%m%d')] }
@entries;

my $rfc_format="%a, %d %b %Y %H:%M:%S %z";

open(my $rss_fh, '>', 'feed.xml');

select $rss_fh;


say
'<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>';

say '<title>Justin Meiners Site</title>';
say '<description>Welcome to my personal site about programming, math, and philosophy!</description>';
say "<link>$site</link>";

my $build_date = DateTime->now->strftime($rfc_format);
say "<lastBuildDate>$build_date</lastBuildDate>";

foreach (@sorted) {
	my ($date, $title, $link) = @$_;
	my $rfc_date = $date->strftime($rfc_format);

	say "<item>";
	say "<pubDate>$rfc_date</pubDate>";
	say "<title>$title</title>";

  my @description;

	if (not $link =~ /^http/) {
      my $html_body = $link . '/README.html';

      if (open(my $fh, '<', $html_body)) {
          @description = <$fh>;
      }

      $link = $site . '/' . $link;
	}
  say '<guid isPermaLink="true">' . $link . '</guid>';

  if (@description) {
      say '<description><![CDATA[';
      foreach (@description) { print };
      say ']]></description>';
  }

	say "</item>";
}

say
"</channel>
</rss>";

close $rss_fh;

select STDOUT;

foreach (@to_cleanup) {
  system("rm", $_);
}
