#!/bin/bash
git submodule foreach bash -c 'git checkout develop'
find . -name '*.example' -not -path '*apollo*' | while read -r f; do cp "$f" "${f%%.example}"; done
docker-compose build
docker-compose up --abort-on-container-exit
