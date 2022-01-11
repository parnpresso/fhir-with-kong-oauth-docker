#!/bin/bash

docker-compose run kong kong migrations reset -y
docker-compose run kong kong migrations bootstrap
