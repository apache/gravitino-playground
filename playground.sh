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

runtime=""
dockerComposeCommand=""

requiredDiskSpaceGB=25
requiredRamGB=8
requiredCpuCores=2
requiredPorts=(8090 9001 3307 19000 19083 60070 13306 15342 18080 18888 19090 13000)

testDocker() {
  echo "[INFO] Testing Docker environment by running hello-world..."
  # Use always to test network connection
  docker run --rm --pull always hello-world:linux >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "[INFO] Docker check passed: Docker is working correctly!"
  else
    echo "[ERROR] Docker check failed: There was an issue running the hello-world container. Please check your Docker installation."
    exit 1
  fi
}

detectDockerComposeCommand() {
  dockerComposeCommand=""
  if command -v docker >/dev/null 2>&1 && command -v docker compose >/dev/null 2>&1; then
    dockerComposeCommand="docker compose"
  elif command -v docker-compose >/dev/null 2>&1; then
    dockerComposeCommand="docker-compose"
  fi
}

checkDockerCompose() {
  detectDockerComposeCommand
  if [ -n "${dockerComposeCommand}" ]; then
    echo "[INFO] Docker compose check passed: Docker compose is working correctly using ${dockerComposeCommand} command!"
  else
    echo "[ERROR] Docker compose check failed: No docker service environment found. Please install docker compose."
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
    echo "[ERROR] Docker disk check failed: ${availableSpaceGB} GB available, ${requiredDiskSpaceGB} GB or more required."
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
    echo "[ERROR] Docker RAM check failed: Only ${totalRamGB} GB available, ${requiredRamGB} GB or more required."
    exit 1
  fi
}

checkDockerCpu() {
  local cpuCores=$(docker info --format '{{.NCPU}}')

  if [ "${cpuCores}" -ge "${requiredCpuCores}" ]; then
    echo "[INFO] Docker CPU check passed: ${cpuCores} cores available."
  else
    echo "[ERROR] Docker CPU check failed: Only ${cpuCores} cores available, ${requiredCpuCores} cores or more required."
    exit 1
  fi
}

testK8s() {
  echo "[INFO] Testing K8s environment..."
  kubectl cluster-info
  if [ $? -eq 0 ]; then
    echo "[INFO] K8s check passed: K8s is working correctly!"
  else
    echo "[ERROR] K8s check failed: There was an issue running kubectl cluster-info, please check you K8s cluster."
    exit 1
  fi
}

checkHelm() {
  if command -v helm >/dev/null 2>&1; then
    echo "[INFO] Helm check passed: Helm is working correctly!"
  else
    echo "[ERROR] Helm check failed: Helm command not found, Please install helm v3."
    exit
  fi
  # check version
  # version will be like:
  # Version:"v3.15.2"
  regex="Version:\"(v[0-9]\.[0-9]+\.[0-9])\""
  version=$(helm version)
  if [[ $version =~ $regex ]]; then
    major_version="${BASH_REMATCH[1]}"
    echo "[INFO] Helm version: ${major_version}"
    if [[ $major_version =~ "v3" ]]; then
      echo "[INFO] Helm check passed."
      return
    else
      echo "[ERROR] Please install helm v3."
      exit
    fi
  fi
}

checkK8sDisk() {
  local nodeName=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
  local availableStorage=$(kubectl get node ${nodeName} -o jsonpath='{.status.allocatable.ephemeral-storage}')

  # Check if the available storage value was retrieved
  if [ -z "${availableStorage}" ]; then
    echo "[ERROR] K8s disk check failed: Could not determine available ephemeral storage on node ${nodeName}."
    exit 1
  fi

  # Convert storage from bytes to GB
  local availableSpaceGB=$((${availableStorage} / 1024 / 1024 / 1024))

  if [ "${availableSpaceGB}" -ge "${requiredDiskSpaceGB}" ]; then
    echo "[INFO] K8s disk check passed: ${availableSpaceGB} GB available on node ${nodeName}."
  else
    echo "[ERROR] K8s disk check failed: Only ${availableSpaceGB} GB available on node ${nodeName}, ${requiredDiskSpaceGB} GB or more required."
    exit 1
  fi
}

checkK8sRam() {
  local nodeName=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
  local totalRamKi=$(kubectl get node ${nodeName} -o jsonpath='{.status.allocatable.memory}' | sed 's/Ki//')
  local totalRamGB=$((${totalRamKi} / 1024 / 1024))

  if [ "${totalRamGB}" -ge "${requiredRamGB}" ]; then
    echo "[INFO] K8s RAM check passed: ${totalRamGB} GB available on node ${nodeName}."
  else
    echo "[ERROR] K8s RAM check failed: Only ${totalRamGB} GB available on node ${nodeName}, ${requiredRamGB} GB or more required."
    exit 1
  fi
}

checkK8sCpu() {
  local nodeName=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
  local cpuCores=$(kubectl get node ${nodeName} -o jsonpath='{.status.allocatable.cpu}' | sed 's/m//')

  if [ "${cpuCores}" -ge "${requiredCpuCores}" ]; then
    echo "[INFO] K8s CPU check passed: ${cpuCores} cores available on node ${nodeName}."
  else
    echo "[ERROR] K8s CPU check failed: Only ${cpuCores} cores available on node ${nodeName}, ${requiredCpuCores} cores or more required."
    exit 1
  fi
}

checkPortsInUse() {
  local usedPorts=()
  local availablePorts=()

  for port in "${requiredPorts[@]}"; do
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
    echo "[ERROR] Please check the ports."
    exit 1
  fi
}

