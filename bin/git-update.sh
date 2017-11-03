#!/bin/sh -e
# http://stackoverflow.com/q/1777854/209184
PRODUCT=$(grep 'remote "origin"' -A 1 .git/config | tail -1 | cut -d'/' -f 2 | cut -d'.' -f1 )
echo Updating $PRODUCT && git remote prune origin && git pull
git submodule foreach -q --recursive 'echo Updating $name && git remote prune origin && git pull && git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo master)'
if [ -d "configurator" ]; then
  echo Updating configuration
  cd configurator && git pull && cd ..
  configurator/do.sh deploy local
fi
