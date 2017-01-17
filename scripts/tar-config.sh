#!/bin/bash
filename=config-`date +%Y%m%d%H%M`.tar.gz
configs="check-api/config/config.yml \
         check-api/config/database.yml \
         pender/config/config.yml \
         pender/config/database.yml \
         check-web/config.js \
         check-web/test/config.js \
         check-web/test/config.yml \
         chromedriver/auth.txt"
tar zcf $filename $configs
if [ $? -eq 0 ]
then
  echo Created file $filename
  exit 0
else
  echo Could not create file $filename
  exit 1
fi
