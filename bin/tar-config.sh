#!/bin/bash
filename=config-`date +%Y%m%d%H%M`.tar.gz
tar zcf $filename check-api/config/config.yml check-api/config/database.yml check-api/config/sidekiq.yml pender/config/config.yml pender/config/database.yml check-web/config.js check-web/test/config.js check-web/test/config.yml
echo Created file $filename
