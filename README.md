# Checkdesk 3

- Install `docker-compose`
- `git clone --recursive git@github.com:meedan/checkdesk-app.git`
- `docker-compose up`

## Available services

- API at [http://localhost:3000/api](http://localhost:3000/api) - use `dev` as API key
- GraphQL at [http://localhost:3000/graphiql](http://localhost:3000/graphiql)
- Elasticsearch at [http://localhost:9200/_plugin/gui](http://localhost:9200/_plugin/gui)
- Postgres at port 5432 (you can use a standard Pg admin tool to connect)
