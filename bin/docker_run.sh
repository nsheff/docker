#!/bin/bash

container_name=$1
docker_image=$2
COMMAND=$3

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
  --volume /fsl:/fsl \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --workdir="`pwd`" \
  -p 4020:4020 \
  ${docker_image} \
  ${COMMAND}