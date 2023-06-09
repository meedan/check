#!/bin/bash -e
CONFIGS=($(find . -name '*.example' -not -path '*/temp_config_files_2/*'))
RED="\033[0;31m"
NC="\033[0m"

dest () {
  echo "./temp_config_files_2/${1%/*}" 
}

for CONFIG in "${CONFIGS[@]}"; do
  mkdir -p "$(dest $CONFIG)"
  cp -r "$CONFIG" "$(dest  $CONFIG)"
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

if [ -d configurator ]; then
  echo Updating configuration
  (cd configurator && git pull --no-squash)
  configurator/do.sh deploy local
fi
docker-compose -f docker-compose.yml -f docker-test.yml build

echo —
echo Checking for updated config files
set +e
for CONFIG in "${CONFIGS[@]}"; do
  changes=$(diff -u "$(dest $CONFIG)/${CONFIG##*/}" "$CONFIG")

  if [[ "$changes" ]]; then
    has_changes="true"
    echo —
    echo -e "$RED $CONFIG has changes."
    echo -e "Consider updating your config file. $NC"
    echo "$changes"
  fi  
done

if [ "$has_changes" != "true" ]; then
  echo Config files have no changes.
fi

rm -r ./temp_config_files_2
