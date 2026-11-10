#!/bin/bash
## Retrieve system's timezone, use it in the docker run -e flag
HOST_TZ=$(timedatectl | awk '/Time zone:/ {print $3}') 
sudo bash ./stop-squidguard.sh
sudo docker run -d -e TZ="${HOST_TZ}" -p 3128:3128 -v ./squid.conf:/etc/squid/squid.conf -v ./squidGuard.conf:/etc/squidguard/squidGuard.conf -v ./squidguard:/var/lib/squidguard   --name squidguard  mosterho19/squidguard
sudo docker run -d -e TZ="${HOST_TZ}" -p 8080:80 -v ./squidguarderrors:/usr/local/apache2/htdocs --name httpd httpd
sudo docker ps -a
