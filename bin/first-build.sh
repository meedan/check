#!/bin/bash

# Go to the develop branch of each repository
# git submodule foreach bash -c 'git checkout develop || git checkout master'

# Copy the example files
find . -name '*.example' -not -path '*apollo*' | while read f; do cp "$f" "${f%%.example}"; done

# Replace secrets (if you have access, login first with "aws sso login")
replace_secret () {
  app=$1
  file=$2
  key=$3
  value=$(aws ssm get-parameter --region eu-west-1 --name "/local/$app/$key" | grep Value | sed 's/.*"Value": "\(.*\)",/\1/g')
  sed -i "s/$key: 'SECRET'/$key: '$value'/g" "$app/$file"
}
replace_secret 'check-api' 'config/config.yml' 'google_client_id'
replace_secret 'check-api' 'config/config.yml' 'google_client_secret'

# Build & Run
docker-compose build
docker-compose up --abort-on-container-exit
