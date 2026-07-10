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
# Seed the Iceberg REST catalog with demo data (analytics.orders).
# Idempotent: skips when the analytics namespace already exists.

set -u

SPARK_HOME=/opt/spark
SEED_SQL=/tmp/spark/iceberg-seed.sql
AUTH_CONFS="--conf spark.sql.catalog.catalog_rest.rest.auth.type=basic \
  --conf spark.sql.catalog.catalog_rest.rest.auth.basic.username=admin \
  --conf spark.sql.catalog.catalog_rest.rest.auth.basic.password=123"

echo "[seed] Waiting for the Iceberg REST service on gravitino:9001..."
for i in $(seq 1 60); do
  if (echo > /dev/tcp/gravitino/9001) 2>/dev/null; then
    break
  fi
  sleep 5
done
if ! (echo > /dev/tcp/gravitino/9001) 2>/dev/null; then
  echo "[seed] Iceberg REST service not reachable after timeout; skipping seed."
  exit 0
fi

cd "${SPARK_HOME}" || exit 0

if bin/spark-sql ${AUTH_CONFS} -e "SHOW NAMESPACES IN catalog_rest" 2>/dev/null | grep -q "^analytics$"; then
  echo "[seed] analytics namespace already exists; skipping seed."
  exit 0
fi

echo "[seed] Seeding Iceberg demo data..."
bin/spark-sql ${AUTH_CONFS} -f "${SEED_SQL}" 2>&1 | sed 's/^/[seed] /'
echo "[seed] Done."
