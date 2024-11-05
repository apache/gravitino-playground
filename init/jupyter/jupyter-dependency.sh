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

jupyter_dir="$(dirname "${BASH_SOURCE-$0}")"
jupyter_dir="$(
  cd "${jupyter_dir}" >/dev/null
  pwd
)"
. "${jupyter_dir}/../common/common.sh"

# Prepare download packages
if [[ ! -d "${jupyter_dir}/packages" ]]; then
  mkdir "${jupyter_dir}/packages"
fi
ls "${jupyter_dir}/packages/" | xargs -I {} rm "${jupyter_dir}/packages/"{}
find "${jupyter_dir}/../spark/packages/" | grep jar | xargs -I {} ln {} "${jupyter_dir}/packages/"

