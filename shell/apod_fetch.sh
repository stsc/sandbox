#!/bin/sh
# Fetch and resize the Astronomy picture of the Day from NASA

url="http://apod.nasa.gov/apod"
date=$(date '+%y%m%d')
link="ap$date.html"
html="apod.html"
out="apod.png"

_exit_with()
{
    echo $0 exiting: $1
    exit 1
}

cd /tmp

wget -O $html "$url/$link"
test -e "$html" || _exit_with "html file could not be retrieved"
path=`perl -e 'local $/; $_=<>; print /img\s+src=\"(.*?)\"/i' $html`
test "$path" != "" || _exit_with "empty path to picture"
rm $html
wget "$url/$path"
picture=`basename $path`
test "$picture" != "" || _exit_with "empty picture basename"
test -e "$picture" || _exit_with "picture could not be retrieved"
convert $picture -flatten -resize 40% ~/$out
rm $picture

exit 0
