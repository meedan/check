# Check

Verify breaking news online

This is a [Docker Compose](https://docs.docker.com/compose/) configuration that spins up the whole Check app locally. Tested on Linux and Mac OS X (with [Docker for Mac](https://www.docker.com/products/docker#/mac)). The repo contains two Docker Compose files, one for development (`docker-compose.yml`) and the other for testing (`docker-test.yml`).

## DO NOT USE IN PRODUCTION! THIS IS ONLY MEANT AS A DEVELOPMENT ENVIRONMENT.

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/check.git && cd check`
- Configuration - copy and edit the following files:
  - `check-api/config/config.yml.example` to `check-api/config/config.yml`
  - `check-api/config/database.yml.example` to `check-api/config/database.yml`
  - `check-api/config/sidekiq.yml.example` to `check-api/config/sidekiq.yml`
  - `pender/config/config.yml.example` to `pender/config/config.yml`
  - `pender/config/database.yml.example` to `pender/config/database.yml`
  - `check-web/config.js.example` to `check-web/config.js`
  - `check-web/config-build.js.example` to `check-web/config-build.js`
  - `check-web/config-server.js.example` to `check-web/config-server.js`
  - `check-web/test/config.js.example` to `check-web/test/config.js`
  - `check-web/test/config.yml.example` to `check-web/test/config.yml`
  - `check-mark/config.js.example` to `check-mark/config.js`
  - `check-mark/test/config.yml.example` to `check-mark/test/config.yml`
- Update your [virtual memory settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html), e.g. by setting `vm.max_map_count=262144` in `/etc/sysctl.conf`
- `docker-compose pull && docker-compose build --pull && docker-compose up`

## Available services and container names

### `development` mode using `docker-compose.yml`

- Check web client (container `web`) at [http://localhost:3333](http://localhost:3333)
- Check service API (container `api`) at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- Check service GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Check Slack Bot (container `bot`) at `check-bot/dist`, a ZIP file that should be deployed to AWS Lambda
- Check browser extension (container `mark`) at `check-mark/build` and Android application at `build.apk`
- Pender service API (container `pender`) at [http://localhost:3200/api](http://localhost:3200/api) - use `dev` as API key
- Elasticsearch API (container `elasticsearch`) at [http://localhost:9200](http://localhost:9200)
- PostgreSQL (container `postgres`) at `localhost:5432` (use a standard Pg admin tool to connect)

### `test` mode using `docker-test.yml`

- Check web client (container `web.test`) at [http://localhost:13333](http://localhost:13333)
- Check service API (container `api.test`) at [http://localhost:13000/api](http://localhost:13000/api) - use `test` as API key
- Check service GraphQL at [http://localhost:13000/graphiql](http://localhost:13000/graphiql)
- Check browser extension (container `mark`) at `check-mark/releases/test`
- Pender service API (container `pender.test`) at [http://localhost:13200/api](http://localhost:13200/api) - use `test` as API key
- Elasticsearch API (container `elasticsearch`) at [http://localhost:9200](http://localhost:9200)
- PostgreSQL (container `postgres`) at `localhost:5432` (use a standard Pg admin tool to connect)
- Chromedriver (container `chromedriver`) at [http://localhost:4444/wd/hub](http://localhost:4444/wd/hub)
- Chromedriver VNC at `localhost:5900` (use a standard VNC client to connect with password `secret`)
- Geckodriver VNC at `localhost:5901` (use a standard VNC client to connect with password `secret`)

## Testing

- Build the app in test mode: `docker-compose -f docker-test.yml pull && docker-compose -f docker-test.yml build --pull`
- Start the app in test mode: `docker-compose -f docker-test.yml up`
- Check web client: `docker-compose -f docker-test.yml exec web.test npm run test`
- Check browser extension: `docker-compose -f docker-test.yml exec mark.test npm run test`
- Check Slack bot: `docker-compose -f docker-test.yml exec bot.test npm test`
- Check service: `docker-compose -f docker-test.yml exec api.test bundle exec rake test`
- Pender service: `docker-compose -f docker-test.yml exec pender.test bundle exec rake test`
- Running a specific Check web client test: `docker-compose -f docker-test.yml exec web.test bash -c "cd test && rspec --example KEYWORD spec/integration_spec.rb"`
- Running a specific Check API or Pender test (from within the container): `ruby -I"lib:test" test/path/to/specific_test.rb -n /.*KEYWORD.*/`

### Load testing
The idea of load testing is to run several concurrent instances of the integration tests. To do so, we first capture the HTTP requests made by the integration tests to the API using [Apache JMeter 3.0](http://jmeter.apache.org/)'s proxy feature. JMeter produces a test plan that can then be run locally or via a 3rd party service such as [Flood IO](http://flood.io/).

- Edit `./check-web/test/config.yml` and add the following line to it: `proxy: localhost:8080`
- Start Check app in `test` mode
- Connect to Chromedriver using a VNC client
- Open JMeter via a terminal: `./apache-jmeter-3.0/bin/jmeter -t check-proxy.jmx`
- Go to **Workbench** > **HTTP(S) Test Script Recorder**
- Press **Start** button at the bottom of the screen
- Run Check web client integration tests
- Wait until the test is complete
- Save test plan, e.g. to `./check-test-plan.jmx`
- NOTE: An updated Check test plan is already available at `./chromedriver/check-test-plan.jmx`

### Running load tests locally

- Run `/path/to/apache-jmeter-3.0/bin/jmeter -n -t /path/to/check/chromedrive/check-test-plan.jmx -Jtestproperty=number-of-threads -Jreport=report-name.csv -JAUTH_USER=your-test-stage-http-auth-username -JAUTH_PASS=your-test-stage-http-auth-password`
 where `-Jtestproperty` is the number of threads(users) to be executed ; `Jreport` is the name of the load test report to be generated ; `-JAUTH_USER` is the test server user ; `-JAUTH_PASS` is the test server password ; `check-test-results.jtl` is the [JMeter test run results file](https://wiki.apache.org/jmeter/JtlFiles).

## Helpful one-liners and scripts

- Build the web client bundle: `docker-compose run web npm run build`
- Build the browser extension: `docker-compose run mark npm run build`
- Build the Android application: `docker-compose run mark npm run generate-apk`
- Build the Slack bot: `docker-compose run bot npm run build`
- Restart a service, e.g. Check API: `docker-compose run api bash -c "touch tmp/restart.txt"`
- Invoke the Rails console on a service, e.g. Check API: `docker-compose run api bundle exec rails c d`
- Reset the `api.test` database: `docker-compose -f docker-test.yml run api.test bundle exec rake db:drop db:create db:migrate`
- Update submodules to their latest commit: `./bin/git-update.sh`
- Cleanup docker images and volumes: `docker system prune -af` (best done while the app is up to avoid rebuilding the images later)
- Packing your local config files: `./bin/tar-config.sh`
- Run a standalone image, e.g. Pender: `docker run -e SERVER_PORT=3200 -e RAILS_ENV=test -p 3200:3200 -v /absolute/path/to/check-app/pender:/app check_pender`
- Update the automatic documentation of Check API: `docker-compose -f ../docker-test.yml exec api.test bash -c "cd doc && make clean && make"`

## More documentation

- [Check service API](https://github.com/meedan/check-api)
- [Check web client](https://github.com/meedan/check-web)
- [Pender service API](https://github.com/meedan/pender)
- [Check browser extension and mobile app](https://github.com/meedan/check-mark)
- [Check Slack Bot](https://github.com/meedan/check-bot)

## Troubleshooting and known issues

- Upon initial installation, the submodules may be checked out at a specific commit instead of the `develop` branch. You will need to go into each submodule and issue an explicit `git checkout develop`.
- Upon initial installation, to make sure the frontend is up to date, issue an explicit `docker-compose exec web npm run build`.
