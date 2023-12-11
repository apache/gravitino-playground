#!/bin/bash
#
# Copyright 2023 Datastrato Pvt Ltd.
# This software is licensed under the Apache License version 2.
#
set -ex

response=$(curl -X GET -H "Content-Type: application/json" http://127.0.0.1:8090/api/version)

if echo "$response" | grep -q "\"code\":0"; then
  exit 0
else
  echo "Metalake metalake_demo create failed"
  exit 1
fi
