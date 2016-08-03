#!/usr/bin/perl
# Choose a random wallpaper from a directory

use strict;
use warnings;

my $home          = (getpwuid $>)[7];
my $symlink       = "$home/wallpaper.jpg";
my $wallpaper_dir = "$home/wallpapers";

my @wallpapers = glob("$wallpaper_dir/hs-*.jpg") or die "No wallpapers found in $wallpaper_dir";
my $wallpaper  = $wallpapers[int rand scalar @wallpapers];

unlink $symlink;
symlink $wallpaper, $symlink or die "Cannot create symlink $symlink";

exit 0;
