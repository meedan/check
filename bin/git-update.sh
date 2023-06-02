#!/bin/bash -e
echo Updating check
git remote prune origin
git pull --no-squash
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
# if [ -d configurator ]; then
#   echo Updating configuration
#   (cd configurator && git pull --no-squash)
#   configurator/do.sh deploy local
# fi
# docker-compose -f docker-compose.yml -f docker-test.yml build

echo —
echo Checking for updated config files
echo Will show diff if there are any
git submodule foreach -q '
  configs=(`find . -name 'config.*.example'`)
  changes=`git diff-index origin/develop -- $configs`

  RED="\033[0;31m"
  NC="\033[0m"

  if [[ $changes ]]; then
    echo ${RED}—
    echo $name has a changed config${NC}
    echo submodule: $name 

    for config in "${configs[@]}"; do  
      git diff origin/develop -- $config
      echo config file: $config
    done     
  fi
'