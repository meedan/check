FROM selenium/standalone-chrome-debug
COPY test.png /app/test/spec/test.png
ADD https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-3.0.tgz .
RUN tar -xvzf ./apache-jmeter-3.0.tgz
COPY check-proxy.jmx .
COPY check-test-plan.jmx .
