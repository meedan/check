#!/usr/bin/env bash
echo 'Starting Nginx...'
service nginx restart
echo 'Starting regular Chromedriver entry point...'
/opt/bin/entry_point.sh
