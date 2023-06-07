#!/bin/bash

# rm -r ./temp_config_files

# git submodule foreach -q --recursive '
#   configs=(`find . -name 'config.*.example'`)

#   if [[ $configs ]]; then
#     for config in "${configs[@]}"; do 
#       mkdir -p ../temp_config_files/$name/${config%/*}
#       cp -r ${config} ../temp_config_files/$name/${config%/*}
#     done 
#   fi

#   echo Updating $name
#   git remote prune origin
#   branch=$(git config -f $toplevel/.gitmodules submodule.$name.branch || echo develop)
#   current=$(git rev-parse --abbrev-ref HEAD)
#   if [ "$current" = "$branch" ]; then
#     git pull --no-squash
#   else
#     git fetch origin $branch:$branch
#   fi
#   if [ -e $toplevel/$name/.githooks ]; then
#     hooks=$(git rev-parse --git-dir)/hooks
#     find $hooks -type l -exec rm \{\} \;
#     find $toplevel/$name/.githooks -type f -exec ln -sf \{\} $hooks \;
#   fi
# '

git submodule foreach -q --recursive '
  configs=($(find . -name 'config.*.example'))

  RED="\033[0;31m"
  NC="\033[0m"

  for config in "${configs[@]}"; do
    changes=$(diff -u ../temp_config_files/$name/${config%/*}/${config##*/} ./${config#*/})

    printf '—%.0s' {1..50} 
    printf "\n"
    
    if [[ "$changes" ]]; then
      echo ${RED}"$name": has changes, consider updating your config file 
      echo "${config}"${NC}
      echo "${changes}"
    else
      echo "$name": no changes
    fi

  done
'

# diff /Users/manu/work/check/temp_config_files/pender/config/config.yml.example /Users/manu/work/check/pender/config/config.yml.example
# diff ./temp_config_files/check-bots/./published-reports/config.js.example ./check-bots/published-reports/config.js.example
# rm -r ./temp_config_files
