#!/bin/bash
#
# Copyright 2023 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#
# set -ex
playground_dir="$(dirname "${BASH_SOURCE-$0}")"
playground_dir="$(cd "${playground_dir}">/dev/null; pwd)"
isExist=`which docker-compose`
if [ $isExist ]
then
  true # Placeholder, do nothing
else
  echo "ERROR: No docker service environment found, please install docker-compose first."
  exit
fi

components=""
case "${1}" in
  bigdata)
    components="hive gravitino trino postgresql mysql spark"
    ;;
  ai)
    components="hive gravitino mysql jupyter"
    ;;
  *)
    components=$@
esac

cd ${playground_dir}
docker-compose up ${components}

# Clean Docker containers when you quit this script
docker-compose down