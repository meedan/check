## If you're getting an error starting `chromedriver` in test mode, like the following:
```
docker-compose -f docker-compose.yml -f docker-test.yml up --abort-on-container-exit
Starting check_elasticsearch_1_2e69e84ccb56 ...
Starting check_chromedriver_1_6a1e9d8f5fd4  ... error
[..]
ERROR: for chromedriver  Cannot start service chromedriver: network 16d99f6d3d81011870fece7c627230b9410bdb5d0abc2d10a32f54af9f37931f not found
ERROR: Encountered errors while bringing up the project.
```
try this: `docker-compose -f docker-compose.yml -f docker-test.yml down`
