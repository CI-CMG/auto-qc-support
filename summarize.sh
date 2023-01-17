#! /bin/bash

set -ex

if [[ -z "${AUTO_QC_HOME}" ]]
then
  echo "Error - AUTO_QC_HOME not set"
  exit 2
fi

wd=$(pwd)

table=$1

cd "$AUTO_QC_HOME/AutoQC"

python summarize-results.py -d $table

cd "$wd"
