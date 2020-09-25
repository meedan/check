#!/bin/bash

# ./bin/release.sh <version>
#   Update all submodules to <version>
#   Create a commit and a tag

# The user needs to push to repository

usage() {
  echo -e "Usage:\n  $0 <version>\n"
  echo -e "This script releases a new version for Check:"
  echo "  Update all submodules to tag <version>"
  echo "  Create a commit with the updated submodules"
  echo "  Create a tag <version>"
  echo "  Ask the user to push the commit and tag"
}

release() {
  echo -e "\n============= Releasing version: $version ===============\n"

  git submodule foreach -q "
    echo Checking version $version for submodule \$name.;
    if git rev-parse "$version" >/dev/null 2>&1; then
      echo \$name will be updated.
      git checkout -q $version
    else
      echo \$name will not be updated. Tag \$version does not exist.
    fi
    echo
  "

  git add -u
  git commit -m "Updated submodules to $version"
  git tag $version
  git show

  echo -e "\n***** Release $version is ready *****\n"
  echo "I: please verify the commit and push the code and tag to remote"
  echo "I: $ git push origin master"
  echo "I: $ git push origin $version"
}

version="$1"
if [ -z "$version" ] || [ $# -gt 1 ]; then
  echo -e "\e[41mError:\e[0m wrong number of arguments (given $#, expected 1)\n"
  usage
  exit 1
fi

release
