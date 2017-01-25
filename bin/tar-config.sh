#!/bin/bash

# config tarfile is suffixed with timestamp.
filename=config-`date +%Y%m%d%H%M`.tar.gz

# find all config files, which should have .example variants.
configs=`find -name '*.example'`
configs=${configs//.example/}

# attempt to tar each file, but don't fail on missing ones.
# http://unix.stackexchange.com/questions/167717/tar-a-list-of-files-which-dont-all-exist
tar zcf $filename $(ls $configs)

# fail on non-zero exit code.
if [ $? -eq 0 ]
then
  echo Created file $filename
  exit 0
else
  rm $filename
  echo Could not create file $filename
  exit 1
fi
