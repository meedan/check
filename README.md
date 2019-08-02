# Check

Verify breaking news online

This is a [Docker Compose](https://docs.docker.com/compose/) configuration that spins up the whole Check app locally. Tested on Linux and Mac OS X (with [Docker for Mac](https://www.docker.com/products/docker#/mac)). The repo contains two Docker Compose files, one for development (`docker-compose.yml`) and the other for testing (`docker-test.yml`).

![Diagram](diagram.png?raw=true "Diagram")

## DO NOT USE IN PRODUCTION! THIS IS ONLY MEANT AS A DEVELOPMENT ENVIRONMENT.

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/check.git && cd check`
- Configuration: copy and edit the `*.example` files in the submodules
- Update your [virtual memory settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html), e.g. by setting `vm.max_map_count=262144` in `/etc/sysctl.conf`
- `docker-compose build && docker-compose up`

## Available services and container names

- Check web client (container `web`) at [http://localhost:3333](http://localhost:3333)
- Check service API (container `api`) at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- Check service Admin UI (container `api`) at [http://localhost:3000/admin](http://localhost:3000/admin)
- Check service GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Check Slack Bot (container `bot`) at `check-bot/dist`, a ZIP file that should be deployed to AWS Lambda
- Pender service API (container `pender`) at [http://localhost:3200/api](http://localhost:3200/api) - use `dev` as API key
- Alegre service API (container `alegre`) at [http://localhost:3100](http://localhost:3100)
- vFrame service API (container `vframe`) at [http://localhost:5000](http://localhost:5000)
- Montage web client (container `montage`) at [http://localhost:8080](http://localhost:8080)
- Elasticsearch API (container `elasticsearch`) at [http://localhost:9200](http://localhost:9200)
- Kibana Elasticsearch UI (container `kibana`) at [http://localhost:5601](http://localhost:5601)
- PostgreSQL (container `postgres`) at `localhost:5432` (use a standard Pg admin tool to connect)
- Chromedriver (container `chromedriver` in test mode) at [http://localhost:4444/wd/hub](http://localhost:4444/wd/hub)
- Chromedriver VNC at `localhost:5900` (use a standard VNC client to connect with password `secret`)

## Testing

- Start the app in test mode: `docker-compose -f docker-compose.yml -f docker-test.yml up`
- Check web client: `docker-compose exec web npm run test`
- Check browser extension: `docker-compose exec mark npm run test`
- Check service API: `docker-compose exec api bundle exec rake test`
- Pender service API: `docker-compose exec pender bundle exec rake test`
- Running a specific Check web client test: `docker-compose exec web bash -c "cd test && rspec --example KEYWORD spec/integration_spec.rb"`
- Running a specific Check API or Pender test (from within the container): `ruby -I"lib:test" test/path/to/specific_test.rb -n /.*KEYWORD.*/`

## Helpful one-liners and scripts

- Build the web client bundle: `docker-compose run web npm run build`
- Build the browser extension: `docker-compose run mark npm run build`
- Build the Android application: `docker-compose run mark npm run generate-apk`
- Build the Slack bot: `docker-compose run bot npm run build`
- Build the Montage web client bundle: `docker-compose run montage npm run build`
- Watch for changes and build the Montage web client automatically when something changes: `docker-compose run montage npm run build:dev`
- Restart a service, e.g. Check API: `docker-compose run api bash -c "touch tmp/restart.txt"`
- Invoke the Rails console on a service, e.g. Check API: `docker-compose run api bundle exec rails c d`
- Reset the `api` database while the app is down: `docker-compose run api bundle exec rake db:drop db:create db:migrate`
- Update submodules to their latest commit: `./bin/git-update.sh`
- Cleanup docker images and volumes: `docker system prune -af` (best done while the app is up to avoid rebuilding the images later)
- Packing your local config files: `./bin/tar-config.sh`
- Run a standalone image, e.g. Pender: `docker run -e SERVER_PORT=3200 -e RAILS_ENV=test -p 3200:3200 -v /absolute/path/to/check-app/pender:/app check_pender`
- Update the automatic documentation of Check API: `docker-compose exec api bash -c "cd doc && make clean && make"`

## More documentation

- [Check service API](https://github.com/meedan/check-api)
- [Check web client](https://github.com/meedan/check-web)
- [Pender service API](https://github.com/meedan/pender)
- [Alegre service API](https://github.com/meedan/alegre)
- [vFrame service API](https://github.com/meedan/vframe)
- [Montage web client](https://github.com/meedan/montage-web)

## Troubleshooting and known issues

- Upon initial installation, the submodules may be checked out at a specific commit instead of the `develop` branch. You will need to go into each submodule and issue an explicit `git checkout develop`.
- Upon initial installation, to make sure the frontend is up to date, issue an explicit `docker-compose exec web npm run build` and `docker-compose exec montage npm run build`.
