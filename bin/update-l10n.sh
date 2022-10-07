#!/bin/bash
cd check-api && git checkout develop && git pull && cd - && \
cd check-web && git checkout develop && git pull && cd - && \
cd check-mark && git checkout develop && git pull && cd - && \
cd check-search && git checkout develop && git pull && cd - && \
echo 'Updating Check API translations...' && \
(docker-compose exec api bundle exec rake transifex:upload) && \
(docker-compose exec api bundle exec rake transifex:download) && \
(docker-compose exec api bundle exec rake transifex:download_tipline) && \
echo 'Updating Check Web translations...' && \
(docker-compose exec web npm run transifex:upload) && \
(docker-compose exec web npm run transifex:download) && \
echo 'Updating Check Mark translations...' && \
(docker-compose exec mark npm run transifex:upload) && \
(docker-compose exec mark npm run transifex:download) && \
# echo 'Updating Check Search translations...' && \
# (docker-compose exec search npm run transifex:upload) && \
# (docker-compose exec search npm run transifex:download) && \
echo 'Done! Please check the changes below:' && \
echo 'Check API:' && cd check-api && git status && cd - && \
echo 'Check Web:' && cd check-web && git status && cd - && \
echo 'Check Mark:' && cd check-mark && git status && cd - && \
# echo 'Check Search:' && cd check-search && git status && cd - && \
# It's safer to run the ones below manually:
echo 'Should be all updated - if it looks good to you, please push to `develop`:' && \
echo "cd check-api && git commit config/locales -m 'CHECK-109: Updating l10n' && git push && cd -" && \
echo "cd check-web && git commit localization -m 'CHECK-109: Updating l10n' && git push && cd -" && \
echo "cd check-mark && git commit src/localization -m 'CHECK-109: Updating l10n' && git push && cd -"
# echo "cd check-search && git commit localization -m 'CHECK-109: Updating l10n' && git push && cd -"
