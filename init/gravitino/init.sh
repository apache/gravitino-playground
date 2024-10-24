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
echo "Start to download the jar package of JDBC"
cp /tmp/gravitino/packages/mysql-connector-java-8.0.27.jar /root/gravitino/catalogs/jdbc-mysql/libs/mysql-connector-java-8.0.27.jar
cp /tmp/gravitino/packages/postgresql-42.2.7.jar /root/gravitino/catalogs/jdbc-postgresql/libs/postgresql-42.2.7.jar
cp /root/gravitino/catalogs/jdbc-postgresql/libs/postgresql-42.2.7.jar /root/gravitino/catalogs/lakehouse-iceberg/libs
cp /root/gravitino/catalogs/jdbc-mysql/libs/mysql-connector-java-8.0.27.jar /root/gravitino/catalogs/lakehouse-iceberg/libs

cp /root/gravitino/catalogs/jdbc-postgresql/libs/postgresql-42.2.7.jar /root/gravitino/iceberg-rest-server/libs
cp /root/gravitino/catalogs/jdbc-mysql/libs/mysql-connector-java-8.0.27.jar /root/gravitino/iceberg-rest-server/libs
cp /tmp/gravitino/gravitino.conf /root/gravitino/conf
echo "Finish downloading"
echo "Start the Gravitino Server"
/bin/bash /root/gravitino/bin/gravitino.sh start
