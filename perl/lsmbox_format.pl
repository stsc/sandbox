#!/usr/bin/perl

# Reformat output of lsmbox[1] and print it to stdout;
# usable with conky, for example.
#
# 1: `lsmbox --new-only --no-old --no-summary --no-total --padding`

use strict;
use warnings;

my $strip_path = '/home/sts/mail/';

my (@lines, $width);

$width = 0;

while (<>) {
    next unless $. > 1; # skip header
    chomp;
    my ($mailbox, $count) = split /\s+/;
    $mailbox =~ s/^$strip_path//;
    my $len = length $mailbox;
    $width = $len if $len > $width;
    push @lines, [ $mailbox, $count ];
}

$width += 4;

foreach my $line (@lines) {
    printf("%-${width}s%3d\n", @$line);
}
