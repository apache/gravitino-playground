#
# Copyright 2024 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#

response=$(curl http://gravitino:8090/api/metalakes/metalake_demo)
if echo "$response" | grep -q "\"code\":0"; then
  true
else
  response=$(curl -X POST -H "Content-Type: application/json" -d '{"name":"metalake_demo","comment":"comment","properties":{}}' http://gravitino:8090/api/metalakes)
  if echo "$response" | grep -q "\"code\":0"; then
    true # Placeholder, do nothing
  else
    echo "Metalake metalake_demo create failed"
    exit 1
  fi
fi


response=$(curl http://gravitino:8090/api/metalakes/metalake_demo/catalogs/catalog_hive)
if echo "$response" | grep -q "\"code\":0"; then
  true
else
  # Create Hive catalog for experience Gravitino service
  response=$(curl -X POST -H "Content-Type: application/json" -d '{"name":"catalog_hive","type":"RELATIONAL", "provider":"hive", "comment":"comment","properties":{"metastore.uris":"thrift://hive:9083", "spark.bypass.spark.sql.hive.metastore.jars":"path", "spark.bypass.spark.sql.hive.metastore.jars.path":"file:///opt/spark/jars/*", "spark.bypass.spark.sql.warehouse.dir":"hdfs://hive:9000/user/hive/warehouse"}}' http://gravitino:8090/api/metalakes/metalake_demo/catalogs)
  if echo "$response" | grep -q "\"code\":0"; then
    true # Placeholder, do nothing
  else
    echo "catalog_hive create failed"
    exit 1
  fi
fi

response=$(curl http://gravitino:8090/api/metalakes/metalake_demo/catalogs/catalog_postgres)
if echo "$response" | grep -q "\"code\":0"; then
  true
else
  # Create Postgresql catalog for experience Gravitino service
  response=$(curl -X POST -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" -d '{ "name":"catalog_postgres", "type":"RELATIONAL", "provider":"jdbc-postgresql", "comment":"comment", "properties":{ "jdbc-url":"jdbc:postgresql://postgresql/db", "jdbc-user":"postgres", "jdbc-password":"postgres", "jdbc-database":"db", "jdbc-driver": "org.postgresql.Driver" } }' http://gravitino:8090/api/metalakes/metalake_demo/catalogs)
  if echo "$response" | grep -q "\"code\":0"; then
    true # Placeholder, do nothing
  else
    echo "catalog_postgres create failed"
    exit 1
  fi
fi

response=$(curl http://gravitino:8090/api/metalakes/metalake_demo/catalogs/catalog_iceberg)
if echo "$response" | grep -q "\"code\":0"; then
  true
else
  # Create Iceberg catalog for experience Gravitino service
  response=$(curl -X POST -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" -d '{ "name":"catalog_iceberg", "type":"RELATIONAL", "provider":"lakehouse-iceberg", "comment":"comment", "properties":{ "uri":"jdbc:mysql://mysql:3306/db", "catalog-backend":"jdbc", "warehouse":"hdfs://hive:9000/user/iceberg/warehouse/", "jdbc-user":"mysql", "jdbc-password":"mysql", "jdbc-driver":"com.mysql.cj.jdbc.Driver"} }' http://gravitino:8090/api/metalakes/metalake_demo/catalogs)
  if echo "$response" | grep -q "\"code\":0"; then
    true # Placeholder, do nothing
  else
    echo "create catalog_iceberg failed"
    exit 1
  fi
fi

