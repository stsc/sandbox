#!/bin/sh

if [ $# -lt 2 ]; then
    echo 1>&2 Usage: $0 file dirs...
    exit 1
fi
file=$1
shift
while [ $# -ge 1 ];
do
    cp $file $1
    shift
done
