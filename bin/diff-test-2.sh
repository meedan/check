#!/bin/bash

CONFIGS=($(find . -name '*.example' -not -path '*/temp_config_files_2/*'))
RED="\033[0;31m"
NC="\033[0m"

dest () {
  echo "./temp_config_files_2/${1%/*}" 
}

for CONFIG in "${CONFIGS[@]}"; do
  mkdir -p "$(dest $CONFIG)"
  cp -r "${CONFIG}" "$(dest  $CONFIG)"


  changes=$(diff -u "$(dest $CONFIG)/${CONFIG##*/}" "${CONFIG}")

  if [[ "$changes" ]]; then
    has_changes="true"
    echo —
    echo -e "$RED ${CONFIG} has changes."
    echo -e "Consider updating your config file. $NC"
    echo "${changes}"
  fi  
done

if [ "$has_changes" != "true" ]; then
  echo Config files have no changes.
fi

rm -r ./temp_config_files_2
