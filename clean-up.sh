#! /bin/bash

set -e
#set -x

ascii_dir=$1

for path in $(find "$ascii_dir"); do
  if [[ -f $path ]]; then
    filename=$(basename "$path")
    if [[ "${filename}" =~ ".+-failures-.+.json" ]]; then
      src_type_dir=$(dirname "$path")
      src_dataset_dir=$(dirname "$src_type_dir")
      t=$(basename "$src_type_dir")
      if [ "$t" == "OBS" ]; then
        echo "rm $path"
#        rm "$path"
      fi
    fi
  fi
done
