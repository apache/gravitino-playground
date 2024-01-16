#
# Copyright 2023 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
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
echo "Finish downloading"
echo "Start the Gravitino Server"
/bin/bash /root/gravitino/bin/gravitino.sh start
