#!/bin/bash

[ -z "$1" ] && echo "$0: Please supply a base config folder" >& 2 && exit 1
[ ! -d "$1" ] && echo "$0: $1 is not a valid config folder" >& 2 && exit 1

BASEDIR=$(pwd)
APPNAME=$(basename $BASEDIR)
CONFDIR=$1/$APPNAME

# https://stackoverflow.com/a/17577143/209184
function abspath() {
  (
  cd $(dirname $1)
  echo $PWD/$(basename $1)
  )
}

# update configs repo
cd $1 && echo "Updating configs..." && git pull && cd $BASEDIR

# find all the example config files
for F in $(find . -name '*.example'); do
  SRCF=$(echo $F | sed 's/\.example//' | sed 's|^./||')
  SRCD=$(dirname $SRCF | sed 's/$BASEDIR//' )
  DSTD=$CONFDIR/$SRCD
  DSTF=$(abspath $CONFDIR/$SRCF)

  # replicate the folder path in the configs
  mkdir -p $DSTD

  # setup symbolic links in the source tree pointing to the
  # actual files in the config tree.
  # - if the files already exist in the config tree, link them
  #   here. remove files that exist in the source tree.
  # - if the files don't exist in the config tree (first-time setup),
  #   move them from source tree to config and then symlink them back.
  [ ! -f $DSTF ] && [ -f $SRCF ] && mv $SRCF $DSTF
  [ -f $DSTF ] && echo "Copying $DSTF => $SRCF" && cp $DSTF $SRCF

done
