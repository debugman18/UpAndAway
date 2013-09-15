#!/bin/perl

my $BACKUP = 0;

my $BACKUP_SUFFIX = ".orig";

use File::Temp qw( :POSIX );
use File::Copy qw/ cp mv /;

my $essential_bootup_code = <<EOS
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
EOS
;

my $wicker_bootup_code = $essential_bootup_code . <<EOS
module( ..., require(_modname .. '.wicker.booter') )
EOS
;

my $mod_bootup_code = $essential_bootup_code . <<EOS
module( ..., require(_modname .. '.booter') )
EOS
;

my $mod_global_bootup_code = $essential_bootup_code . <<EOS
module( ..., package.seeall, require(_modname .. '.booter') )
EOS
;

my $block_size = 8*1024;

$ARGV[0] or die $!;

my $scriptname = $ARGV[0];

my $default_mode = $ARGV[1] or "mod";

open SCRIPT, "<", $scriptname or die $!;

my $insertpos = 0;

my $started = 0;
my $disabled = 0;
my $start_pos = 0;
my $end_pos = 0;
my $just_ended = 0;
my $is_global = 0;
my $is_wicker = 0;

while(<SCRIPT>) {
	if( $started and /^\s*--\@\@END (\S+ )?ENVIRONMENT BOOTUP\s*$/ ) {
		#print "end match\n";
		$end_pos = tell(SCRIPT) - length($_);
		last;
	} elsif( not $started and /^\s*--\@\@ENVIRONMENT BOOTUP\s*$/ ) {
		#print "start match\n";
		$started = 1;
		$start_pos = tell(SCRIPT);
	} elsif( not $started and /^\s*--\@\@GLOBAL ENVIRONMENT BOOTUP\s*$/ ) {
		#print "start global match\n";
		$started = 1;
		$start_pos = tell(SCRIPT);
		$is_global = 1;
	} elsif( not $started and /^\s*--\@\@WICKER ENVIRONMENT BOOTUP\s*$/ ) {
		#print "start wicker match\n";
		$started = 1;
		$start_pos = tell(SCRIPT);
		$is_wicker = 1;
	} elsif( not $started and /^\s*--\@\@NO ENVIRONMENT BOOTUP\s*$/ ) {
		#print "disable match\n";
		$disabled = 1;
		$start_pos = tell(SCRIPT);
		<SCRIPT>; # We skip the next line.
		$end_pos = tell(SCRIPT);
		last;
	}
}

if( $end_pos < $start_pos) { die "End position is less than start position."; }

# Closed on the left, open on the right.
sub dump_byte_range {
	my ($HANDLE, $a, $b) = @_;

	seek( SCRIPT, $a, SEEK_SET );

	my $total = 0;
	while( $b < 0 or $total < ($b - $a) ) {
		my $sz = $block_size;
		if( $b >= 0 and $sz > ($b - $a) - $total ) {
			$sz = ($b - $a) - $total;
		}
		my $str;
		my $n = read( SCRIPT, $str, $sz );

		if( $n >= 0 ) {
			print $HANDLE $str;
			$total += $n;
		}
		
		last if $n < $sz;
	}
}

my $temp = File::Temp->new(UNLINK => 0);
my $tempname = $temp->filename;

dump_byte_range($temp, 0, $start_pos);
if( $disabled ) {
	print $temp $essential_bootup_code;
} else {
	if( $started ) {
		if( $is_global ) {
			print $temp $mod_global_bootup_code;
		} elsif( $is_wicker ) {
			print $temp $wicker_bootup_code;
		}else {
			print $temp $mod_bootup_code;
		}
	} else {
		if( $default eq "mod" ) {
			print $temp "--\@\@ENVIRONMENT BOOTUP\n";
			print $temp $mod_bootup_code;
			print $temp "--\@\@END ENVIRONMENT BOOTUP\n\n";
		}
		elsif( $default eq "global" ) {
			print $temp "--\@\@GLOBAL ENVIRONMENT BOOTUP\n";
			print $temp $mod_global_bootup_code;
			print $temp "--\@\@END ENVIRONMENT BOOTUP\n\n";
		}
		elsif( $default eq "wicker" ) {
			print $temp "--\@\@WICKER ENVIRONMENT BOOTUP\n";
			print $temp $wicker_bootup_code;
			print $temp "--\@\@END ENVIRONMENT BOOTUP\n\n";
		}
		else {
			die "Invalid default mode $default.";
		}
	}
}
dump_byte_range($temp, $end_pos, -1);

close $temp;

if( $BACKUP ) {
	cp($scriptname, ($scriptname . $BACKUP_SUFFIX));
}

mv($tempname, $scriptname);

close $temp;
