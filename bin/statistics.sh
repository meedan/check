#!/bin/bash

YEAR=$1

stats() {
  cd $1
  commits=`git log --since "$YEAR-01-01 00:00:00" --until "$YEAR-12-31 23:59:59" --pretty='format:%cd' --date=format:'%Y' | uniq -c | awk 'BEGIN { ORS="" }; {print $1}'`
  echo -n "${commits:-0},"
  other=`git log --shortstat --since "$YEAR-01-01 00:00:00" --until "$YEAR-12-31 23:59:59" | grep "files changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print files,inserted,deleted}'`
  changed=$(echo $other | cut -d ' ' -f 1)
  added=$(echo $other | cut -d ' ' -f 2)
  deleted=$(echo $other | cut -d ' ' -f 3)
  echo -n "${changed:-0},"
  echo -n "${added:-0},"
  echo "${deleted:-0}"
}

echo 'Code Base,Commits,Files Changed,Lines Added,Lines Deleted'
echo -n 'check,'
stats .
for name in $(git submodule--helper list | cut -d$'\t' -f 2)
do
  echo -n "$name,"
  stats $name
  cd ..
done
