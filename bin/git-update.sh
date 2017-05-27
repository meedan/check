#!/bin/sh -e
# http://stackoverflow.com/q/1777854/209184
git pull && git submodule foreach -q --recursive 'echo Updating $name && git remote prune origin && git pull && git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo master)'
