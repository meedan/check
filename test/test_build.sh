#!/bin/bash  
file='../docker_up_output.txt'  

images=("check_alegre" "check_api" "check_api-background" "check_bots" "check_elasticsearch" "check_fetch" "check_fetch-background" "check_mark" "check_narcissus" "check_pender" "check_pender-background" "check_web")

i=0 
if [ -s "$file" ] 
then
  while read line; do  
  if [ $line != ${images[i]} ]
  then
    echo "$line is not equal to ${images[i]}"
    exit 1
  fi
  i=$((i+1))  
  done < $file  
else
	echo "$file is empty"
  exit 1  
fi