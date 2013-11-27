#!/usr/bin/perl

my $RC_PRE = <<EOS
------
---- [Configurations]
----
---- Modify at will.
---- Remove the "--" in front of the options you wish to change.
----
---- Any line in this file can be safely deleted.
---- Feel free to clean it up by erasing option lines you don't intend on changing.
------


EOS
;

$RC_PRE;
$RC_PRE_DOS =~ s/^\n$/\r\n/mg;
$RC_PRE_DOS =~ s/([^\r])\n$/\1\r\n/mg;
my $RC_PRE_DOS = $_;

my $RC_DEFAULTS_PRE = <<EOS
------
---- [Default configurations]
----
---- Modify rc.lua instead.
------


EOS
;

$RC_DEFAULTS_PRE;
s/^\n$/\r\n/mg;
s/([^\r])\n$/\1\r\n/mg;
my $RC_DEFAULTS_PRE_DOS = $_;

sub rc_feeder {
	$@[0];

	return "" if /^--\@/;

	return "\r\n" if /^\s*$/;

	s/^--/---/;
	s/^([^-])/--\1/;
	s/([^\r])\n$/\1\r\n/;
	s/^\n$/\r\n/;

	return $_;
}

sub rc_defaults_feeder {
	$@[0];

	return "" if /^--\@/;

	return "\n" if /^\s*$/;

	return $_;
}

my $example_skipline = 0;
my $example_is_reading = 1;
sub rc_example_feeder {
	if ($example_skipline > 0) {
		$example_skipline -= 1;
		return "";
	}

	$@[0];

	my $is_example = 0;

	if (/^--\@stopreading\s/) {
		$example_is_reading = 0;
		return "";
	}

	if (/^--\@startreading\s/) {
		$example_is_reading = 1;
		return "";
	}

	if (not $example_is_reading) {
		return "";
	}

	if (/^\s*$/) {
		return "\n";
	}

	if (/^--\@skip\s/) {
		$example_skipline = 1;
		return "";
	}
	
	if (/^--\@example\s+(.+\s*)$/) {
		$example_skipline = 1;
		$is_example = 1;

		$_ = $1;
	}

	s/^--/---/;
	
	if (not $is_example) {
		s/^([^-])/--\1/;
	}

	return $_;
}

if ($ARGV[0] eq "rc") {
	print ( $RC_PRE_DOS );
	while(<STDIN>) {
		print( rc_feeder($_) );
	}
} elsif ($ARGV[0] eq "rc.defaults") {
	print $RC_DEFAULTS_PRE;
	print "return function()\n";
	while(<STDIN>) {
		print( "\t", rc_defaults_feeder($_) );
	}
	print "end\n";
} elsif ($ARGV[0] eq "rc.example") {
	print $RC_PRE;
	while(<STDIN>) {
		print( rc_example_feeder($_) );
	}
} else {
	die;
}
