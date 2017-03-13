# Check

Verify breaking news online

This is a [Docker Compose](https://docs.docker.com/compose/) configuration that spins up the whole Check app locally. Tested on Linux and Mac OS X (with [Docker for Mac](https://www.docker.com/products/docker#/mac)). The repo contains two Docker Compose files, one for development (`docker-compose.yml`) and the other for testing (`docker-test.yml`).

## DO NOT USE IN PRODUCTION! THIS IS ONLY MEANT AS A DEVELOPMENT ENVIRONMENT.

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/check-app.git && cd check-app`
- Configuration - copy and edit the following files:
  - `check-api/config/config.yml.example` to `check-api/config/config.yml`
  - `check-api/config/database.yml.example` to `check-api/config/database.yml`
  - `check-api/config/sidekiq.yml.example` to `check-api/config/sidekiq.yml`
  - `pender/config/config.yml.example` to `pender/config/config.yml`
  - `pender/config/database.yml.example` to `pender/config/database.yml`
  - `check-web/config.js.example` to `check-web/config.js`
  - `check-web/test/config.js.example` to `check-web/test/config.js`
  - `check-web/test/config.yml.example` to `check-web/test/config.yml`
  - `chromedriver/auth.txt.example` to `chromedriver/auth.txt`
- `docker-compose pull && docker-compose build --pull && docker-compose up`
- Databases (Postgres, Elasticsearch, etc.) will persist across runs
- Container names:
  - `web` = Check web client, `development` mode
  - `api` = Check service, `development` mode
  - `pender` = Pender service, `development` mode
  - `elasticsearch` = Elasticsearch
  - `postgres` = Postgres
  - `web.test` = Check web client, `test` mode
  - `api.test` = Check service, `test` mode
  - `pender.test` = Pender service, `test` mode
  - `chromedriver` = Selenium Chromedriver for use in `test` mode

## Available services

- Check web client at [http://localhost:3333](http://localhost:3333)
- Check service API at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- Check service GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Pender service API at [http://localhost:3200/api](http://localhost:3200/api) - use `dev` as API key
- Elasticsearch at [http://localhost:9200/_plugin/gui](http://localhost:9200/_plugin/gui)
- Postgres at `localhost:5432` (use a standard Pg admin tool to connect)
- Check web client / Test mode at [http://localhost:13333](http://localhost:13333)
- Check service API / Test mode at [http://localhost:13000/api](http://localhost:13000/api) - use `test` as API key
- Check service GraphQL / Test mode at [http://localhost:13000/graphiql](http://localhost:13000/graphiql)
- Pender service API / Test mode at [http://localhost:13200/api](http://localhost:13200/api) - use `test` as API key
- Chromedriver at [http://localhost:4444/wd/hub](http://localhost:4444/wd/hub)
- Chromedriver VNC at `localhost:5900` (use a standard VNC client to connect with password `secret`)

## Testing

- Build the app in test mode: `docker-compose -f docker-test.yml pull && docker-compose -f docker-test.yml build --pull`
- Start the app in test mode: `docker-compose -f docker-test.yml up`
- Check web client: `docker-compose -f docker-test.yml run web.test npm run test`
- Check service: `docker-compose -f docker-test.yml run api.test bundle exec rake test`
- Pender service: `docker-compose -f docker-test.yml run pender.test bundle exec rake test`
- Running a specific Check web client test: `docker-compose -f docker-test.yml run web.test bash -c "cd test && rspec --example KEYWORD spec/integration_spec.rb"`
- Running a specific Check API or Pender test (from within the container): `ruby -I"lib:test" test/path/to/specific_test.rb -n /.*KEYWORD.*/`

### Load testing
The idea of load testing is to run several concurrent instances of the integration tests. To do so, we first capture the HTTP requests made by the integration tests to the API using [Apache JMeter](http://jmeter.apache.org/)'s proxy feature. JMeter produces a test plan that can then be run locally or via a 3rd party service such as [Flood IO](http://flood.io/).

- Edit `check/check-web/test/config.yml` and add the following line to it: `proxy: localhost:8080`
- Start Check app in `test` mode
- Connect to Chromedriver using a VNC client
- Open JMeter via a terminal: `apache-jmeter-3.0/bin/jmeter -t check-proxy.jmx`
- Go to **Workbench** > **HTTP(S) Test Script Recorder**
- Press **Start** button at the bottom of the screen
- Run Check web client integration tests
- Wait until the test is complete
- Save test plan, e.g. to `/check-test-plan.jmx`
- NOTE: An updated Check test plan is already available at `/chromedriver/check-test-plan.jmx`


Running Load tests locally:

- Edit `check/check-web/test/config.yml` and add the following line to it: `proxy: localhost:8080`
- Start Check app in `test` mode
- Download [Jmeter 3.0](https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-3.0.tgz)
- Extract files
- Run `./apache-jmeter-3.0/bin/jmeter -JPWD=XXXX -n -t /chromedriver/check-test-plan.jmx -l /chromedriver/check-test-plan.jmxresults.jtl`, being: `./apache-jmeter-3.0/bin/jmeter` path where `jmeter` binary is installed, `XXXX` is the password for authentication in test server,`/chromedriver/check-test-plan.jmx` path to the test plan downloaded from check and `/chromedriver/check-test-plan.jmxresults.jtl` a new file created by jmeter with tests results.



## Helpful one-liners and scripts

- Build the web client bundle: `docker-compose run web npm run build`
- Restart a service, e.g. Check API: `docker-compose run api bash -c "touch tmp/restart.txt"`
- Invoke the Rails console on a service, e.g. Check API: `docker-compose run api bundle exec rails c d`
- Reset the `api.test` database: `docker-compose -f docker-test.yml run api.test bundle exec rake db:drop db:create db:migrate`
- Update submodules to their latest commit: `./bin/git-update.sh`
- Cleanup docker images and volumes: `./bin/docker-clean.sh`
- Packing your local config files: `./bin/tar-config.sh`
- Run a standalone image, e.g. Pender: `docker run -e SERVER_PORT=3200 -e RAILS_ENV=test -p 3200:3200 -v /absolute/path/to/check-app/pender:/app checkapp_pender`

## More documentation

- [Check service API](https://github.com/meedan/check-api)
- [Check web client](https://github.com/meedan/check-web)
- [Pender service API](https://github.com/meedan/pender)

## Troubleshooting

### `checkapp_web` fails with `Cannot find module 'express'` and exits
The very first `docker-compose up` currently fails because `check-web` does not correctly install and build itself. We are working on a fix for this issue. Until it is resolved, you need to run `docker-compose run web npm i && docker-compose run web npm run build` prior to spinning up the app.
