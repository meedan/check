#!/bin/bash
read -p 'Are you sure? This is going to permanently delete Rails logs and Check Web bundles (y / n): ' -n 1 -r
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]
then
  rm check-api/log/*.log
  rm pender/log/*.log
  rm -rf check-web/build/web/*
fi
