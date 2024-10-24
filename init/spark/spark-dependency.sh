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
spark_dir="$(dirname "${BASH_SOURCE-$0}")"
spark_dir="$(
  cd "${spark_dir}" >/dev/null
  pwd
)"
. "${spark_dir}/../common/common.sh"

# Prepare download packages
if [[ ! -d "${spark_dir}/packages" ]]; then
  mkdir -p "${spark_dir}/packages"
fi

ICEBERG_SPARK_RUNTIME_JAR="https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.4_2.12/1.5.2/iceberg-spark-runtime-3.4_2.12-1.5.2.jar"
ICEBERG_SPARK_RUNTIME_MD5="${ICEBERG_SPARK_RUNTIME_JAR}.md5"
download_and_verify "${ICEBERG_SPARK_RUNTIME_JAR}" "${ICEBERG_SPARK_RUNTIME_MD5}" "${spark_dir}"

GRAVITINO_SPARK_CONNECTOR_RUNTIME_JAR="https://repo1.maven.org/maven2/org/apache/gravitino/gravitino-spark-connector-runtime-3.4_2.12/0.6.1-incubating/gravitino-spark-connector-runtime-3.4_2.12-0.6.1-incubating.jar"
GRAVITINO_SPARK_CONNECTOR_RUNTIME_MD5="${GRAVITINO_SPARK_CONNECTOR_RUNTIME_JAR}.md5"
download_and_verify "${GRAVITINO_SPARK_CONNECTOR_RUNTIME_JAR}" "${GRAVITINO_SPARK_CONNECTOR_RUNTIME_MD5}" "${spark_dir}"

MYSQL_CONNECTOR_JAVA_JAR="https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar"
MYSQL_CONNECTOR_JAVA_MD5="${MYSQL_CONNECTOR_JAVA_JAR}.md5"
download_and_verify "${MYSQL_CONNECTOR_JAVA_JAR}" "${MYSQL_CONNECTOR_JAVA_MD5}" "${spark_dir}"

KYUUBI_SPARK_AUTHZ_SHADED_JAR="https://repo1.maven.org/maven2/org/apache/kyuubi/kyuubi-spark-authz-shaded_2.12/1.9.2/kyuubi-spark-authz-shaded_2.12-1.9.2.jar"
KYUUBI_SPARK_AUTHZ_SHADED_MD5="${KYUUBI_SPARK_AUTHZ_SHADED_JAR}.md5"
download_and_verify "${KYUUBI_SPARK_AUTHZ_SHADED_JAR}" "${KYUUBI_SPARK_AUTHZ_SHADED_MD5}" "${spark_dir}"
