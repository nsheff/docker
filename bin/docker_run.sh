#!/bin/bash
#$(env | cut -f1 -d= | sed 's/^/-e /') \
container_name="ruby"
docker_image="ruby"
COMMAND="bash"

docker run -it \
  --name=${container_name} \
  --user=$(id -u) \
  --env="DISPLAY" \
  -e $GENOMES \
  --volume ${HOME}:${HOME} \
  --volume ${EXTDATA}:${EXTDATA} \
  --volume="/etc/group:/etc/group:ro" \
  --volume="/etc/passwd:/etc/passwd:ro" \
  --volume="/etc/shadow:/etc/shadow:ro"  \
  --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --workdir="`pwd`" \
  -p 4020:4020 \
  ${docker_image} \
  ${COMMAND}
