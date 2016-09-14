# Check

Verify breaking news online

This is a [Docker Compose](https://docs.docker.com/compose/) configuration that spins up the whole Check app locally. Tested on Linux and Mac OS X.

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/check-app.git && cd check-app`
- Configuration:
  - Copy `check-api/config/config.yml.example` to `check-api/config/config.yml` and edit the Twitter/Facebook keys to enable social login
  - Copy `check-api/config/database.yml.example` to `check-api/config/database.yml`
  - Copy `pender/config/config.yml.example` to `pender/config/config.yml` and edit the Twitter/Facebook keys to enable better parsing of their respective media
  - Copy `pender/config/database.yml.example` to `pender/config/database.yml`
  - Copy `check-web/config.js.example` to `check-web/config.js`
  - Copy `check-web/config.js.example` to `check-web/test/config.js` and edit fo testing purposes
  - Copy `check-web/test/config.yml.example` to `check-web/test/config.yml` and edit for testing purposes
- `docker-compose build`
- `docker-compose up`
  - Databases (Postgres, Elasticsearch, etc.) will persist across runs - to clean, invoke `./docker-clean.sh`
  - Container names (as per `docker-compose.yml`):
    - `web` = Check web client
    - `api` = Check service, `development` mode
    - `pender` = Pender service, `development` mode
    - `api.test` = Check service, `test` mode
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
  This will refresh the base image specified by the `FROM` instruction in each Dockerfile (usually `meedan/ruby`.)

## Available services

- Check web client at [http://localhost:3333](http://localhost:3333)
- Check service API at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- Check service GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Pender service API at [http://localhost:3200/api](http://localhost:3200/api) - use `dev` as API key
- Check service API / Test mode at [http://localhost:13000/api](http://localhost:13000/api) - use `test` as API key
- Check service GraphQL / Test mode at [http://localhost:13000/graphiql](http://localhost:13000/graphiql)
- Pender service API / Test mode at [http://localhost:13200/api](http://localhost:13200/api) - use `test` as API key
- Elasticsearch at [http://localhost:9200/_plugin/gui](http://localhost:9200/_plugin/gui)
- Postgres at port 5432 (use a standard Pg admin tool to connect)
- Chromedriver at [http://localhost:4444/wd/hub](http://localhost:4444/wd/hub)
- Chromedriver VNC at port 5900 (use a standard VNC client to connect with password `secret`)

## Testing

- Check web client: `docker-compose run web npm run test`
- Check service: `docker-compose run api.test bundle exec rake test`
- Pender service: `docker-compose run pender.test bundle exec rake test`
- Running a specific web test: `docker-compose run web bash -c "cd test && rspec spec/app_spec.rb:63"`
