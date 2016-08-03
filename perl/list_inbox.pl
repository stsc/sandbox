#!/usr/bin/perl

# Generate mbox summary from bogofilter header classification
# and print it to stdout; usable with conky, for example.

use strict;
use warnings;

die "$0: mbox file\n" unless @ARGV;

open(my $fh, '<', $ARGV[0]) or die "Cannot open $ARGV[0] for reading: $!\n";
my $mbox = do { local $/; <$fh> };
close($fh);

my @blocks = $mbox =~ /^(From .+?)\n{2,}/gms;

my @headers;
foreach my $block (@blocks) {
    my %header;
    while ($block =~ /^(\S+):\s*(.*)$/gm) {
        $header{$1} = $2;
    }
    push @headers, { %header };
}

@headers = grep { not defined $_->{'From'} && $_->{'From'} =~ /MAILER-DAEMON/ } @headers;

my @ham     = grep {  defined $_->{'X-Bogosity'} && $_->{'X-Bogosity'} =~ /^Ham,/                 } @headers;
my @unsure  = grep {  defined $_->{'X-Bogosity'} && $_->{'X-Bogosity'} =~ /^Unsure,/              } @headers;
my @spam    = grep {  defined $_->{'X-Bogosity'} && $_->{'X-Bogosity'} =~ /^Spam,/                } @headers;
my @unknown = grep { !defined $_->{'X-Bogosity'} || $_->{'X-Bogosity'} !~ /^(?:Ham|Unsure|Spam),/ } @headers;

print "Ham:     ${\sprintf '%3d', scalar @ham} messages\n"     if @ham;
print "Unsure:  ${\sprintf '%3d', scalar @unsure} messages\n"  if @unsure;
print "Spam:    ${\sprintf '%3d', scalar @spam} messages\n"    if @spam;
print "Unknown: ${\sprintf '%3d', scalar @unknown} messages\n" if @unknown;
