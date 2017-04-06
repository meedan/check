# !/bin/sh -e
# http://blog.yohanliyanage.com/2015/05/docker-clean-up-after-yourself/

docker rm -v $(docker ps -a -q -f status=exited)

docker rmi $(docker images -f "dangling=true" -q)

docker volume prune -f

docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes
