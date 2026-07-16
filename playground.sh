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

playground_dir="$(dirname "${BASH_SOURCE-$0}")"
playground_dir="$(
  cd "${playground_dir}" >/dev/null || exit 1
  pwd
)"

playgroundRuntimeName="gravitino-playground"
requiredDiskSpaceGB=25
requiredRamGB=8
requiredCpuCores=2
requiredPorts=(6080 8090 9001 3307 19000 19083 60070 13306 15432 14040 18080 18888 19090 13000)
mcpPort=8000
dockerComposeCommand=""

testDocker() {
  echo "[INFO] Testing Docker environment by running hello-world..."
  # Use `always` to test network connection
  docker run --rm --pull always hello-world:linux >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "[INFO] Docker check passed: Docker is working correctly!"
  else
    echo "[ERROR] Docker check failed: There was an issue running the hello-world container. Please check your Docker installation."
    exit 1
  fi

  for containerId in $(docker ps -aq --filter ancestor=hello-world); do
    docker rm "${containerId}" >/dev/null 2>&1
  done
  for imageId in $(docker images -q hello-world); do
    docker rmi -f "${imageId}" >/dev/null 2>&1
  done
}

checkDockerCompose() {
  dockerComposeCommand=""
  if command -v docker >/dev/null 2>&1 && command -v docker compose >/dev/null 2>&1; then
    dockerComposeCommand="docker compose"
  elif command -v docker-compose >/dev/null 2>&1; then
    dockerComposeCommand="docker-compose"
  else
    echo "[ERROR] Docker compose check failed: There was an issue running the docker compose command. Please check your docker compose installation."
    exit 1
  fi
  echo "[INFO] Docker compose check passed: Docker compose is working correctly using ${dockerComposeCommand} command!"
}

checkPlaygroundNotRunning() {
  if ${dockerComposeCommand} ls | grep -q "${playgroundRuntimeName}"; then
    echo "[ERROR] Playground runtime is already running. Please stop it first."
    exit 1
  fi
}

# True when the project exists but all its containers are stopped (present under
# 'ls -a' yet absent from the default running-only 'ls').
playgroundStoppedExists() {
  ${dockerComposeCommand} ls -a | grep -q "${playgroundRuntimeName}" && \
    ! ${dockerComposeCommand} ls | grep -q "${playgroundRuntimeName}"
}

# Present at all (running or stopped). Used by stop/down/status so they work on a
# stopped-but-not-removed project.
checkPlaygroundRunning() {
  if ! ${dockerComposeCommand} ls -a | grep -q "${playgroundRuntimeName}"; then
    echo "[ERROR] Playground runtime is not running. Please start it first."
    exit 1
  fi
}

checkDockerDisk() {
  # Step 1: Get Docker Root Directory
  local dockerRootDir="$(docker info 2>/dev/null | grep "Docker Root Dir" | awk '{print $NF}')"

  # Step 2: Check if the Docker directory exists
  if [ -z "${dockerRootDir}" ]; then
    echo "[ERROR] Docker disk check failed: Docker is not running or Docker Root Directory not found."
    exit 1
  fi

  local availableSpaceKB

  if [ -d "${dockerRootDir}" ]; then
    # Check available space in the Docker directory's partition
    availableSpaceKB=$(df -k "${dockerRootDir}" | awk 'NR==2 {print $4}')
  else
    # Check available space in the root partition if the directory doesn't exist (special case for WSL)
    availableSpaceKB=$(df -k / | awk 'NR==2 {print $4}')
  fi

  # Step 3: Check if available space is greater than required
  local availableSpaceGB=$((${availableSpaceKB} / 1024 / 1024))

  if [ "${availableSpaceGB}" -ge "${requiredDiskSpaceGB}" ]; then
    echo "[INFO] Docker disk check passed: ${availableSpaceGB} GB available."
  else
    echo "[ERROR] Docker disk check failed: Only ${availableSpaceGB} GB available, required ${requiredDiskSpaceGB} GB or more."
    exit 1
  fi
}

checkDockerRam() {
  local totalRamBytes=$(docker info --format '{{.MemTotal}}')
  # Convert from bytes to GB
  local totalRamGB=$((totalRamBytes / 1024 / 1024 / 1024))

  if [ "${totalRamGB}" -ge "${requiredRamGB}" ]; then
    echo "[INFO] Docker RAM check passed: ${totalRamGB} GB available."
  else
    echo "[ERROR] Docker RAM check failed: Only ${totalRamGB} GB available, required ${requiredRamGB} GB or more."
    exit 1
  fi
}

checkDockerCpu() {
  local cpuCores=$(docker info --format '{{.NCPU}}')

  if [ "${cpuCores}" -ge "${requiredCpuCores}" ]; then
    echo "[INFO] Docker CPU check passed: ${cpuCores} cores available."
  else
    echo "[ERROR] Docker CPU check failed: Only ${cpuCores} cores available, required ${requiredCpuCores} cores or more."
    exit 1
  fi
}

