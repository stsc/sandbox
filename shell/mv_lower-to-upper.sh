#!/bin/sh

if [ $# != 1 ]; then
    echo 1>&2 Usage: $0 directory
    exit 1
fi

directory=$(readlink -f "$1")

if [ -d "$directory" ]; then
    cd "$directory" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo 1>&2 Cannot change to $directory, exiting
        exit 1
    fi
else
    echo 1>&2 $directory is not a directory, exiting
    exit 1
fi

while true; do
    read -p "Uppercase files in $directory - LAST CHANCE [y/n] " yn
    case $yn in
        y|Y) break;;
        n|N) echo 1>&2 Exiting; exit 1;;
          *) echo 1>&2 Please answer yes or no.;;
    esac
done

if [ "$(pwd)" != "$directory" ]; then
    echo 1>&2 Could not change to $directory, exiting
    exit 1
fi

for orig in *
do
    if [ -f "$orig" ]; then
        new=`echo $orig | tr "a-z" "A-Z"`
        mv -v $orig $new 2>&1
    else
        echo Skipping $orig, not a file
    fi
done
