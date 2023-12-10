#
# Copyright 2023 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#

/etc/trino/update-trino-conf.sh && /usr/lib/trino/bin/run-trino
trino < /tmp/trino/init.sql
