#!/bin/perl

use POSIX qw(strftime);

my $name = $ENV{'PROJECT_NAME'};
my $version = $ENV{'PROJECT_VERSION'};
my $date = strftime '%F', localtime;

die "Define PROJECT_NAME and PROJECT_VERSION." if not $name or not $version;

while(<>) {
	last if not /^--/;
	
	s/^--\[\[(\s*)[^\s\]]+(\s*)\]\](\s*)VERSION="[^"]*"\s*$/--[[\1$name\2]]\3VERSION="$version"\n/;
	s/Last updated: \d{4,4}-\d{2,2}-\d{2,2}/Last updated: $date/;
} continue {
	print;
}

print;

while(<>) { print; }
