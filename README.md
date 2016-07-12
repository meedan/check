# Checkdesk 3

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/checkdesk-app.git && cd checkdesk-app`
- `docker-compose up`

## Available services

- Checkdesk Client at [http://localhost:3333](http://localhost:3333)
- Checkdesk API at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- Checkdesk GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Pender API at [http://localhost:3200/api](http://localhost:3200/api) - use `dev` as API key
- Elasticsearch at [http://localhost:9200/_plugin/gui](http://localhost:9200/_plugin/gui)
- Postgres at port 5432 (you can use a standard Pg admin tool to connect)

## Testing

- Checkdesk Client: `docker-compose run web npm run test`
- Checkdesk API: `docker-compose run api-test bundle exec rake test`
- Pender API: `docker-compose run pender-test bundle exec rake test`
