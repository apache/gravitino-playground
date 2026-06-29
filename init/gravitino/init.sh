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

# Detect Gravitino installation path (1.3+ uses /opt/gravitino, older uses /root/gravitino)
if [ -d "/opt/gravitino/bin" ]; then
  GRAVITINO_HOME="/opt/gravitino"
else
  GRAVITINO_HOME="/root/gravitino"
fi

echo "Using GRAVITINO_HOME=${GRAVITINO_HOME}"

echo "Start to copy JDBC driver jars"
# Copy JDBC drivers to catalog libs (1.3 image already has them via entrypoint symlinks,
# but we ensure they exist for both old and new images)
if [ -f /tmp/gravitino/packages/mysql-connector-java-8.0.27.jar ]; then
  cp -f /tmp/gravitino/packages/mysql-connector-java-8.0.27.jar ${GRAVITINO_HOME}/catalogs/jdbc-mysql/libs/ 2>/dev/null || true
fi
if [ -f /tmp/gravitino/packages/postgresql-42.2.7.jar ]; then
  cp -f /tmp/gravitino/packages/postgresql-42.2.7.jar ${GRAVITINO_HOME}/catalogs/jdbc-postgresql/libs/ 2>/dev/null || true
fi

# Copy JDBC drivers to lakehouse-iceberg and iceberg-rest-server libs
for target_dir in "${GRAVITINO_HOME}/catalogs/lakehouse-iceberg/libs" "${GRAVITINO_HOME}/iceberg-rest-server/libs"; do
  if [ -d "${target_dir}" ]; then
    cp -f /tmp/gravitino/packages/mysql-connector-java-8.0.27.jar "${target_dir}/" 2>/dev/null || true
    cp -f /tmp/gravitino/packages/postgresql-42.2.7.jar "${target_dir}/" 2>/dev/null || true
  fi
done

# Copy gravitino.conf
cp /tmp/gravitino/gravitino.conf ${GRAVITINO_HOME}/conf/gravitino.conf

# If auth is enabled, remove the PassThroughAuthorizer configuration
if [ "${GRAVITINO_AUTH_ENABLE}" == "true" ]; then
  echo "Auth is enabled, removing PassThroughAuthorizer configuration..."
  sed -i '/gravitino.authorization.impl = org.apache.gravitino.server.authorization.PassThroughAuthorizer/d' ${GRAVITINO_HOME}/conf/gravitino.conf
fi

# Ensure jq is installed; needed by job scripts
if ! command -v jq >/dev/null 2>&1; then
  echo "Installing jq..."
  timeout 60 apt-get update -qq 2>/dev/null && timeout 60 apt-get install -y -qq jq 2>/dev/null || echo "WARN: Failed to install jq" >&2
fi

# Resolve hive hostname to IP address and add to /etc/hosts
IP=$(getent hosts hive | awk '{print $1; exit}')
if [ -z "$IP" ]; then
  echo "Failed to resolve hostname 'hive'" >&2
  exit 1
fi
echo "$IP hive" >> /etc/hosts

echo "Finish setup"
echo "Start the Gravitino Server"
/bin/bash ${GRAVITINO_HOME}/bin/gravitino.sh start &
sleep 3
tail -f ${GRAVITINO_HOME}/logs/gravitino-server.log