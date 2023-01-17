#! /bin/bash

set -ex

if [[ -z "${AUTO_QC_HOME}" ]]
then
  echo "Error - AUTO_QC_HOME not set"
  exit 2
fi

wd=$(pwd)

ascii_dir=$1
report_dir=$2

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
  if [[ -f $path ]]; then
    filename=$(basename "$path")
    src_type_dir=$(dirname "$path")
    src_dataset_dir=$(dirname "$src_type_dir")
    t=$(basename "$src_type_dir")
    dataset=$(basename "$src_dataset_dir")
    outdir="$report_dir/$dataset/$t"
    echo "QC: path=$path filename=$filename outdir=$outdir"
    ./setup-table.sh "$path" "$filename"
    count=$(sqlite3 "$AUTO_QC_HOME/AutoQC/iquod.db" "select count(*) from $filename;")
    if [ $count -ne 0 ]; then
      ./qc-one.sh "$filename" 4
      set +e
      ./check-failures.sh "$outdir" "$filename"
      retVal=$?
      set -e
      if [ $retVal -eq 42 ]; then
        ./summarize.sh "$filename" > "$outdir/$filename-summary.txt"
      fi
      rm "$AUTO_QC_HOME/AutoQC/iquod.db"
      if [ $retVal -ne 0 ]; then
        exit $retVal
      fi
    fi
  fi
done

cd "$wd"
