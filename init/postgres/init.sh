#
# Copyright 2024 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#

echo "Checking if Postgres is runing"
if lsof -Pi :5432 -sTCP:LISTEN -t >/dev/null ; then
    echo "Postgres may allready be running on port 5432. Please shut down Postgres before launching the playground."
    exit -1
fi