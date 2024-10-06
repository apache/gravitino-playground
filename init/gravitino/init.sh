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
echo "Downloading the JDBC drivers for MySQL and PostgreSQL"
if which wget >/dev/null ; then
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar -O /root/gravitino/catalogs/jdbc-mysql/libs/mysql-connector-java-8.0.27.jar
    wget https://jdbc.postgresql.org/download/postgresql-42.7.0.jar -O /root/gravitino/catalogs/jdbc-postgresql/libs/postgresql-42.7.0.jar
elif which curl >/dev/null ; then
    curl https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar > /root/gravitino/catalogs/jdbc-mysql/libs/mysql-connector-java-8.0.27.jar
    curl https://jdbc.postgresql.org/download/postgresql-42.7.0.jar > /root/gravitino/catalogs/jdbc-postgresql/libs/postgresql-42.7.0.jar
else
    echo "Cannot download JDBC driver, as neither wget nor curl is available."
fi
cp /root/gravitino/catalogs/jdbc-postgresql/libs/postgresql-42.7.0.jar /root/gravitino/catalogs/lakehouse-iceberg/libs
cp /root/gravitino/catalogs/jdbc-mysql/libs/mysql-connector-java-8.0.27.jar /root/gravitino/catalogs/lakehouse-iceberg/libs

cp /root/gravitino/catalogs/jdbc-postgresql/libs/postgresql-42.7.0.jar /root/gravitino/iceberg-rest-server/libs
cp /root/gravitino/catalogs/jdbc-mysql/libs/mysql-connector-java-8.0.27.jar /root/gravitino/iceberg-rest-server/libs
cp /tmp/gravitino/gravitino.conf /root/gravitino/conf
echo "Finish downloading"
echo "Start the Gravitino Server"
/bin/bash /root/gravitino/bin/gravitino.sh start
