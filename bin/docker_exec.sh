#!/bin/bash

container_name=`shift`
cmd=$@

docker exec -it \
  ${container_name} \
  ${cmd}



  #--workdir="`pwd`" \