# Checkdesk 3

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/checkdesk-app.git && cd checkdesk-app`
- Configuration:
  - Copy `checkdesk-api/config/config.yml.example` to `checkdesk-api/config/config.yml` and edit the Twitter/Facebook keys to enable social login
  - Copy `checkdesk-api/config/database.yml.example` to `checkdesk-api/config/database.yml`
  - Copy `pender/config/config.yml.example` to `pender/config/config.yml` and edit the Twitter/Facebook keys to enable better parsing of their respective media
  - Copy `pender/config/database.yml.example` to `pender/config/database.yml`
  - Copy `checkdesk-client/config.js.example` to `checkdesk-client/config.js`
  - Copy `checkdesk-client/config.js.example` to `checkdesk-client/test/config.js` and edit fo testing purposes
  - Copy `checkdesk-client/test/config.yml.example` to `checkdesk-client/test/config.yml` and edit for testing purposes
- `docker-compose build`
- `docker-compose up`
  - Databases (Postgres, Elasticsearch, etc.) will persist across runs - to clean, invoke `./docker-clean.sh`
  - Container names (as per `docker-compose.yml`):
    - `web` = Checkdesk client
    - `api` = Checkdesk service, `development` mode
    - `pender` = Pender service, `development` mode
    - `api.test` = Checkdesk service, `test` mode
    - `pender.test` = Pender service, `test` mode
    - `elasticsearch` = Elasticsearch
    - `postgres` = Postgres
    - `chromedriver` = Selenium Chromedriver

## Helpful one-liners

- Build the client bundle:
  `docker-compose run web npm run build`
- Reset the `api.test` database:
  `docker-compose run api.test bundle exec rake db:drop db:create db:migrate`
- Update submodules to their latest commit
  `./git-update.sh`
- Cleanup docker images and volumes
  `./docker-clean.sh`

## Troubleshooting

- If you're using VirtualBox on Mac OS X, and cannot reach the server locally (e.g. localhost:3333 fails), you might need to set up port forwards (e.g. host 3333 to guest 3333) on the VirtualBox VM:

0. Run `docker ps` to see the necessary ports
0. Open VirtualBox.app (can also do on command line)
0. Select the running VM and click "Settings" in the main window toolbar
0. Click "Network" and "Port Forwarding"

- If you're having difficulties building images try:
  `docker-compose build --pull`
  This will download the base image specified by the `FROM` instuction in each Dockerfile (usually `meedan/ruby`)

## Available services

- Checkdesk client at [http://localhost:3333](http://localhost:3333)
- Checkdesk service API at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- Checkdesk service GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Pender service API at [http://localhost:3200/api](http://localhost:3200/api) - use `dev` as API key
- Checkdesk service API / Test mode at [http://localhost:13000/api](http://localhost:13000/api) - use `test` as API key
- Checkdesk service GraphQL / Test mode at [http://localhost:13000/graphiql](http://localhost:13000/graphiql)
- Pender service API / Test mode at [http://localhost:13200/api](http://localhost:13200/api) - use `test` as API key
- Elasticsearch at [http://localhost:9200/_plugin/gui](http://localhost:9200/_plugin/gui)
- Postgres at port 5432 (use a standard Pg admin tool to connect)
- Chromedriver at [http://chromedriver:4444/wd/hub](http://chromedriver:4444/wd/hub)
- Chromedriver VNC at port 5900 (use a standard VNC client to connect with password `secret`)

## Testing

- Checkdesk client: `docker-compose run web npm run test`
- Checkdesk service: `docker-compose run api.test bundle exec rake test`
- Pender service: `docker-compose run pender.test bundle exec rake test`
- Running a specific test from within the `web` container: `cd test && rspec spec/app_spec.rb:63` or `cd test/spec && rspec -e 'part of the test name'`
