#
# Copyright 2023 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#

# Since trino-connector needs to connect Gravitino service, get the default metalake
# Create metalake
response=$(curl -X POST -H "Content-Type: application/json" -d '{"name":"metalake_demo","comment":"comment","properties":{}}' http://gravitino:8090/api/metalakes)
if echo "$response" | grep -q "\"code\":0"; then
  true # Placeholder, do nothing
else
  echo "Metalake metalake_demo create failed"
  exit 1
fi

# Check metalake if created
response=$(curl -X GET -H "Content-Type: application/json" http://gravitino:8090/api/metalakes)
if echo "$response" | grep -q "metalake_demo"; then
  echo "Metalake metalake_demo successfully created"
else
  echo "Metalake metalake_demo create failed"
  exit 1
fi

# Create Hive catalog for experience Gravitino service
curl -X POST -H "Content-Type: application/json" -d '{"name":"catalog_demo","type":"RELATIONAL", "provider":"hive", "comment":"comment","properties":{"metastore.uris":"thrift://hive:9083"}}' http://gravitino:8090/api/metalakes/metalake_demo/catalogs


# Check catalog if created
response=$(curl -X GET -H "Content-Type: application/json" http://gravitino:8090/api/metalakes/metalake_demo/catalogs)
if echo "$response" | grep -q "catalog_demo"; then
  echo "Catalog catalog_demo successfully created"
else
  echo "Catalog catalog_demo create failed"
  exit 1
fi

# Create Postgresql catalog for experience Gravitino service
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" -d '{
    "name":"catalog_pg1",
    "type":"RELATIONAL",
    "provider":"jdbc-postgresql",
    "comment":"comment",
    "properties":{
        "jdbc-url":"jdbc:postgresql://postgresql/db",
        "jdbc-user":"postgres",
        "jdbc-password":"postgres",
        "jdbc-database":"db",
        "gravitino.bypass.driverClassName":"org.postgresql.Driver"
    }
}' http://gravitino:8090/api/metalakes/metalake_demo/catalogs

response=$(curl -X GET -H "Content-Type: application/json" http://gravitino:8090/api/metalakes/metalake_demo/catalogs)
if echo "$response" | grep -q "catalog_pg1"; then
  echo "Catalog catalog_pg1 successfully created"
else
  echo "Catalog catalog_pg1 create failed"
  exit 1
fi

/etc/trino/update-trino-conf.sh
nohup /usr/lib/trino/bin/run-trino &

counter=0
while [ $counter -le 240 ]; do
  counter=$((counter + 1))
  trino_ready=$(trino --execute  "SHOW CATALOGS LIKE 'metalake_demo.catalog_demo'"| grep "metalake_demo.catalog_demo" | wc -l)
  if [ "$trino_ready" -eq 0 ];
  then
    echo "Wait for the initialization of services"
    sleep 5;
  else
    echo "Import the data of the Hive warehouse"
    trino < /tmp/trino/init.sql
    echo "Import ends"

    # persist the container
    tail -f /dev/null
  fi
done
exit 1