checkPortsInUse() {
  local usedPorts=()
  local availablePorts=()
  local portsToCheck=("${requiredPorts[@]}")

  if [ "${enableMcp}" == true ]; then
    portsToCheck+=("${mcpPort}")
  fi

  for port in "${portsToCheck[@]}"; do
    if [[ "$(uname)" == "Darwin" ]]; then
      openPort=$(lsof -i :${port} -sTCP:LISTEN)
    # Use sudo only when necessary
    elif [[ "$(uname)" == "Linux" ]]; then
      openPort=$(sudo lsof -i :${port} -sTCP:LISTEN)
    fi

    if [ -z "${openPort}" ]; then
      availablePorts+=("${port}")
    else
      usedPorts+=("${port}")
    fi
  done

  echo "[INFO] Port status check results:"

  if [ ${#availablePorts[@]} -gt 0 ]; then
    echo "[INFO] Available ports: ${availablePorts[*]}"
  fi

  if [ ${#usedPorts[@]} -gt 0 ]; then
    echo "[ERROR] Ports in use: ${usedPorts[*]}"
    echo "[ERROR] Please check these ports."
    exit 1
  fi
}

pruneLegacyLogs() {
  # delete all log files except the latest 3
  ls -tp playground-*.log | grep -v '/$' | tail -n +4 | xargs -I {} rm -- {}
}

start() {
  checkDockerCompose

  # Fast path: a previously started project that was halted with 'stop' still has
  # its containers on disk. Resume them with 'compose start' instead of a full
  # 'up', which skips re-running init and re-waiting on health checks.
  if playgroundStoppedExists; then
    echo "[INFO] Resuming stopped playground (fast restart, containers preserved)..."
    logSuffix=$(date +%Y%m%d%H%M%s)
    ${dockerComposeCommand} -p ${playgroundRuntimeName} start
    ${dockerComposeCommand} -p ${playgroundRuntimeName} logs -f >${playground_dir}/playground-${logSuffix}.log 2>&1 &
    echo "[INFO] Check log details: ${playground_dir}/playground-${logSuffix}.log"
    pruneLegacyLogs
    return
  fi

  if [ "${enableRanger}" == true ]; then
    echo "[INFO] Starting the playground with Ranger..."
  else
    echo "[INFO] Starting the playground..."
  fi

  echo "[INFO] The playground requires ${requiredCpuCores} CPU cores, ${requiredRamGB} GB of RAM, and ${requiredDiskSpaceGB} GB of disk storage to operate efficiently."

  checkPortsInUse
  testDocker
  checkPlaygroundNotRunning
  checkDockerDisk
  checkDockerRam
  checkDockerCpu

  cd ${playground_dir}
  echo "[INFO] Preparing packages..."
  ./init/spark/spark-dependency.sh
  ./init/gravitino/gravitino-dependency.sh
  ./init/jupyter/jupyter-dependency.sh

  logSuffix=$(date +%Y%m%d%H%M%s)

  # Build docker-compose command with appropriate override files
  composeFiles="-f docker-compose.yaml"
  if [ "${enableRanger}" == true ]; then
    composeFiles="${composeFiles} -f docker-enable-ranger-hive-override.yaml"
  fi
  if [ "${enableAuth}" == true ]; then
    composeFiles="${composeFiles} -f docker-enable-auth-override.yaml"
  fi
  if [ "${enableMcp}" == true ]; then
    composeFiles="${composeFiles} -f docker-mcp-override.yaml"
  fi

  ${dockerComposeCommand} ${composeFiles} -p ${playgroundRuntimeName} up --detach
  ${dockerComposeCommand} -p ${playgroundRuntimeName} logs -f >${playground_dir}/playground-${logSuffix}.log 2>&1 &
  echo "[INFO] Check log details: ${playground_dir}/playground-${logSuffix}.log"
  pruneLegacyLogs
}

status() {
  checkDockerCompose
  checkPlaygroundRunning
  ${dockerComposeCommand} ps -a
}

stop() {
  checkDockerCompose
  checkPlaygroundRunning
  echo "[INFO] Stopping the playground (containers preserved for fast restart)..."

  ${dockerComposeCommand} -p ${playgroundRuntimeName} stop
  if [ $? -eq 0 ]; then
    echo "[INFO] Playground stopped! Use 'playground.sh start' to resume quickly, or 'playground.sh down' to remove containers."
  fi
}

down() {
  checkDockerCompose
  checkPlaygroundRunning
  echo "[INFO] Tearing down the playground (containers and network removed)..."

  ${dockerComposeCommand} -p ${playgroundRuntimeName} down
  if [ $? -eq 0 ]; then
    echo "[INFO] Playground torn down!"
  fi
}

case "$1" in
start)
  enableRanger=false
  enableAuth=false
  enableMcp=true

  # Parse options
  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --enable-ranger)
        enableRanger=true
        shift
        ;;
      --enable-auth)
        enableAuth=true
        shift
        ;;
      --enable-mcp)
        # MCP is on by default; accepted for explicitness/back-compat.
        enableMcp=true
        shift
        ;;
      --disable-mcp)
        enableMcp=false
        shift
        ;;
      *)
        echo "Unknown option: $1"
        echo "Usage: playground.sh start [--enable-ranger] [--enable-auth] [--disable-mcp]"
        exit 1
        ;;
    esac
  done

  # Check for mutually exclusive options
  if [ "${enableRanger}" == true ] && [ "${enableAuth}" == true ]; then
    echo "[ERROR] --enable-ranger and --enable-auth cannot be used together. Please choose one."
    exit 1
  fi

  start
  ;;
status)
  status
  ;;
stop)
  stop
  ;;
down)
  down
  ;;
*)
  echo "Usage: $0 <start|status|stop|down> [--enable-ranger] [--enable-auth] [--disable-mcp]"
  echo "  start   bring the playground up (or resume a stopped one); MCP surface on by default"
  echo "  stop    halt containers but keep them for a fast restart"
  echo "  down    remove containers and network (full teardown)"
  echo "  status  show container status"
  exit 1
  ;;
esac
