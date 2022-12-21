#! /bin/bash

set -ex

if [[ -z "${AUTO_QC_HOME}" ]]
then
  echo "Error - AUTO_QC_HOME not set"
  exit 2
fi

wd=$(pwd)

ascii_dir=$1

function set_svc_home {
  local SOURCE="${BASH_SOURCE[0]}"
  while [[ -h "$SOURCE" ]]; do # resolve $SOURCE until the file is no longer a symlink
    SVC_HOME="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  SVC_HOME="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
}

set_svc_home

cd "$SVC_HOME"


for path in $(find "$ascii_dir"); do
    filename=$(basename "$path")
    ./setup-table.sh "$path" "$filename"
    ./qc-one.sh "$filename" 4
done

cd "$wd"
