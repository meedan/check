#!/bin/bash

SERVICE="${1:-all}"
ACTION="${2:-all}"

update_repo() {
  local dir=$1
  echo "Updating repo: $dir"
  (
    cd "$dir"
    git checkout develop
    git pull
  )
}

update_api() {
  case "$ACTION" in
    push)
      echo 'Pushing Check API translations...'
      docker compose exec api /tx push
      ;;
    pull)
      echo 'Pulling Check API translations...'
      docker compose exec api /tx pull --all -f
      # docker compose exec api bundle exec rake transifex:download_tipline
      ;;
    all|*)
      echo 'Pushing + Pulling Check API translations...'
      docker compose exec api /tx push
      docker compose exec api /tx pull --all -f
      ;;
  esac

  echo 'Check API:'
  (cd check-api && git status)
}

update_web() {
  case "$ACTION" in
    push)
      echo 'Pushing Check Web translations...'
      docker compose exec web npm run transifex:merge-source
      docker compose exec web /tx push
      ;;
    pull)
      echo 'Pulling Check Web translations...'
      docker compose exec web /tx pull --all -f
      docker compose exec web npm run transifex:merge-translated
      ;;
    all|*)
      echo 'Pushing + Pulling Check Web translations...'
      docker compose exec web npm run transifex:merge-source
      docker compose exec web /tx push
      docker compose exec web /tx pull --all -f
      docker compose exec web npm run transifex:merge-translated
      ;;
  esac
  echo 'Check Web:'
  (cd check-web && git status)
}

case "$SERVICE" in
  check-api)
    update_repo check-api
    update_api
    ;;
  check-web)
    update_repo check-web
    update_web
    ;;
  all|*)
    update_repo check-api
    update_repo check-web

    update_api
    update_web
    # echo 'Updating Check Mark translations...'
    # docker compose exec mark npm run transifex:upload
    # docker compose exec mark npm run transifex:download

    echo '--- Done! Please review changes and push manually ---'
    echo "cd check-api && git commit config/locales -m 'CHECK-109: Updating l10n' && git push"
    echo "cd check-web && git commit localization -m 'CHECK-109: Updating l10n' && git push"
    ;;
esac
