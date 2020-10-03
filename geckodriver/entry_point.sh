#!/bin/bash

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

rm -f /tmp/.X*lock

DISPLAY=$DISPLAY xvfb-run --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" geckodriver --host '0.0.0.0' &

for i in $(seq 1 10)
  do
  xdpyinfo -display $DISPLAY >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    break
  fi
  echo 'Waiting xvfb...'
  sleep 1
done

echo 'xvfb is running!'

fluxbox -display $DISPLAY &

x11vnc -forever -usepw -shared -rfbport 5900 -display $DISPLAY &

echo 'Starting Nginx...'
service nginx restart
tail -f /dev/null
