FROM selenium/standalone-chrome-debug
USER root
RUN wget -qO- https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-3.0.tgz | tar xz
COPY check-proxy.jmx .
COPY check-test-plan.jmx .
RUN apt-get update -qq && apt-get install nginx --no-install-recommends -y
COPY ./nginx.conf /etc/nginx/sites-available/check-api
RUN rm /etc/nginx/sites-enabled/default
COPY ./entry_point.sh /
RUN chmod +x /entry_point.sh
CMD ["/entry_point.sh"]
