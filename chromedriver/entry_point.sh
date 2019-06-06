#!/usr/bin/env bash
ln -s /etc/nginx/sites-available/check-api /etc/nginx/sites-enabled/check-api
echo 'Starting Nginx...'
nginx &
echo 'Starting regular Chromedriver entry point...'
/opt/bin/entry_point.sh
