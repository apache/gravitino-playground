#!/usr/bin/env python3
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
# Readiness probe for the Gravitino MCP server.
#
# The MCP streamable-HTTP endpoint rejects a bare GET with 400 because the
# protocol requires an initialize handshake. That 400 is exactly the signal we
# want: it means the server is up and negotiating sessions. So any HTTP response
# counts as ready; only a connection failure (server not listening) is unhealthy.
# Uses only the standard library so no extra packages are needed in the image.

import sys
import urllib.error
import urllib.request

URL = "http://localhost:8000/mcp"

try:
    urllib.request.urlopen(URL, timeout=3)
    sys.exit(0)
except urllib.error.HTTPError:
    # Server answered with an HTTP status (e.g. 400 to a bare GET) => it's up.
    sys.exit(0)
except Exception:
    # Connection refused / DNS / timeout => not ready yet.
    sys.exit(1)
