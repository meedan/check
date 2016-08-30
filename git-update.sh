#!/bin/sh -e
# http://stackoverflow.com/q/1777854/209184
git submodule foreach -q --recursive 'git pull && git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo master)'
