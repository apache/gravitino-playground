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

# remove command line `tail -f /dev/null` in the `/tmp/start-ranger-services.sh`
sed -i '$d' /tmp/start-ranger-services.sh
sed -i '$d' /tmp/start-ranger-services.sh
/tmp/start-ranger-services.sh

# https://ranger.apache.org/apidocs/resource_PublicAPIsv2.html#resource_PublicAPIsv2_createService_POST
sleep 5s
curl -iv -u admin:rangerR0cks! -d @/tmp/ranger/hiveDev.json -H "Content-Type: application/json" -X POST http://127.0.0.1:6080/service/public/v2/api/service
curl -iv -u admin:rangerR0cks! -d @/tmp/ranger/hdfsDev.json -H "Content-Type: application/json" -X POST http://127.0.0.1:6080/service/public/v2/api/service
curl -iv -u admin:rangerR0cks! -H "Content-Type: application/json" -X DELETE http://localhost:6080/service/plugins/policies/1
curl -iv -u admin:rangerR0cks! -H "Content-Type: application/json" -X DELETE http://localhost:6080/service/plugins/policies/3
curl -iv -u admin:rangerR0cks! -H "Content-Type: application/json" -X DELETE http://localhost:6080/service/plugins/policies/4
tail -f /dev/null
