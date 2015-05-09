#!/bin/sh

set -eu
: $1

ext=${1##*.}
[ $ext != "rar" -a $ext != "RAR" ] && exit 1

zip_name=`basename $1 '.rar'`.zip
[ -e $zip_name ] && exit 1

tmp_dir=$(mktemp -d XXXXXX)
unrar x -inul $1 $tmp_dir
[ $? -eq 1 ] && exit 1

cd $tmp_dir
zip -r ../$zip_name *
cd ..
trap "rm -rf $tmp_dir" 0
