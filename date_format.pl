#!/usr/bin/perl

use warnings;
use strict;
use autodie;
use DateTime; 
use feature 'say';

my $stdin = join("", <STDIN>);

my @date_parts = split(/\//, $stdin);

say @date_parts;

my $datetime = DateTime->new(  
        day        => $date_parts[1],  
        month      => $date_parts[0],  
        year       => $date_parts[2], 
        );  
my $date = $datetime->strftime('%Y%m%d');
my $rfc_format = "%a, %d %b %Y %H:%M:%S %z";
my $rfc_date = $date->strftime($rfc_format);

say $rfc_date;

