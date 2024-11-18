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
gravitino_dir="$(dirname "${BASH_SOURCE-$0}")"
gravitino_dir="$(
  cd "${gravitino_dir}" >/dev/null
  pwd
)"
. "${gravitino_dir}/../common/common.sh"

if [[ ! -d "${gravitino_dir}/packages" ]]; then
  mkdir -p "${gravitino_dir}/packages"
fi
# Prepare download packages
MYSQL_CONNECTOR_JAVA_JAR="https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar"
MYSQL_CONNECTOR_JAVA_MD5="${MYSQL_CONNECTOR_JAVA_JAR}.md5"
download_and_verify "${MYSQL_CONNECTOR_JAVA_JAR}" "${MYSQL_CONNECTOR_JAVA_MD5}" "${gravitino_dir}"

POSTGRESQL_JAR="https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.7/postgresql-42.2.7.jar"
POSTGRESQL_MD5="${POSTGRESQL_JAR}.md5"
download_and_verify "${POSTGRESQL_JAR}" "${POSTGRESQL_MD5}" "${gravitino_dir}"
