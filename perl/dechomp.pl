#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

sub dechomp (\[$@])
{
    if (ref $_[0] eq 'SCALAR') {
        ${$_[0]} = "${$_[0]}$/";
    }
    elsif (ref $_[0] eq 'ARRAY') {
        $_ = "${_}$/" for @{$_[0]};
    }
}

my $s = 'abc';
dechomp $s;
my @a = qw(d e f);
dechomp @a;

print Dumper [ $s, @a ];
