#!/usr/bin/perl
#
# Script for packaging the mod contents into a zip.
# Parses the output of pkgfilelist_gen.lua.
#
# simplex
#
use strict;
use warnings FATAL => qw( all );
#use warnings;
use File::Spec::Functions;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );


use constant DEBUG =>
	#0
	1
;


# Compression level to use for archiving.
use constant COMPRESSION_LEVEL =>
	#COMPRESSION_LEVEL_BEST_COMPRESSION
	COMPRESSION_LEVEL_FASTEST
;



# File name suffixes to exclude.
my @poison_suffixes = ();

sub file_filter {
	my $fname = $_[0];

	foreach my $suf (@poison_suffixes) {
		return 0 if $fname =~ /${suf}$/;
	}

	return 1;
}

sub treematch_filter {
	return file_filter($_);
}

sub get_next_line {
	my $fh = shift;

	while(<$fh>) {
		unless(/^#/ || /^\s*$/) {
			chomp;
			#print "Read line: ", $_, "\n" if DEBUG;
			return $_;
		}
	}

	undef;
}

sub parse_input {
	my $zip = shift;
	my $fh = shift;


	# Name of the mod folder to be  used inside the zip.
	my $root = get_next_line $fh;
	die "Failed to read name of mod root directory." unless $root;
	chomp $root;

	print "Got mod root: $root\n" if DEBUG;

	$zip->addDirectory($root);


	while(get_next_line $fh) {
		my $line = $_;

		# Directives.
		
		if(/^%EMPTY\s+(.+)$/) {
			print "Adding empty directory $1\n" if DEBUG;
			$zip->addDirectory($1, $root . '/' . $1);
			next;
		}
		if(/^%CD\s+(.+)$/) {
			print "Changing current directory to $1\n" if DEBUG;
			unless( chdir $1 ) {
				die $!;
			}
			next;
		}


		# Exclusion wildcards.

		if(/^!\*(.*)$/) {
			print "Got exclusion wildcard *$1\n" if DEBUG;
			push @poison_suffixes, $1;
			next;
		}


		# Files and directories.

		if( -d $line ) {
			print "Adding directory tree $line\n" if DEBUG;
			$zip->addTreeMatching({
				root => $line,
				zipName => $root . '/' . $line,
				pattern => '',
				select => \&treematch_filter,
				compressionLevel => COMPRESSION_LEVEL
			});
		}
		elsif( -f $line && file_filter($line) ) {
			print "Adding file $line\n" if DEBUG;
			$zip->addFile($line, $root . '/' . $line, COMPRESSION_LEVEL);
		}
		else {
			die "Invalid file $line";
		}
	}


	return $root;
}


my $zip = Archive::Zip->new;

print "Processing package contents... ";
print "\n" if DEBUG;
my $root = parse_input $zip, \*STDIN;
print "Done.\n";

my $archive_name;
if(defined $ARGV[0]) {
	$archive_name = $ARGV[0];
}
else {
	$archive_name = $root . ".zip";
}

print "Writing zip archive to '", $archive_name, "'... ";
unless( $zip->writeToFileNamed( $archive_name ) == AZ_OK ) {
	die "Failed to create zip archive $archive_name: $!";
}
print "Done.\n";
