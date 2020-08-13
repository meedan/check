#!/bin/bash

RETVAL=0

localtunnel_on() {
  configurator/do.sh deploy localtunnel
  docker-compose exec api touch tmp/restart.txt
  docker-compose exec pender touch tmp/restart.txt
  docker-compose exec web cp config.js build/web/js
  lt --port 3000 --subdomain check-api &
  lt --port 3333 --subdomain check-web &
  lt --port 3200 --subdomain pender &
}

localtunnel_off() {
  pkill -f subdomain
  configurator/do.sh deploy local
  docker-compose exec api touch tmp/restart.txt
  docker-compose exec pender touch tmp/restart.txt
  docker-compose exec web cp config.js build/web/js
}

case "$1" in
   "")
      echo "Usage: $0 [on|off]"
      RETVAL=1
      ;;
   on)
      localtunnel_on
      ;;
   off)
      localtunnel_off
      ;;
esac

exit $RETVAL
