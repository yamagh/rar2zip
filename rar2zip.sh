#!/bin/sh

help(){
  echo Usage: foo.rar
}

set -eu
: $1

IFS="
"

lowpath=`echo $1 | tr '[:upper:]' '[:lower:]'`
if [ ${lowpath##*.} != "rar" ]; then
  help
  exit 1
fi

zip_name=`basename $lowpath '.rar'`.zip
if [ -e $zip_name ]; then
  echo "Already exists $zip_name"
  exit 1
fi

cd `dirname "$1"`
tmp_dir=$(mktemp -d rar2zip.XXXXXX)
trap "rm -rf $tmp_dir" 0
unrar x -inul `basename "$1"` $tmp_dir
if [ $? -ne 0 ]; then
  echo Invalid rar file
  exit 1
fi

cd $tmp_dir
zip -rq ../$zip_name *
cd ..