checkRuntime() {
  runtime=""

  echo "[INFO] Checking runtime: ${runtime}"
  # Check if Docker is available
  local dockerAvailable=false
  if command -v docker >/dev/null 2>&1; then
    dockerAvailable=true
  fi

  # Check if kubectl is available
  local k8sAvailable=false
  if command -v kubectl >/dev/null 2>&1; then
    k8sAvailable=true
  fi

  # If no runtime is available
  if [ "${dockerAvailable}" = false ] && [ "${k8sAvailable}" = false ]; then
    echo "[ERROR] No runtime found. Please install Docker or Kubernetes."
    exit 1
  fi

  # If both are available, let user choose
  if [ "${dockerAvailable}" = true ] && [ "${k8sAvailable}" = true ]; then
    read -p "Both Docker and K8s are available. Which runtime would you like to use? [docker/k8s] (default: docker): " choice

    case "$choice" in
    k8s)
      echo "[INFO] Using K8s runtime."
      runtime="k8s"
      ;;
    docker | "") # Empty input defaults to docker
      echo "[INFO] Using Docker runtime."
      runtime="docker"
      ;;
    *)
      echo "[ERROR] Invalid choice. Using default: docker."
      runtime="docker"
      ;;
    esac
    return
  fi

  # If only Docker is available
  if [ "${dockerAvailable}" = true ]; then
    runtime="docker"
    return
  fi

  # If only K8s is available
  if [ "${k8sAvailable}" = true ]; then
    runtime="k8s"
    return
  fi
}

checkCurrentRuntime() {
  runtime=""

  # Check if gravitino-playground is running in Docker
  if command -v docker >/dev/null 2>&1; then
    detectDockerComposeCommand
    if [ -n "${dockerComposeCommand}" ]; then
      if ${dockerComposeCommand} ls | grep -q "${playgroundRuntimeName}"; then
        echo "[INFO] gravitino-playground is running in Docker."
        runtime="docker"
        return
      fi
    fi
  fi

  # Check if gravitino-playground is running in K8s
  if command -v kubectl >/dev/null 2>&1; then
    if kubectl get namespace "${playgroundRuntimeName}" >/dev/null 2>&1; then
      if kubectl -n "${playgroundRuntimeName}" get pods | grep -q "Running"; then
        echo "[INFO] gravitino-playground is running in Kubernetes."
        runtime="k8s"
        return
      fi
    fi
  fi
}

start() {
  echo "[INFO] Starting the playground..."
  echo "[INFO] The playground requires ${requiredCpuCores} CPU cores, ${requiredRamGB} GB of RAM, and ${requiredDiskSpaceGB} GB of disk storage to operate efficiently."

  checkCurrentRuntime
  if [ -n "${runtime}" ]; then
    echo "[ERROR] Playground is already running in ${runtime}. Please stop it first."
    exit 1
  fi

  checkRuntime

  case "${runtime}" in
  k8s)
    testK8s
    checkHelm
    checkK8sDisk
    checkK8sRam
    checkK8sCpu
    ;;
  docker)
    checkPortsInUse
    testDocker
    checkDockerCompose
    checkDockerDisk
    checkDockerRam
    checkDockerCpu
    ;;
  esac

  cd ${playground_dir} || exit 1
  echo "[INFO] Preparing packages..."
  ./init/spark/spark-dependency.sh
  ./init/gravitino/gravitino-dependency.sh
  ./init/jupyter/jupyter-dependency.sh

  case "${runtime}" in
  k8s)
    helm upgrade --install ${playgroundRuntimeName} ./helm-chart/ \
      --create-namespace --namespace ${playgroundRuntimeName} \
      --set projectRoot=$(pwd)
    ;;
  docker)
    logSuffix=$(date +%Y%m%d%H%M%s)
    if [ "$enableRanger" == true ]; then
      ${dockerComposeCommand} -p ${playgroundRuntimeName} -f docker-compose.yaml -f docker-hive-override.yaml up --detach
    else
      ${dockerComposeCommand} -p ${playgroundRuntimeName} up --detach
    fi
    ${dockerComposeCommand} -p ${playgroundRuntimeName} logs -f >${playground_dir}/playground-${logSuffix}.log 2>&1 &
    echo "[INFO] Check log details: ${playground_dir}/playground-${logSuffix}.log"
    ;;
  esac
}

status() {
  checkCurrentRuntime
  if [ -z "${runtime}" ]; then
    echo "[ERROR] Playground is not running."
    exit 1
  fi

  case "${runtime}" in
  k8s)
    kubectl -n ${playgroundRuntimeName} get pods -o wide
    ;;
  docker)
    ${dockerComposeCommand} ps -a
    ;;
  esac
}

stop() {
  checkCurrentRuntime
  if [ -z "${runtime}" ]; then
    echo "[ERROR] Playground is not running."
    exit 1
  fi

  echo "[INFO] Stopping the playground..."

  case "${runtime}" in
  k8s)
    helm uninstall ${playgroundRuntimeName} --namespace ${playgroundRuntimeName}
    ;;
  docker)
    ${dockerComposeCommand} down
    if [ $? -eq 0 ]; then
      echo "[INFO] Playground stopped!"
    fi
    ;;
  esac
}

case "$1" in
start)
  if [["$3" == "--enable-ranger" ]]; then
    enableRanger=true
  else
    enableRanger=false
  fi
  start
  ;;
status)
  status
  ;;
stop)
  stop
  ;;
*)
  echo "Usage: $0 [start|status|stop]"
  exit 1
  ;;
esac
