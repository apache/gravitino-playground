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

jupyter_dir="$(dirname "${BASH_SOURCE-$0}")"
jupyter_dir="$(
  cd "${jupyter_dir}" >/dev/null
  pwd
)"
. "${jupyter_dir}/../common/common.sh"

# Prepare download packages
if [[ ! -d "${jupyter_dir}/packages" ]]; then
  mkdir "${jupyter_dir}/packages"
  find "${jupyter_dir}/../spark/packages/" | grep jar | xargs -I {} ln {} "${jupyter_dir}/packages/"
fi

FLINK_HIVE_CONNECTOR_JAR="https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hive-2.3.10_2.12/1.20.0/flink-sql-connector-hive-2.3.10_2.12-1.20.0.jar"
FLINK_HIVE_CONNECTOR_MD5="${FLINK_HIVE_CONNECTOR_JAR}.md5"
download_and_verify "${FLINK_HIVE_CONNECTOR_JAR}" "${FLINK_HIVE_CONNECTOR_MD5}" "${script_dir}/packages"

GRAVITINO_FLINK_JAR="https://repo1.maven.org/maven2/org/apache/gravitino/gravitino-flink-1.18_2.12/0.6.1-incubating/gravitino-flink-1.18_2.12-0.6.1-incubating.jar"
GRAVITINO_FLINK_MD5="${GRAVITINO_FLINK_JAR}.md5"
download_and_verify "${GRAVITINO_FLINK_JAR}" "${GRAVITINO_FLINK_MD5}" "${script_dir}/packages"

GRAVITINO_FLINK_CONNECTOR_RUNTIME_JAR="https://repo1.maven.org/maven2/org/apache/gravitino/gravitino-flink-connector-runtime-1.18_2.12/0.6.1-incubating/gravitino-flink-connector-runtime-1.18_2.12-0.6.1-incubating.jar"
GRAVITINO_FLINK_CONNECTOR_RUNTIME_MD5="${GRAVITINO_FLINK_CONNECTOR_RUNTIME_JAR}.md5"
download_and_verify "${GRAVITINO_FLINK_CONNECTOR_RUNTIME_JAR}" "${GRAVITINO_FLINK_CONNECTOR_RUNTIME_MD5}" "${script_dir}/packages"