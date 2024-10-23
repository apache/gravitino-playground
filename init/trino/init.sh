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

sh /tmp/common/init_metalake_catalog.sh

/etc/trino/update-trino-conf.sh
nohup /usr/lib/trino/bin/run-trino &

counter=0
while [ $counter -le 240 ]; do
  counter=$((counter + 1))
  trino_ready=$(trino --execute "SHOW CATALOGS LIKE 'catalog_hive'" | grep "catalog_hive" | wc -l)
  if [ "$trino_ready" -eq 0 ]; then
    echo "Wait for the initialization of services"
    sleep 5
  else
    echo "Import the data of the Hive warehouse"
    trino </tmp/trino/init.sql
    echo "Import ends"

    # persist the container
    tail -f /dev/null
  fi
done
exit 1
