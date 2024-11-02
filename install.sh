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

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker before proceeding."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose is not installed. Please install Docker Compose before proceeding."
    exit 1
fi

# Download the source code for gravitino-playground directly from GitHub.
echo "Downloading gravitino-playground..."
curl -L -O https://github.com/apache/gravitino-playground/archive/refs/heads/main.zip
unzip main.zip

while true; do
    # Prompt the user
    read -p "Would you like to run gravitino-playground immediately? [Y/N]: " choice

    # Convert choice to uppercase using `tr`
    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')

    if [[ "$choice" == "Y" ]]; then
        echo "Starting gravitino-playground..."
        cd ./gravitino-playground-main && ./playground.sh start
        break
    elif [[ "$choice" == "N" ]]; then
        echo "Download complete. You can start gravitino-playground later by running './playground.sh start'."
        break
    else
        echo "Invalid input. Please enter Y or N."
    fi
done
