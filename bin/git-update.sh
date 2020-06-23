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
if [ -d configurator ]; then
  echo Updating configuration
  (cd configurator && git pull --no-squash)
  configurator/do.sh deploy local
fi
docker-compose build
