 #
 # Copyright 2023 Datastrato Pvt Ltd.
 # This software is licensed under the Apache License version 2.
 #
set -x
nohup sh /usr/local/sbin/start.sh &

counter=0
while [ $counter -le 60 ]; do
  counter=$((counter + 1))
  hive_ready=$(hive -e "show databases;" 2>&1 | grep "OK" | wc -l)
  if [ "$hive_ready" -eq 0 ];
  then
    echo "Wait for the initialization of services"
    sleep 20;
  else
    echo "Import the data of the Hive warehouse"
    hive -f /tmp/hive/init.sql
    echo "Import ends"
    break
  fi
done
if [ $counter -ge 60 ]; then
  exit 1
fi

# persist the container
tail -f /dev/null