#!/bin/bash
cd check-api && git checkout develop && git pull && cd - && \
cd check-web && git checkout develop && git pull && cd - && \
cd check-mark && git checkout develop && git pull && cd - && \
(docker-compose exec api bundle exec rake transifex:upload) && \
(docker-compose exec api bundle exec rake transifex:download) && \
(docker-compose exec web npm run transifex:upload) && \
(docker-compose exec web npm run transifex:download) && \
(docker-compose exec mark npm run transifex:upload) && \
(docker-compose exec mark npm run transifex:download) && \
echo 'Done! Please check the changes below:' && \
echo 'Check API:' && cd check-api && git status && cd - && \
echo 'Check Web:' && cd check-web && git status && cd - && \
echo 'Check Mark:' && cd check-mark && git status && cd - && \
# It's safer to run the ones below manually:
echo 'Should be all updated - if it looks good to you, please push to `develop`:' && \
echo "cd check-api && git commit config/locales -m 'Ticket #8618: Updating l10n' && git push && cd -" && \
echo "cd check-web && git commit localization -m 'Ticket #8618: Updating l10n' && git push && cd -" && \
echo "cd check-mark && git commit src/localization -m 'Ticket #8618: Updating l10n' && git push && cd -"
