#!/bin/bash

container_name=$1

docker exec -it \
  ${container_name} \
  bash