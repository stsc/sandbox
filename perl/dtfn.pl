#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils qw(all);

print "Input: ";
chomp(my $input = <STDIN>);
my @tokens = split /\s+/, $input;

my $re1 = qr/\d+/;
my $re2 = qr/[au]m/i;
my $re3 = qr/Morgen/;

my @grammar = ($re1, $re2, $re3);
my @order = ([[0,0],[1,1],[2,2]],[[0,2],[1,1],[2,0]]);
my @dispatch = ([\&sub1, \&sub2, \&sub3],[\&sub3, \&sub2, \&sub1]);

my $dispatched;

foreach my $i (0..$#order) {
    if (all { $tokens[$_->[0]] =~ $grammar[$_->[1]] } @{$order[$i]}) {
        foreach (0..$#{$dispatch[$i]}) {
            $dispatch[$i]->[$_]->($tokens[$_]);
        }
        $dispatched++;
    }
}

unless ($dispatched) { none() }

sub sub1 { print "1: @_\n" }
sub sub2 { print "2: @_\n" }
sub sub3 { print "3: @_\n" }
sub none { print "none!\n" }
