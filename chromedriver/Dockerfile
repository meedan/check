FROM selenium/standalone-chrome-debug
COPY test.png /app/test/spec/test.png
ADD http://mirror.nbtelecom.com.br/apache//jmeter/binaries/apache-jmeter-3.1.tgz .
RUN tar -xvzf ./apache-jmeter-3.1.tgz
COPY WorkBenchCheckAPI.jmx .
