#!/bin/bash
#$(env | cut -f1 -d= | sed 's/^/-e /') \
container_name="$1"
docker_image="$2"
shift 2
cmd="$@"

echo "name: ${container_name}\t image: ${docker_image}\t cmd: ${cmd}"

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
  ${docker_image} \
  ${cmd}
