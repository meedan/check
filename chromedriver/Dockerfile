FROM selenium/standalone-chrome-debug:3.141.59-20200730
USER root
RUN apt-get update -qq && apt-get install nginx --no-install-recommends -y
COPY ./nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
COPY ./entry_point.sh /
RUN chmod +x /entry_point.sh
CMD ["/entry_point.sh"]
