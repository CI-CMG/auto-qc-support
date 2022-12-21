#! /bin/bash

set -ex

if [[ -z "${AUTO_QC_HOME}" ]]
then
  echo "Error - AUTO_QC_HOME not set"
  exit 2
fi

wd=$(pwd)

table=$1
cores=$2

cd "$AUTO_QC_HOME/AutoQC"

python3 AutoQC.py -l "$AUTO_QC_HOME/AutoQClogs" -d $table -n $cores

cd "$wd"
