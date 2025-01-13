#!/usr/bin/perl

use warnings;
use strict;
use autodie;
use DateTime; 
use feature 'say';

my $site="https://www.jmeiners.com";
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

foreach (@sorted) {
	my ($date, $title, $link) = @$_;
	my $rfc_date = $date->strftime($rfc_format);

    say $title;
    say $rfc_date;

	if (not $link =~ /^http/) {
      my $path = $link . '/date.txt';

      if (open(my $fh, '>', $path)) {
        say $fh $rfc_date;
        close $fh;
      }
	}
}

