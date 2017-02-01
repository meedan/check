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
- `docker-compose pull && docker-compose build --pull && docker-compose up`
- Databases (Postgres, Elasticsearch, etc.) will persist across runs
- Container names:
  - `web` = Check web client, `development` mode
  - `api` = Check service, `development` mode
  - `pender` = Pender service, `development` mode
  - `elasticsearch` = Elasticsearch
  - `postgres` = Postgres
  - `chromedriver` = Selenium Chromedriver
  - `web.test` = Check web client, `test` mode
  - `api.test` = Check service, `test` mode
  - `pender.test` = Pender service, `test` mode

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
- Running a specific Check web client test: `docker-compose -f docker-test.yml run web.test bash -c "cd test && rspec spec/app_spec.rb:63"`
- Running a specific Check API or Pender test (from within the container): `ruby -I"lib:test" test/path/to/specific_test.rb -n /.*keyword.*/`

- Load Testing
  - Requirements:
    - JMeter 3.0 installed in Chromedriver docker container (`http://test.localdev.checkmedia.org:5900/`)
  - How to use it:
    - [Start app in test mode] (https://github.com/meedan/check-app/blob/feature/5504-jmeter/README.md#testing)
    - Connect to `http://test.localdev.checkmedia.org:5900/` using a Remote Desktop app under `VNC` protocol
    - Open JMeter GUI:
	- Open Terminal Emulator in the Remote desktop
	- Run: `apache-jmeter-3.0/bin/jmeter -t check_empty.jmx`
  - Testing Recording (at JMeter GUI):
    - Go to `Thread Group` \ `Recording Controller`
    - Go to `Workbench` \ `HTTP(S) Test Script Recorder`
    - Press `start` button at the bottom of the screen
    - Run [Check web client tests] (https://github.com/meedan/check-app/blob/feature/5504-jmeter/README.md#testing)
    - Wait until the test is complete
    - Save test plan
  - Load Testing in a local machine 
    - Copy the saved test plan with the recordings to your local machine:
	- `docker cp container_id:/check_empty.jmx check.jmx`
    - At terminal, clean databases running `docker-compose -f docker-test.yml run api.test bundle exec rake db:drop db:create db:migrate`
    - Open local Jmeter 3.0 GUI
    - At JMeter GUI:
	    - Go to `Thread Group`
	    - Set load testing parameters
	    - Press `Start` button (green arrow icon)
  - Load Testing in Flood IO 
    - At terminal, update Check URLs and ports running `ruby replace_url.rb [file.jmx] [url_original2] [url_original1] [port1] [new url port 1] [new port1] [port2] [new url port 13333] [new port2]`
	- Example: `ruby ./scripts/replace_url.rb check_with_records.jmx test.localdev.checkmedia.org api.test 13000 check-api.qa.checkmedia.org '' 13333 qa.checkmedia.org ''`
    - Upload updated test plan (new .jmx file) to Flood.io and run it
	- In the web browser go to https://flood.io/
	- Sign in
	- Create a new project and open it
	- Create Flood
	- Send the new `.jmx` file created before
	- Insert test name
	- Check _`Use settings from uploaded test plan` check box bellow `Jmeter 3.0` tool
	- Select Grid
	- Press `Launch Flood` button
  - *Observation:*
    - An empty and a recorded jmeter test plan are available at `check-app/tests` directory

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
