#!/bin/bash

git submodule foreach -q '
  configs=`find . -name 'config.*.example'`
  changes=`git diff-index origin/develop -- $configs`

  RED="\033[0;31m"
  NC="\033[0m"

  echo —
  echo submodule: $name 
  if [[ $configs ]]; then
    echo config files: $configs 
  else
    echo config files: none 
  fi

  if [[ $changes ]]; then
    echo ${RED}">>>>" $name has a changed config${NC}
    git diff origin/develop -- $configs
  fi
'
