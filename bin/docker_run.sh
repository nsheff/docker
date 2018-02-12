#!/bin/bash

container_name=$1
docker_image=$2

docker run -it \
  --name=${container_name} \
  --user=$(id -u) \
  --env="DISPLAY" \
  --volume="/etc/group:/etc/group:ro" \
  --volume="/etc/passwd:/etc/passwd:ro" \
  --volume="/etc/shadow:/etc/shadow:ro"  \
  --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
  --volume ${HOME}/code:/code \
  --volume ${HOME}:${HOME} \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -w ${HOME} \
  ${docker_image} \
  bash