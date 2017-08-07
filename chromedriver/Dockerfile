FROM selenium/standalone-chrome-debug
COPY test.png /app/test/spec/test.png
RUN wget -qO- https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-3.0.tgz | tar xz
COPY check-proxy.jmx .
COPY check-test-plan.jmx .
