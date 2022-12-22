#! /bin/bash

set -ex

if [[ -z "${AUTO_QC_HOME}" ]]
then
  echo "Error - AUTO_QC_HOME not set"
  exit 2
fi

export PYTHONPATH="$AUTO_QC_HOME/AutoQC"

wd=$(pwd)

dir=$1
table=$2


cd "$AUTO_QC_HOME/AutoQC"

set +e
python3 "$wd/check-failures.py" -d $table -o "$dir"
retVal=$?
cd "$wd"
exit $retVal
