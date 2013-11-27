#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use Cwd qw( abs_path );
use FileHandle;
use File::Temp qw( :POSIX );
use File::Copy qw( cp mv );
use File::stat;

my $newname = "";
my $in_place = 0;

GetOptions(
	'name|n=s' => \$newname,
	'in-place|i' => \$in_place,
	'help|h' => sub{ pod2usage(-verbose => 1) },
	'man' => sub{ pod2usage(-verbose => 2) }
) or pod2usage(-verbose => 0);

pod2usage(-verbose => 0) if not @ARGV;



my $endianness = "V";


sub write_file_to {
	my ($out, $in) = @_;

	my $blksize = stat($out)->blksize;
	$blksize = 2**12 if !$blksize;

	my $buffer;
	while(1) {
		my $n = read $in, $buffer, $blksize;
		last if $n <= 0;
		syswrite $out, $buffer, $n;
	}
}

# Returns the proper header followed by the build name.
sub read_build_header {
	my $in = shift;
	my ($header, $buildname);

	read $in, $_, 4;
	die "The input file is not a build." if $_ ne "BILD";

	my ($rawversion, $version);
	read $in, $rawversion, 4;
	$version = unpack "V", $rawversion;
	if($version & 0xffff0000) {
		$endianness = "v";
	}

	my $rest;
	read $in, $rest, 8;

	$header = "BILD" . $rawversion . $rest;

	read $in, $_, 4;
	$_ = unpack $endianness, $_;
	read $in, $buildname, $_;

	return ($header, $buildname);
}

sub write_build_header {
	my ($out, $header, $buildname) = @_;

	syswrite $out, $header;
	$_ = pack $endianness, length($buildname);
	syswrite $out, $_;
	syswrite $out, $buildname;
}


my $infh = FileHandle->new($ARGV[0], "r") or die "Can't open $ARGV[0] for reading: $!";
binmode $infh;


my ($header, $oldname) = read_build_header $infh;

if(!$newname) {
	print $oldname, "\n";
	exit 0;
}


my $outname;
if($in_place) {
	$outname = $ARGV[0];
}
elsif($ARGV[1]) {
	$outname = (-d $ARGV[1] ? $ARGV[1] . "/build.bin" : $ARGV[1]);
}
else {
	$outname = "build.bin"; 
}

my $outfh;
my $out_is_temp = 0;
if(abs_path($outname) eq abs_path($ARGV[0])) {
	$outfh = File::Temp->new(UNLINK => 0);
	$out_is_temp = 1;
}
else {
	$outfh = FileHandle->new($outname, "w") or die "Can't open $outname for writing: $!";
}
binmode $outfh;


print STDERR "Renaming $oldname => $newname\n";


write_build_header $outfh, $header, $newname;
write_file_to $outfh, $infh;


close $outfh;

if($out_is_temp) {
	mv($outfh->filename, $outname);
}


__END__


=head1 NAME

kbr - Klei Build Renamer

=head1 SYNOPSIS

kbr.pl [OPTION]... <input-file> [output-file]

Try 'kbr.pl --help' for more information.

=head1 OPTIONS

=over 8

=item B<-n>, B<--name> new-name

Sets the new name for the build.

=item B<-i>, B<--in-place>

Overwrites the input-file in place, discarding the output-file argument.

=item B<-h>, B<--help>

Prints a usage help message.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

If a new name is not given through --name or -n, prints the build name of input-file. Otherwise, writes the renamed build to output-file. If output-file is not given, "build.bin" is used. If output-file is a directory, "build.bin" prefixed by this directory path is used.

=cut
