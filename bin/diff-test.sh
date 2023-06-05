#!/bin/bash

# rm -r ./temp
mkdir ./temp

git submodule foreach -q '
  configs=(`find . -name 'config.*.example'`)

  if [[ $configs ]]; then
    for config in "${configs[@]}"; do 
      echo $name: ${config}
      mkdir ../temp/$name
      cp -r ${config} ../temp/$name
    done 
  fi
'

git submodule foreach -q --recursive '
  echo Updating $name
  git remote prune origin
  branch=$(git config -f $toplevel/.gitmodules submodule.$name.branch || echo develop)
  current=$(git rev-parse --abbrev-ref HEAD)
  if [ "$current" = "$branch" ]; then
    git pull --no-squash
  else
    git fetch origin $branch:$branch
  fi
  if [ -e $toplevel/$name/.githooks ]; then
    hooks=$(git rev-parse --git-dir)/hooks
    find $hooks -type l -exec rm \{\} \;
    find $toplevel/$name/.githooks -type f -exec ln -sf \{\} $hooks \;
  fi
'

git submodule foreach -q '
  configs=(`find . -name 'config.*.example'`)

  for config in "${configs[@]}"; do 
    changes=`diff -u ../temp/$name/${config##*/} ./${config#*/}`

    echo —————————————————
    echo $name

    if [[ $changes ]]; then
      diff -u ../temp/$name/${config##*/} ./${config#*/}
    else
      echo no changes
    fi
  done 
'

# rm -r ./temp

  # changes=`git diff-index origin/develop -- $configs`

  # RED="\033[0;31m"
  # NC="\033[0m"

  # echo —
  # echo submodule: $name 
  # if [[ $configs ]]; then
  #   for config in "${configs[@]}"; do  
  #   done 
  # else
  #   echo config file: none 
  # fi

  # if [[ $changes ]]; then
  #   echo ${RED}">>>>" $name has a changed config${NC}

  #   for config in "${configs[@]}"; do  
  #     git diff origin/develop -- $config
  #   done     
  # fi
