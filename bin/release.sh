#!/bin/bash

# ./bin/release.sh <version>
#   Update all submodules to <version>
#   Create a commit and a tag

# The user needs to push to repository

version=$1
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
