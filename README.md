# Check

Verify breaking news online

This is a [Docker Compose](https://docs.docker.com/compose/) configuration that spins up the whole Check app locally. Tested on Linux and Mac OS X (with [Docker for Mac](https://www.docker.com/products/docker#/mac)). The repo contains two Docker Compose files, one for development (`docker-compose.yml`) and the other for testing (`docker-test.yml`).

## DO NOT USE IN PRODUCTION! THIS IS ONLY MEANT AS A DEVELOPMENT ENVIRONMENT.

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/check-app.git && cd check-app`
- Configuration - copy and edit the following files:
  - `check-api/config/config.yml.example` to `check-api/config/config.yml`
  - `check-api/config/database.yml.example` to `check-api/config/database.yml`
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

## The subdomain issue

Check works as a multi-tenant application, where each team is considered to be a different tenant.
For each team, Check redirects to a subdomain of the base app URL (e.g. `http://team-one.localhost:3333`).
There are several concerns to take into account while setting up a subdomain-friendly Docker environment:

- Ability to address any subdomain from a browser running on the local host and have the request handled by the Check web client.
- Ability for the backend Check service to address subdomains to verify the validity of new team subdomains.
- Ability to run tests (including Selenium tests) from within the relevant Docker containers.

We've currently opted for a simple, but incomplete approach of creating a DNS entry in our own domains that redirects to the default
Docker local IP (i.e. `172.17.0.1`) and that supports wildcards. The entry is `test.localdev.checkmedia.org`, and this is what it looks like:

```
$ dig test.localdev.checkmedia.org

; <<>> DiG 9.9.5-3ubuntu0.9-Ubuntu <<>> test.localdev.checkmedia.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42058
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;test.localdev.checkmedia.org.	IN	A

;; ANSWER SECTION:
test.localdev.checkmedia.org. 299 IN	A	172.17.0.1

;; Query time: 66 msec
;; SERVER: 127.0.1.1#53(127.0.1.1)
;; WHEN: Sat Oct 08 13:09:04 PDT 2016
;; MSG SIZE  rcvd: 73
```

We will work on refining this approach, and we welcome suggestions for a more robust one - including the avoidance of relying on an external DNS.

For now, it means that your `check-app` configuration files as listed above should all point to `http://test.localdev.checkmedia.org`,
suffixed with the right ports for the various services. You can of course create your own DNS entry elsewhere that points to your correct Docker IP in case `172.17.0.1` is not right for you.

## Available services

- Check web client at [http://test.localdev.checkmedia.org:3333](http://test.localdev.checkmedia.org:3333)
- Check service API at [http://test.localdev.checkmedia.org:3000/api](http://test.localdev.checkmedia.org:3000/api) - use `dev` as API key
- Check service GraphQL at [http://test.localdev.checkmedia.org:3000/graphiql](http://test.localdev.checkmedia.org:3000/graphiql)
- Pender service API at [http://test.localdev.checkmedia.org:3200/api](http://test.localdev.checkmedia.org:3200/api) - use `dev` as API key
- Elasticsearch at [http://test.localdev.checkmedia.org:9200/_plugin/gui](http://test.localdev.checkmedia.org:9200/_plugin/gui)
- Postgres at `test.localdev.checkmedia.org:5432` (use a standard Pg admin tool to connect)
- Check web client / Test mode at [http://test.localdev.checkmedia.org:13333](http://test.localdev.checkmedia.org:13333)
- Check service API / Test mode at [http://test.localdev.checkmedia.org:13000/api](http://test.localdev.checkmedia.org:13000/api) - use `test` as API key
- Check service GraphQL / Test mode at [http://test.localdev.checkmedia.org:13000/graphiql](http://test.localdev.checkmedia.org:13000/graphiql)
- Pender service API / Test mode at [http://test.localdev.checkmedia.org:13200/api](http://test.localdev.checkmedia.org:13200/api) - use `test` as API key
- Chromedriver at [http://test.localdev.checkmedia.org:4444/wd/hub](http://test.localdev.checkmedia.org:4444/wd/hub)
- Chromedriver VNC at `test.localdev.checkmedia.org:5900` (use a standard VNC client to connect with password `secret`)

## Testing

- Build the app in test mode: `docker-compose -f docker-test.yml pull && docker-compose -f docker-test.yml build --pull`
- Start the app in test mode: `docker-compose -f docker-test.yml up`
- Check web client: `docker-compose -f docker-test.yml run web.test npm run test`
- Check service: `docker-compose -f docker-test.yml run api.test bundle exec rake test`
- Pender service: `docker-compose -f docker-test.yml run pender.test bundle exec rake test`
- Running a specific Check web client test: `docker-compose -f docker-test.yml run web.test bash -c "cd test && rspec spec/app_spec.rb:63"`
- Running a specific Check API or Pender test (from within the container): `ruby -I"lib:test" test/path/to/specific_test.rb -n /.*keyword.*/`

## Helpful one-liners and scripts

- Build the web client bundle: `docker-compose run web npm run build`
- Restart a service, e.g. Check API: `docker-compose run api bash -c "touch tmp/restart.txt"`
- Invoke the Rails console on a service, e.g. Check API: `docker-compose run api bundle exec rails c d`
- Reset the `api.test` database: `docker-compose -f docker-test.yml run api.test bundle exec rake db:drop db:create db:migrate`
- Update submodules to their latest commit: `./scripts/git-update.sh`
- Cleanup docker images and volumes: `./scripts/docker-clean.sh`
- Packing your local config files: `./scripts/tar-config.sh`
- Run a standalone image, e.g. Pender: `docker run -e SERVER_PORT=3200 -e RAILS_ENV=test -p 3200:3200 -v /absolute/path/to/check-app/pender:/app checkapp_pender`

## Troubleshooting

- The very first `docker-compose up` currently fails because `check-web` does not correctly install and build itself. We are working on a fix for this issue. Until it is resolved, you need to run `docker-compose run web npm i && docker-compose run web npm run build` prior to spinning up the app.
