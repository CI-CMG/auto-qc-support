#! /bin/bash

set -ex

if [[ -z "${AUTO_QC_HOME}" ]]
then
  echo "Error - AUTO_QC_HOME not set"
  exit 2
fi

wd=$(pwd)

file="$1"
table=$2

cd "$AUTO_QC_HOME/AutoQC"

python build-db.py -i "$file" -d $table

cd "$wd"
