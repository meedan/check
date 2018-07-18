FROM docker.elastic.co/elasticsearch/elasticsearch:6.3.0
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
RUN bin/elasticsearch-plugin install analysis-icu
