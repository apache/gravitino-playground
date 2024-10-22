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

download_and_verify() {
  local jar_url=$1
  local md5_url=$2
  local download_dir=$3
  local jar_file=$(basename "${jar_url}")
  local md5_file="${jar_file}.md5"

  # If md5 file doesn't exist, then download it
  if [ ! -f "${download_dir}/packages/${md5_file}" ]; then
    curl -L -o "${download_dir}/packages/${md5_file}" "${md5_url}"
  fi

  # If jar file doesn't exist, then download it
  if [ ! -f "${download_dir}/packages/${jar_file}" ]; then
    curl -L -o "${download_dir}/packages/${jar_file}" "${jar_url}"
  fi

  local md5_command
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    md5_command="md5 -q"
  elif [[ "$(uname)" == "Linux" ]]; then
    md5_command="md5sum"
  else
    break
  fi

  # Computer jar file md5
  local_md5=$($md5_command "${download_dir}/packages/${jar_file}" | awk '{ print $1 }')
  # Get md5 from md5 file
  file_md5=$(cat "${download_dir}/packages/${md5_file}")

  # Checksum verification
  if [ "${local_md5}" != "${file_md5}" ]; then
    echo "Use ${md5_file} to MD5 checksum ${jar_file} verification failed, Please delete it."
    exit 1
  fi
}