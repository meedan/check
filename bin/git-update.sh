#!/bin/bash -e
configs=($(find . -name '*.example' -not -path '*/temp/*'))
dest="./temp"

red="\033[0;31m"
nc="\033[0m"

for config in "${configs[@]}"; do
  mkdir -p "${dest}/${config}"
  cp -r "$config"  "${dest}/${config}"
done

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
set +e
for config in "${configs[@]}"; do
  changes=$(diff -u "${dest}/${config}" "$config")

  if [[ "$changes" ]]; then
    has_changes="true"
    echo —
    echo -e "$red $config has changes."
    echo -e "Consider updating your config file. $nc"
    echo "$changes"
  fi  
done
set -e

if [ "$has_changes" != "true" ]; then
  echo Config files have no changes.
fi

rm -r ./temp
