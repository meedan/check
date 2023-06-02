#!/bin/bash

git submodule foreach -q '
  configs=(`find . -name 'config.*.example'`)
  changes=`git diff-index origin/develop -- $configs`

  RED="\033[0;31m"
  NC="\033[0m"

  echo —
  echo submodule: $name 
  if [[ $configs ]]; then
    for config in "${configs[@]}"; do  
      echo config file: $config
    done 
  else
    echo config file: none 
  fi

  if [[ $changes ]]; then
    echo ${RED}">>>>" $name has a changed config${NC}

    for config in "${configs[@]}"; do  
      git diff origin/develop -- $config
    done     
  fi
'
