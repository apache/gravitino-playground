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

# remove command `tail -f /dev/null` in `/usr/local/sbin/start.sh`, so we can run subsequent commands
sed -i -E 's/tail -f \/dev\/null/\s/g' /usr/local/sbin/start.sh

cp /tmp/hive/core-site.xml /tmp/hadoop-conf
/bin/bash /usr/local/sbin/start.sh
hdfs dfs -mkdir -p /user/gravitino
hdfs dfs -mkdir -p /user/iceberg/warehouse
useradd -g hdfs lisa
useradd -g hdfs manager
useradd -g hdfs anonymous
hdfs dfs -chmod 777 /user/iceberg/warehouse/
tail -f /dev/null
