#!/bin/bash

GITHUB_BRANCH="$1"
FALLBACK_BRANCH="$2"

git submodule foreach --recursive bash -c '
  GITHUB_BRANCH="$1"
  FALLBACK_BRANCH="$2"

  for b in "$GITHUB_BRANCH" main develop master "$FALLBACK_BRANCH"; do
    echo "Trying branch: $b"
    if git ls-remote --exit-code origin "$b" &>/dev/null; then
      echo "Found branch $b in remote. Checking out..."
      if git checkout -B "$b" "origin/$b"; then
        echo "Pulling latest changes for $b..."
        git pull
      fi
      exit 0
    else
      echo "Branch $b not found in remote."
    fi
  done

  echo "No matching branch found in submodule $name"
' _ "$GITHUB_BRANCH" "$FALLBACK_BRANCH"
