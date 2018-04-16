#!/bin/bash

container_name=`shift`
cmd=$@

docker exec -it \
  ${container_name} \
  -e LWREF=$LWREF \
  -e LWLOCAL=$LWLOCAL \
  ${cmd}



  #--workdir="`pwd`" \