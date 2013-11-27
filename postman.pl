#!/bin/perl

my $mode = $ARGV[0];
die if $mode ne "discussion" and $mode ne "upload";

my $thread = $ENV{'PROJECT_FORUM_THREAD'};
my $downid = $ENV{'PROJECT_FORUM_DOWNLOAD_ID'};
die if not $thread or not $downid;


my @listrepl;
my $itemrepl;
my $prologue;

if($mode eq "discussion") {
	@listrepl = ("[LIST]\n", "[/LIST]\n");
	$itemrepl = "[*] ";
	$prologue = '[URL="http://forums.kleientertainment.com/downloads.php?do=download&downloadid=' . $downid . '"][IMG]http://forums.kleientertainment.com/images/download.png[/IMG][/URL]';
} elsif($mode eq "upload") {
	@listrepl = ("", "");
	$itemrepl = "> ";
	$prologue = '[URL="http://forums.kleientertainment.com/showthread.php?' . $thread . '"][B]Discuss >>[/B][/URL]'
}

sub print_sample_configuration {
	open EG, "<", "rc.example.lua" or die $!;

	print "Sample configuration file:\n";
	print "[SPOILER]\n";
	print "[CODE]\n";
	while(<EG>){ print; }
	print "[/CODE]\n";
	print "[/SPOILER]\n";

	close EG;
}

while(<STDIN>) {
	if (/^\@SAMPLECONFIGURATION\@\s*$/) {
		print_sample_configuration if $mode eq "discussion";
		$_ = "";
		next;
	}

	s/^\s*\[LIST\]\s*/$listrepl[0]/i;
	s/^\s*\[\/LIST\]\s*/$listrepl[1]/i;
	s/^\s*\[\*\]\s*/$itemrepl/i;
} continue {
	print;
}

print "\n", $prologue, "\n";
