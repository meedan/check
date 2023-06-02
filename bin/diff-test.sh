#!/bin/bash

git submodule foreach -q '
  configs=`find . -name 'config.*.example'`

  local=$(git rev-parse --abbrev-ref HEAD)

  echo —
  echo submodule: $name
  echo config files: $configs
  echo current branch: $local

  if [[ $configs ]]; then
    git diff origin/develop -- $configs
  fi
'

# branch=$(git config -f $toplevel/.gitmodules submodule.$name.branch || echo develop)
# current=$(git rev-parse --abbrev-ref HEAD)

# configs foreach git diff origin/$local -- $configs
# git diff origin/$branch -- $configs

# git diff origin/develop -- $configs
