#
# Copyright 2024 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#

sed -i '$d' /usr/local/sbin/start.sh
sed -i '$d' /usr/local/sbin/start.sh
/bin/bash /usr/local/sbin/start.sh
hdfs dfs -mkdir /user/iceberg/
hdfs dfs -mkdir /user/iceberg/warehouse
hdfs dfs -chmod 777 /user/iceberg/warehouse/
tail -f /dev/null