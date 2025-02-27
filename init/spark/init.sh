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

echo 'Copying config files...'

mkdir -p /opt/spark/conf

cp /tmp/spark/spark-defaults.conf /opt/spark/conf
cp /tmp/spark/spark-env.sh /opt/spark/conf

echo 'Done.'

echo 'Copying jars for spark...'

cp -v /tmp/spark/packages/*.jar /opt/spark/jars/

echo 'Done.'

echo 'Running init_metalake_catalog.sh...'

sh /tmp/common/init_metalake_catalog.sh
if [ $? -ne 0 ]; then
  echo 'Failed to initialize metalake catalog.'
  exit 1
fi

echo 'Done.'

echo 'Spark container Initialization completed.'

tail -f /dev/null
