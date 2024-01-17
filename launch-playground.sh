#!/bin/bash
#
# Copyright 2023 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#
#set -ex
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

echo "Checking if MySQL is runing"
if lsof -Pi :3306 -sTCP:LISTEN -t >/dev/null ; then
    echo "MySQL may allready be running on port 3306. Please shut down MySQL before launching the playground."
    exit
fi

echo "Checking if Postgres is runing"
if lsof -Pi :5432 -sTCP:LISTEN -t >/dev/null ; then
    echo "Postgres may allready be running on port 5432. Please shut down Postgres before launching the playground."
    exit -1
fi

cd ${playground_dir}
docker-compose up

# Clean Docker containers when you quit this script
docker-compose down
