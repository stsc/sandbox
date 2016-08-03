#!/usr/bin/perl
# Small non-real progress bar

use strict;
use warnings;

$| = 1;

foreach my $percent (0 .. 100) {
    printf "%3d %%", $percent;
    sleep 1;
    print "\r";
}
