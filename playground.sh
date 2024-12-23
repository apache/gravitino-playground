#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

set -x

playground_dir="$(dirname "${BASH_SOURCE-$0}")"
playground_dir="$(
  cd "${playground_dir}" >/dev/null
  pwd
)"

testDocker() {
  echo "INFO: Testing Docker environment by running hello-world..."
  docker run --pull always hello-world >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "INFO: Docker is working correctly!"
  else
    echo "ERROR: There was an issue running the hello-world container. Please check your Docker installation."
    exit 1
  fi
}

checkCompose() {
  isExist=$(which docker-compose)
  if [ $isExist ]; then
    true # Placeholder, do nothing
  else
    echo "ERROR: No docker service environment found. Please install docker-compose."
    exit
  fi
}

checkPortInUse() {
  local port=$1
  if [[ "$(uname)" == "Darwin" ]]; then
    openPort=$(lsof -i :$port -sTCP:LISTEN)
  elif [[ "$(uname)" == "Linux" ]]; then
    echo "Checking ports with sudo permission ...'
    openPort=$(sudo lsof -i :$port -sTCP:LISTEN)
  fi
  if [ -z "${openPort}" ]; then
    echo "INFO: Port $port is ok."
  else
    echo "ERROR: Port $port is in use. Please check it."
    exit 1
  fi
}

start() {
  echo "INFO: Starting the playground..."

  testDocker
  checkCompose
  ports=(8090 9001 3307 19000 19083 60070 13306 15342 18080 18888 19090 13000)
  for port in "${ports[@]}"; do
    checkPortInUse ${port}
  done

  cd ${playground_dir}
  echo "Preparing packages..."
  ./init/spark/spark-dependency.sh
  ./init/gravitino/gravitino-dependency.sh
  ./init/jupyter/jupyter-dependency.sh

  logSuffix=$(date +%Y%m%d%H%m%s)
  if [ "$enableRanger" == true ]; then
    docker-compose -f docker-compose.yaml -f docker-enable-ranger-hive-override.yaml up --detach
  else
    docker-compose up --detach
  fi
	
  docker compose logs -f >${playground_dir}/playground-${logSuffix}.log 2>&1 &
  echo "Check log details: ${playground_dir}/playground-${logSuffix}.log"
}

status() {
  docker-compose ps -a
}

stop() {
  echo "INFO: Stopping the playground..."

  docker-compose down
  if [ $? -eq 0 ]; then
    echo "INFO: Playground stopped!"
  fi
}

case "$1" in
start)
  if [[ "$2" == "-y" ]]; then
    input="y"
  else
    echo "The playground requires 2 CPU cores, 8 GB of RAM, and 25 GB of disk storage to operate efficiently."
    read -r -p "Confirm the requirement is available in your OS [Y/n]:" input
  fi

  if [[ "$2" == "--enable-ranger" || "$3" == "--enable-ranger" ]]; then
    enableRanger=true
  else
    enableRanger=false
  fi

  case $input in
  [yY][eE][sS] | [yY]) ;;
  [nN][oO] | [nN])
    exit 0
    ;;
  *)
    echo "ERROR: Invalid input!"
    exit 1
    ;;
  esac
  start
  ;;
status)
  status
  ;;
stop)
  stop
  ;;
*)
  echo "Usage: $0 [start | status | stop]"
  exit 1
  ;;
esac
