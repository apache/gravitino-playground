#!/bin/bash

# install trino cli
if [[ -n $(trino --version) ]]; then
  echo "Trino client installed"
else
  wget https://repo1.maven.org/maven2/io/trino/trino-cli/448/trino-cli-448-executable.jar -O /tmp/trino
  sudo cp /tmp/trino /usr/local/bin/trino
  sudo chmod +x /usr/local/bin/trino
  trino --version
fi

# check trino connection
i=0
while [[ ! $(trino --server http://127.0.0.1:18080 -f ./trino-test.sql) && $i -le 200 ]]; do
  sleep 5
  i=$(expr $i + 1)
done

# check trino catalog loaded
j=0
rm -rf /tmp/playground-log/trino-test.sql.log
trino --server http://127.0.0.1:18080 -f ./trino-test.sql >>/tmp/playground-log/trino-test.sql.log
while [[ -n $(diff ./trino-test.sql.out /tmp/playground-log/trino-test.sql.log) && $j -le 200 ]]; do
  sleep 5
  j=$(expr $j + 1)
  rm -rf /tmp/playground-log/trino-test.sql.log
  trino --server http://127.0.0.1:18080 -f ./trino-test.sql >>/tmp/playground-log/trino-test.sql.log
done

# run sql and check results
rm -rf /tmp/trino-simple.sql.log
trino --server http://127.0.0.1:18080 -f ./trino-simple.sql >>/tmp/trino-simple.sql.log
if [[ -z $(diff ./trino-simple.sql.out /tmp/trino-simple.sql.log) ]]; then
  echo "run trino-simple.sql successfully"
else
  echo "run trino-simple.sql failed"
  exit 1
fi

i=0
num=$(trino --server http://127.0.0.1:18080 -f ./trino-cross-catalog.sql | wc -l)
while [[ ${num} -lt 42 && $i -le 200 ]]; do
  sleep 5
  i=$(expr $i + 1)
  num=$(trino --server http://127.0.0.1:18080 -f ./trino-cross-catalog.sql | wc -l)
done
rm -rf /tmp/playground-log/trino-cross-catalog.sql.log
trino --server http://127.0.0.1:18080 -f ./trino-cross-catalog.sql | sort >>/tmp/playground-log/trino-cross-catalog.sql.log
if [[ -z $(diff ./trino-cross-catalog.sql.out /tmp/playground-log/trino-cross-catalog.sql.log) ]]; then
  echo "run trino-cross-catalog.sql successfully"
else
  echo "run trino-cross-catalog.sql failed"
  exit 1
fi

for fileName in $(docker exec playground-spark ls /opt/spark/jars/ | grep gravitino-spark-connector); do
  docker exec playground-spark rm -rf /opt/spark/jars/${fileName}
done
aws s3 cp s3://gravitino-spark-connector/3.4_2.12/ /tmp/gravitino-spark-connector/3.4_2.12 --recursive
docker cp /tmp/gravitino-spark-connector/3.4_2.12/gravitino-spark-connector-*.jar playground-spark:/opt/spark/jars/
rm -rf /tmp/playground-log/spark-simple.sql.log /tmp/playground-log/union-spark.sql.log
docker cp ./union.sql playground-spark:/opt/spark/work-dir/
docker cp ./spark-simple.sql playground-spark:/opt/spark/work-dir/
sleep 2
docker exec playground-spark bash /opt/spark/bin/spark-sql -f spark-simple.sql
if [[ $? == 0 ]]; then
  echo "run spark-simple.sql successfully"
else
  echo "run spark-simple.sql failed"
  exit 1
fi
docker exec playground-spark bash /opt/spark/bin/spark-sql -f union.sql | sort >>/tmp/playground-log/union-spark.sql.log
if [[ -z $(diff ./union-spark.sql.out /tmp/playground-log/union-spark.sql.log) ]]; then
  echo "run union.sql in spark successfully"
else
  echo "run union.sql in spark failed"
  exit 1
fi

i=0
num=$(trino --server http://127.0.0.1:18080 -f ./union.sql | wc -l)
while [[ ${num} -lt 12 && $i -le 200 ]]; do
  sleep 5
  i=$(expr $i + 1)
  num=$(trino --server http://127.0.0.1:18080 -f ./union.sql | wc -l)
done
rm -rf /tmp/playground-log/union.sql.log
trino --server http://127.0.0.1:18080 -f ./union.sql | sort >>/tmp/playground-log/union.sql.log
if [[ -z $(diff ./union-trino.sql.out /tmp/playground-log/union.sql.log) ]]; then
  echo "run union.sql in trino successfully"
else
  echo "run union.sql in trino failed"
  exit 1
fi
