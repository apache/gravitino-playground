#
# Copyright 2024 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#

echo "Checking if MySQL is runing"
if lsof -Pi :3306 -sTCP:LISTEN -t >/dev/null ; then
    echo "MySQL may allready be running on port 3306. Please shut down PostgreSQL before launching the playground."
    exit
fi