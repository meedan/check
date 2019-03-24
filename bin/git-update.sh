#!/bin/sh -e
# http://stackoverflow.com/q/1777854/209184
APP=$(grep 'remote "origin"' -A 1 .git/config | tail -1 | cut -d'/' -f 2 | cut -d'.' -f1 )
echo Updating $APP && git remote prune origin && git pull --no-squash
git submodule foreach -q --recursive 'echo Updating $name; git remote prune origin; branch=$(git config -f $toplevel/.gitmodules submodule.$name.branch || echo develop); current=$(git rev-parse --abbrev-ref HEAD); if [ "$current" = "$branch" ]; then git pull --no-squash; else git fetch origin $branch:$branch; fi'
if [ -d "configurator" ]; then
  echo Updating configuration
  cd configurator && git pull --no-squash && cd ..
  configurator/do.sh deploy local
fi
