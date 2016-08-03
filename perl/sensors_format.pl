#!/usr/bin/perl

# Reformat output of sensors[1] and print it to stdout;
# usable with conky, for example.
#
# 1: `sensors`

use strict;
use warnings;

local $\ = "\n";

while (<>) {
    if (/^(Core \d:\s+.+?)(?=\s|$)/) {
        my $line = do {
            local $_ = $1;
            s/(?<=:)\s+/ /;
            s/°//g;
            $_
        };
        print $line;
    }
}
