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
  *)
    components=$@
esac

cd ${playground_dir}

./init/spark/spark-dependency.sh
./init/gravitino/gravitino-dependency.sh

docker-compose down
logSuffix=$(date +%Y%m%d%H%m%s)
docker-compose up ${components} --detach
docker compose logs -f > ${playground_dir}/playground-${logSuffix}.log 2>&1 &
echo "Check log details: tail -f ${playground_dir}/playground-${logSuffix}.log"
echo "Check containers status: docker-compose ps"
echo "Clean Docker containers: docker-compose down"