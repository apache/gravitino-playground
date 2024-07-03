#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
set -ex

# Because trino-connector must first synchronize a default metalake from the Gravitino server
response=$(trino --execute "SHOW CATALOGS LIKE 'catalog_hive'")
if echo "$response" | grep -q catalog_hive; then
  echo "Gravitino Trino connector has finished synchronizing metadata"
else
  echo "Gravitino Trino connector is not yet finished synchronizing metadata"
  exit 1
fi

exit 0
