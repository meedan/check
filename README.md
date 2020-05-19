# Check

A collaborative media annotation platform.

This is a [Docker Compose](https://docs.docker.com/compose/) configuration that spins up the whole Check app locally. Tested on Linux and Mac OS X. The repo contains two Docker Compose files, one for development (`docker-compose.yml`) and the other for testing (`docker-test.yml`).

![Diagram](diagram.png?raw=true "Diagram")

## DO NOT USE IN PRODUCTION! THIS IS ONLY MEANT AS A DEVELOPMENT ENVIRONMENT.

## Quick start

- Install `docker-compose`
- Update your [virtual memory settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html), e.g. by setting `vm.max_map_count=262144` in `/etc/sysctl.conf`
- `git clone --recursive git@github.com:meedan/check.git && cd check`
- `bin/first-build.sh` and wait (for about one hour this first time!!) for a string in the log that looks like `web_1_88cd0bd245b7   | [21:07:07] [webpack:build:web:dev] Time: 83439ms`
- Open [http://localhost:3333](http://localhost:3333)
- Click "Create a new account with email" and enter your desired credentials
- `docker-compose exec api bash`
- `bundle exec rails c`
- `me = User.last; me.confirm; me.is_admin = true; me.save`
- Go back to [http://localhost:3333](http://localhost:3333)
- Click "I already have an account" and login using your credentials
- Enjoy Check! :tada:

## Available services and container names

- Check web client (container `web`) at [http://localhost:3333](http://localhost:3333)
- Check service API (container `api`) at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- Check service Admin UI (container `api`) at [http://localhost:3000/admin](http://localhost:3000/admin)
- Check service GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Check Slack Bot (container `bot`) at `check-bot/dist`, a ZIP file that should be deployed to AWS Lambda
- Pender service API (container `pender`) at [http://localhost:3200/api](http://localhost:3200/api) - use `dev` as API key
- Alegre service API (container `alegre`) at [http://localhost:3100](http://localhost:3100)
- MinIO storage service UI (container `minio`) at [http://localhost:9000](http://localhost:9000) - use `AKIAIOSFODNN7EXAMPLE` / `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` to login
- Elasticsearch API (container `elasticsearch`) at [http://localhost:9200](http://localhost:9200)
- Kibana Elasticsearch UI (container `kibana`) at [http://localhost:5601](http://localhost:5601)
- PostgreSQL (container `postgres`) at `localhost:5432` (use a standard Pg admin tool to connect)
- Chromedriver (container `chromedriver` in test mode) at [http://localhost:4444/wd/hub](http://localhost:4444/wd/hub)
- Chromedriver VNC at `localhost:5900` (use a standard VNC client to connect with password `secret`)
- Narcissus screenshot service (container `narcissus`) at [http://localhost:8687](http://localhost:8687)

## Testing

- Start the app in test mode: `docker-compose -f docker-compose.yml -f docker-test.yml up`
- Check web client: `docker-compose exec web npm run test`
- Check browser extension: `docker-compose exec mark npm run test`
- Check service API: `docker-compose exec api bundle exec rake test`
- Pender service API: `docker-compose exec pender bundle exec rake test`
- Check Slack Bot: `docker-compose exec bot npm run test`
- Narcissus: `docker-compose exec narcissus npm run test`
- Running a specific Check web client test: `docker-compose exec web bash -c "cd test && rspec --example KEYWORD spec/integration_spec.rb"`
- Running a specific Check API or Pender test (from within the container): `bundle exec ruby -I"lib:test" test/path/to/specific_test.rb -n /.*KEYWORD.*/`

## Helpful one-liners and scripts

- Update submodules to their latest commit: `./bin/git-update.sh`
- Pack your local config files: `./bin/tar-config.sh`
- Restart a service, e.g. Check API: `docker-compose run api bash -c "touch tmp/restart.txt"`
- Invoke the Rails console on a service, e.g. Check API: `docker-compose run api bundle exec rails c d`
- Update the Relay schema file on Check API: `docker-compose run api bundle exec rake lapis:graphql:schema`

## Troubleshooting

- If you're having trouble starting Elasticsearch on macOS, with the error `container_name exited with code 137`, you will need to adjust your Docker settings, as per https://www.petefreitag.com/item/848.cfm

## More documentation

- [Check API service](https://github.com/meedan/check-api)
- [Check Web application](https://github.com/meedan/check-web)
- [Pender API service](https://github.com/meedan/pender)
- [Alegre API service](https://github.com/meedan/alegre)
- [Narcissus service](https://github.com/meedan/narcissus)
- [Check Slack bot](https://github.com/meedan/check-slack-bot)
- [Check API bots](https://github.com/meedan/check-bots)

## Troubleshooting

- If you're having trouble starting Elasticsearch on macOS, with the error `container_name exited with code 137`, you will need to adjust your Docker settings, as per https://www.petefreitag.com/item/848.cfm
- If you're getting an error starting `chromedriver` in test mode, like the following:
```
docker-compose -f docker-compose.yml -f docker-test.yml up --abort-on-container-exit
Starting check_elasticsearch_1_2e69e84ccb56 ...
Starting check_chromedriver_1_6a1e9d8f5fd4  ... error
Starting check_elasticsearch_1_2e69e84ccb56 ... done
Starting check_postgres_1_85ec10c8f6db      ...
Starting check_redis_1_7fa3d5314c64         ... done
Starting check_postgres_1_85ec10c8f6db      ... done
Starting check_minio_1_f47a612b4538         ... done
Starting check_kibana_1_f37fbfb2f1e0        ... done
Starting check_narcissus_1_57634d5a39cc     ... done
Recreating check_pender_1_6a8f4ad6cc7f      ... done
Recreating check_alegre_1_fa01a996361e            ... done
Recreating check_pender-background_1_d0da14662d76 ... done
Recreating check_api_1_b5b998405f9f               ... done
Recreating check_api-background_1_2a68da3d4a99    ... done
Recreating check_bots_1_e85742eecf01              ... done
ERROR: for chromedriver  Cannot start service chromedriver: network 16d99f6d3d81011870fece7c627230b9410bdb5d0abc2d10a32f54af9f37931f not found
ERROR: Encountered errors while bringing up the project.
```
try this: `docker-compose -f docker-compose.yml -f docker-test.yml down`
