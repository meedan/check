FROM selenium/standalone-chrome-debug
RUN wget -qO- https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-3.0.tgz | sudo tar xz
COPY check-proxy.jmx .
COPY check-test-plan.jmx .
