# Check

Verify breaking news online

This is a [Docker Compose](https://docs.docker.com/compose/) configuration that spins up the whole Check app locally. Tested on Linux and Mac OS X.

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/check-app.git && cd check-app`
- Configuration - copy and edit the following files:
  - `check-api/config/config.yml.example` to `check-api/config/config.yml`
  - `check-api/config/database.yml.example` to `check-api/config/database.yml`
  - `pender/config/config.yml.example` to `pender/config/config.yml`
  - `pender/config/database.yml.example` to `pender/config/database.yml`
  - `check-web/config.js.example` to `check-web/config.js`
  - `check-web/config.js.example` to `check-web/test/config.js`
  - `check-web/test/config.yml.example` to `check-web/test/config.yml`
- `docker-compose pull && docker-compose build --pull`
- `docker-compose up`
- Databases (Postgres, Elasticsearch, etc.) will persist across runs - to clean, invoke `./docker-clean.sh`
- Container names:
  - `web` = Check web client
  - `api` = Check service, `development` mode
  - `pender` = Pender service, `development` mode
  - `api.test` = Check service, `test` mode
  - `pender.test` = Pender service, `test` mode
  - `elasticsearch` = Elasticsearch
  - `postgres` = Postgres
  - `chromedriver` = Selenium Chromedriver

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

## Helpful one-liners and scripts

- Build the client bundle: `docker-compose run web npm run build`
- Reset the `api.test` database: `docker-compose run api.test bundle exec rake db:drop db:create db:migrate`
- Update submodules to their latest commit: `./git-update.sh`
- Cleanup docker images and volumes: `./docker-clean.sh`
- Packing your local config files into `config.tar.gz`: `./tar-config.sh`

## Troubleshooting

- On Mac OS X, the very first `docker-compose up` currently fails because `check-web` does not correctly install and build itself. Until this is resolved, you need to run `docker-compose run web npm i && docker-compose run web npm run build` prior to spinning up the app.

- If you're using Docker with VirtualBox on OS X, first consider reinstalling Docker with [Docker for Mac](https://www.docker.com/products/docker#/mac), which doesn't need VirtualBox. In the meantime, if you cannot reach some services locally (e.g. `localhost:3333` fails), you might need to set up port forwards on the VirtualBox VM:

0. Open VirtualBox.app (can also do on command line)
0. Select the running VM and click "Settings" in the main window toolbar
0. Click "Network" and "Port Forwarding"
0. For each port above in "Available services", add a line like this: `<name> | TCP | 127.0.0.1 | <portNumber> | | <portNumber>`. For example, `check_web | TCP | 127.0.0.1 | 3333 | | 3333` The first column (name) is just a label in the VirtualBox UI.
