#
# Copyright 2024 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#
mkdir -p /opt/spark/conf
cp /tmp/spark/spark-defaults.conf /opt/spark/conf
wget https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.4_2.12/1.3.1/iceberg-spark-runtime-3.4_2.12-1.3.1.jar  -O /opt/spark/jars/iceberg-spark-runtime-3.4_2.12-1.3.1.jar
tail -f /dev/null
