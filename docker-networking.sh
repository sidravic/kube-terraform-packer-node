#!/bin/bash

sudo ifconfig lo0 alias 10.10.10.10

# Has the same effect as running the docker-compose file
# Runs it in foreground mode
docker run --add-host dockerhost:10.10.10.10 \
           --env-file development.env \
           --name chomeshvan \
           --hostname chomeshvan \
           -p 8000:8000 \
           chomeshvan:latest

#To run in interactive mode
docker run -it --add-host dockerhost:10.10.10.10 \
           --env-file development.env \
           --name chomeshvan \
           --hostname chomeshvan \
           -p 8000:8000 \
           chomeshvan:latest /bin/bash

#To run a redis container
docker run --name redis --hostname redis -p 6380:6379 redis:latest

#Log onto the the chomeshvan container and ping redis
docker run -it --add-host dockerhost:10.10.10.10 \
           --env-file development.env \
           --name chomeshvan \
           --hostname chomeshvan \
           -p 8000:8000 \
           chomeshvan:latest /bin/bash

root@chomeshvan:/chomeshvan# ping redis
# will hang because this container does not know to find the redis container

# List all networks
docker network ls

#docker network ls
# NETWORK ID          NAME                            DRIVER              SCOPE
# 1e4c6e345169        bridge                          bridge              local
# 638d2d2535db        cassandracluster_default        bridge              local
# d37e048249c8        chomeshvan_default              bridge              local
# 61c918531242        chomeshvan_redis                bridge              local
# c9abe634d50c        collectapi_default              bridge              local
# 892ba5c3d872        dockersamplerailssid_default    bridge              local
# a11eed9703c2        eventsqstos3publisher_default   bridge              local
# bee292971683        host                            host                local
# d9ffbc4fc02e        node1_default                   bridge              local
# 13bc298626dc        none                            null                local
# d37ed2133b8b        simplapi_default                bridge              local
# 36d5ca0036a0        simplapprovalsapi_default       bridge              local
# 39ff4c8b1967        simplwebfrontend_default        bridge              local
# e13457660c1a        unity_default                   bridge              local

#Create a custom network called chomeshvan_redis of type bridge
docker network create --driver bridge chomeshvan_redis

#Run the same command with the new network
docker run --network chomeshvan_redis --name redis --hostname redis -p 6380:6379 redis:latest
docker run -it --network chomeshvan_redis \
           --add-host dockerhost:10.10.10.10 \
           --env-file development.env \
           --name chomeshvan \
           --hostname chomeshvan \
           -p 8000:8000 \
           chomeshvan:latest /bin/bash

#Now ping redis will woork