<!--
  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
-->

## Overview

Apache Gravitino is a federated metadata catalog: it presents many different data systems, Hive, Iceberg, relational databases, object storage, files, as one governed namespace, so a single engine or agent can discover and query across all of them, with access control and audit applied at the source rather than bolted onto each tool.

This playground is a complete, runnable environment for seeing that in action. It brings up `Hive`, `HDFS`, `Trino`, `Spark`, `MySQL`, `PostgreSQL`, `Ranger`, `Jupyter`, `Prometheus`, `Grafana`, and a `Gravitino` server, all wired together, so you can join data across catalogs, govern it with roles and policies, and let an AI agent reason over the same governed metadata through the [Model Context Protocol](#mcp-servers).

Depending on your network and computer, startup takes 3-5 minutes. Once it is running, open [http://localhost:8090](http://localhost:8090) for the Gravitino Web UI. The quickest way to see what the playground does is the [Jupyter notebooks](#jupyter-notebooks).

## Getting Started

You need **Docker** installed and running. Docker Desktop (macOS and Windows) or Docker Engine (Linux) both include Docker Compose, which the playground uses to bring up the services, so there is nothing separate to install for Compose. Get Docker from [docs.docker.com/get-docker](https://docs.docker.com/get-docker/). **Git** is optional, needed only if you clone the repository instead of using the one-line installer.

The playground needs roughly 2 CPU cores, 8 GB RAM, and 25 GB of free disk. See [System requirements](#system-requirements) for details.

There are two ways to get the playground. Use one or the other, not both.

### Option 1: One-Command Install and Launch

Downloads the playground and starts it in a single step:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/apache/gravitino-playground/HEAD/install.sh)"
```

### Option 2: Clone and Launch with Git

```bash
git clone https://github.com/apache/gravitino-playground.git
cd gravitino-playground
./playground.sh start
```

### Start Options

```bash
./playground.sh start                 # full stack, MCP servers on by default
./playground.sh start --disable-mcp   # bring the stack up without the MCP servers
./playground.sh start --enable-ranger # add Ranger authorization
./playground.sh start --enable-auth   # enable authentication
```

`--enable-auth` and `--enable-ranger` cannot be combined.

### Playground Management

Run these from the playground directory, whichever option you used to install it (`gravitino-playground` for git, `gravitino-playground-main` for the installer).

#### Check Status

```bash
./playground.sh status
```

When all containers are healthy, open the Gravitino Web UI at <http://localhost:8090>.

#### Stop and Resume

```bash
./playground.sh stop
```

`stop` halts the containers but keeps them in place, so the next `./playground.sh start` resumes them in seconds instead of re-running initialization and health checks. All data is preserved: Gravitino metadata in the `data` directory of this repo, and MySQL, PostgreSQL, HDFS, and Ranger contents in named Docker volumes.

#### Tear Down

```bash
./playground.sh down
```

`down` removes the containers and network (data in named volumes is still kept). Use this when you want a clean rebuild, for example after changing an init script or bumping an image tag. To remove everything including data and start completely fresh:

```bash
docker compose -p gravitino-playground down -v
rm -rf data
```

## Jupyter Notebooks

The notebooks are the quickest way to see what the playground does, and for many people they are all you need. Open Jupyter at [http://localhost:18888](http://localhost:18888), open a notebook, and run the cells top to bottom.

### AI

- **`gravitino-mcp-demo.ipynb`** connects to the Gravitino MCP server, lists the tools Gravitino exposes, seeds governance tags, walks a governed table, and (with an LLM API key) answers plain-language questions by calling the tools itself. See the [MCP Servers](#mcp-servers) section.
- **`gravitino_llamaIndex_demo.ipynb`** is a retrieval-augmented generation demo that treats Gravitino as a unified data source. Structured city statistics live in MySQL (a relational catalog) and city descriptions live in PDF files (a fileset catalog); a single natural-language question is answered from both by joining a SQL index over the table with a vector index over the documents. It requires an `OPENAI_API_KEY` from an account with available credit. Set it the same way as the Anthropic key, in a `.env` file in the repo root, which Compose passes through to Jupyter (otherwise the notebook prompts for it at runtime):

  ```bash
  echo 'OPENAI_API_KEY=sk-...' >> .env   # do not commit this file
  ```

### Query Engines

- **`gravitino-trino-example.ipynb`** drives Trino against Gravitino-managed catalogs, showing how metadata operations flow through Gravitino rather than a per-engine catalog.
- **`gravitino-spark-trino-example.ipynb`** writes with Spark and reads the same table with Trino, showing one Gravitino-managed metadata layer serving both engines interchangeably.

### Governance and Data Access

- **`gravitino-access-control-example.ipynb`** demonstrates Ranger-backed authorization: it authorizes a Hive catalog through Gravitino, then uses Spark to show operations allowed or denied per user, with the results visible in the Ranger admin UI. Requires `--enable-ranger` (see [Ranger Authorization](#ranger-authorization)). For Gravitino's own built-in access control, without Ranger, see [Access Control](#access-control) under Iceberg REST Service.
- **`gravitino-fileset-example.ipynb`** manages the fileset metadata lifecycle: creating a fileset catalog and schema, registering managed and external filesets, and observing how each behaves in HDFS.
- **`gravitino-gvfs-example.ipynb`** reads unstructured data (PDFs) through the Gravitino Virtual File System, so file access goes through a governed fileset path rather than a raw storage location. No LLM required.

## MCP Servers

The playground runs two [Model Context Protocol](https://modelcontextprotocol.io) servers, so an AI agent can both reason over governed metadata and run queries against it. Both are on by default and share the same toggle: start with `--disable-mcp` to leave them out.

- **Gravitino MCP server** (port 8000) exposes Gravitino metadata: catalogs, schemas, tables, tags, and policies, through a uniform tool surface. An agent connected here does not get raw files; every call is subject to Gravitino's authorization and recorded in its audit log. For more information, see the [Gravitino MCP server](https://gravitino.apache.org/docs/latest/gravitino-mcp-server/) documentation.
- **Trino MCP server** (port 8001, [tuannvm/mcp-trino](https://github.com/tuannvm/mcp-trino)) gives an agent a natural-language SQL path to the playground's Trino coordinator. Where the Gravitino server exposes metadata, the Trino server executes queries, so an agent answers analytical questions ("who is the employee with the largest total sales?") by generating SQL and running it across the federated catalogs. It exposes tools to list catalogs, schemas, and tables, describe and explain queries, and execute SQL.

The two take different paths to the data. The Gravitino server serves governed metadata, with every call subject to Gravitino's authorization. The Trino server executes SQL against the coordinator, and the data it reads through Gravitino-managed catalogs is governed at the source, so with `--enable-auth` or `--enable-ranger` those reads are subject to the same authorization. The Trino server connects as a single fixed Trino user, so it does not distinguish one MCP caller from another.

Both servers speak streamable HTTP, the Gravitino server at `http://localhost:8000/mcp` and the Trino server at `http://localhost:8001/mcp`.

### Try It with an Agent (Recommended)

The `gravitino-mcp-demo.ipynb` notebook is the fastest way to see the value. Open Jupyter at [http://localhost:18888](http://localhost:18888), open the notebook, and run the cells. It connects to the MCP server, lists the tools Gravitino offers, seeds a couple of tags, walks a governed table, and, if an LLM API key is available, lets you ask questions in plain language that the agent answers by calling the tools itself.

The agentic section never stores a key in the notebook. If `ANTHROPIC_API_KEY` is set in the environment it is used automatically; otherwise the notebook prompts for one at runtime (masked, kept only in the kernel session), so each person can supply their own. Leaving the prompt blank skips the agentic cells and runs everything else.

To pre-set the key so there is no prompt (handy for your own iteration), put it in a `.env` file in the repo root, which Compose reads automatically:

```bash
echo 'ANTHROPIC_API_KEY=sk-ant-...' >> .env   # do not commit this file
```

### Connect with Claude Code

[Claude Code](https://docs.claude.com/en/docs/claude-code) speaks the streamable HTTP transport natively, so it connects to either server with a single command. No proxy, stdio bridge, or TLS certificate is needed.

In the commands below, use `localhost` if Claude Code runs on the same host as the playground, or the playground host's address (for example `http://<playground-host>:8000/mcp`) if it runs elsewhere. Both servers must point at the same place.

Register the Gravitino MCP server:

```bash
claude mcp add --transport http gravitino http://localhost:8000/mcp
```

Register the Trino MCP server:

```bash
claude mcp add --transport http trino http://localhost:8001/mcp
```

Claude Code loads MCP servers at startup, so restart it (or run `/mcp`) after adding a server. `/mcp` shows connection status and lets you browse each server's tools. A healthy server appears connected and lists its tools; a failure there points at reachability rather than Claude Code.

By default Claude Code prompts before every MCP tool call. To approve a whole server once instead of per tool, run `/permissions` and add a wildcard rule:

```
mcp__gravitino__*
mcp__trino__*
```

You can also set these without opening Claude Code by editing its settings file directly. Use `~/.claude/settings.json` to apply the rules everywhere, or `<project-dir>/.claude/settings.json` to scope them to the directory the servers were registered under. Add a `permissions.allow` array, merging into any existing settings rather than overwriting them:

```json
{
  "permissions": {
    "allow": [
      "mcp__gravitino__*",
      "mcp__trino__*"
    ]
  }
}
```

Claude Code reads the file at startup, so edit it before launching (or restart afterward). Validate the JSON before starting, since a syntax error stops the whole file from loading: `python3 -m json.tool ~/.claude/settings.json`.

With both servers connected, ask questions in plain language and Claude Code calls the tools itself. The Gravitino server answers metadata and governance questions ("which tables carry a PII tag?"), and the Trino server runs analytical queries that federate across catalogs ("who is the employee with the largest total sales?"), joining `catalog_hive.sales` and `catalog_postgres.hr` the same way the [Trino federation example](#query-across-catalogs) does.

### Connect with Claude Desktop

Claude Desktop does not read HTTP MCP URLs from its config file directly, and its custom-connector UI opens connections from a cloud service that cannot reach a local or private-network playground. The way to connect Desktop to the playground is the [`mcp-remote`](https://www.npmjs.com/package/mcp-remote) stdio bridge: a small local process that Desktop launches, which speaks stdio to Desktop and HTTP to the playground.

You need [Node.js](https://nodejs.org) 18 or higher installed on the machine running Claude Desktop, since the bridge runs through `npx`.

Open the config file from **Settings -> Developer -> Edit Config** (which creates it if needed), or edit it directly:

- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`

Add both servers under `mcpServers`, merging into any existing entries. Use `localhost` if Desktop runs on the same host as the playground, or the playground host's address otherwise:

```json
{
  "mcpServers": {
    "gravitino": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:8000/mcp", "--allow-http"]
    },
    "trino": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:8001/mcp", "--allow-http"]
    }
  }
}
```

Then fully quit Claude Desktop (quit the app, not just close the window) and reopen it so the new config loads. The gravitino and trino tools then appear in the connectors menu, and you can ask questions in plain language the same way as with Claude Code.

A few details specific to Desktop:

- **`--allow-http` is required for a plain-HTTP playground.** `mcp-remote` refuses non-HTTPS URLs unless the host is `localhost` or the flag is set. The playground runs without TLS, so the flag is needed whenever you point at it by address rather than `localhost`. It signals that unencrypted transport is acceptable, which is fine for a local playground you control and not for anything carrying real credentials.
- **When authentication is off (the default), send no token.** The bridge connects with just the URL and `--allow-http`. Only add an `Authorization` header (a `"--header", "Authorization: Bearer <token>"` pair in `args`) when the playground runs with `--enable-auth`; sending a token to a no-auth server, or a stale token to an auth server, causes the connection to drop.
- **On Windows, a bare `npx` often fails.** Claude Desktop launches config commands with a minimal PATH, so set `command` to the full path to `npx.cmd`, for example `C:\\Program Files\\nodejs\\npx.cmd`. On Windows with WSL, note that Desktop is a Windows app and runs the bridge with Windows Node, not the Node inside WSL.
- **Test the bridge by hand before restarting Desktop.** Running the same command in a terminal shows a clear error if something is wrong, where Desktop only shows "server disconnected". For example: `npx -y mcp-remote http://localhost:8001/mcp --allow-http`. A successful run prints "Proxy established successfully" and waits.
- **Approving tools.** By default Desktop prompts before each tool call. To stop the prompts for a trusted server, open **Settings -> Connectors**, expand the connector, and set its tools to **Always Allow**.

### Connect Another MCP Client

Many MCP clients (Cursor, Windsurf, custom agents) accept the same `mcpServers` config shape, though each reads it from its own file, for example `~/.cursor/mcp.json` for Cursor or `~/.codeium/windsurf/mcp_config.json` for Windsurf. Consult your client's documentation for the exact location, then add both servers in that file:

```json
{
  "mcpServers": {
    "gravitino": { "url": "http://localhost:8000/mcp" },
    "trino": { "url": "http://localhost:8001/mcp" }
  }
}
```

When authentication is enabled (`--enable-auth`), the Gravitino server forwards each request's `Authorization` header to Gravitino, which authorizes the call per principal. Add the header in your client to make MCP calls run under a specific identity:

```json
{
  "mcpServers": {
    "gravitino": {
      "url": "http://localhost:8000/mcp",
      "headers": { "Authorization": "Bearer <token>" }
    }
  }
}
```

Clients that speak only stdio, rather than HTTP, reach these servers through the [`mcp-remote`](https://www.npmjs.com/package/mcp-remote) bridge instead, configured the same way as in the Claude Desktop section above.

### Connecting from Another Machine

A client reaches the servers by the playground host's address in place of `localhost`, for example `http://<playground-host>:8000/mcp`. Claude Code connects from wherever it runs, so this is all it needs.

The playground has no TLS, so restrict who can reach the ports rather than exposing them broadly, for example with firewall or security-group rules scoped to the specific client address, by keeping the traffic on a private network, or over an SSH tunnel:

```bash
ssh -L 8000:localhost:8000 -L 8001:localhost:8001 <user>@<playground-host>
```

### Verify an Endpoint with MCP Inspector

To confirm a server is reachable and browse its tools directly, use the [MCP Inspector](https://github.com/modelcontextprotocol/inspector):

```bash
npx @modelcontextprotocol/inspector
```

Open the URL it prints, set Transport Type to **Streamable HTTP**, enter the server URL (`http://localhost:8000/mcp` for Gravitino, `http://localhost:8001/mcp` for Trino; tunnel first if remote), and click **Connect**. Under the **Tools** tab, **List Tools** shows the full surface. On the Gravitino server, running `get_list_of_catalogs` returns the demo catalogs. A `400 Bad Request` to a plain browser `GET` on `/mcp` is expected: the protocol requires an initialize handshake, so that response confirms the server is up.

## Trino

Trino queries metadata that Gravitino federates across catalogs. For more information, see the [Gravitino Trino connector](https://gravitino.apache.org/docs/latest/trino-connector/trino-connector/) documentation.

### Open a Trino Session

Log in to the Trino container:

```shell
docker exec -it playground-trino bash
```

Then open the Trino CLI:

```shell
trino
```

### See the Federated Catalogs

Gravitino presents every registered data source as a Trino catalog. Listing them shows Hive, Iceberg, MySQL, and PostgreSQL all reachable from one engine:

```SQL
SHOW CATALOGS;
```

### Query Across Catalogs

The point of federation is a single query that spans systems. Here HR data lives in PostgreSQL and sales data in Hive, and Gravitino lets Trino join them directly, to find the employee with the largest sales amount:

```SQL
SELECT given_name, family_name, job_title, sum(total_amount) AS total_sales
FROM catalog_hive.sales.sales AS s,
  catalog_postgres.hr.employees AS e
WHERE s.employee_id = e.employee_id
GROUP BY given_name, family_name, job_title
ORDER BY total_sales DESC
LIMIT 1;
```

## Spark

Spark reads and writes the same Gravitino-managed metadata as Trino, so the two engines operate over one catalog. For more information, see the [Gravitino Spark connector](https://gravitino.apache.org/docs/latest/spark-connector/spark-connector/) documentation.

### Open a Spark Session

Log in to the Spark container:

```shell
docker exec -it playground-spark bash
```

Then open the Spark SQL client:

```shell
cd /opt/spark && /bin/bash bin/spark-sql
```

For a worked example of writing with Spark and reading the same table with Trino, see the `gravitino-spark-trino-example.ipynb` notebook in the [Jupyter Notebooks](#jupyter-notebooks) section.

## Iceberg REST Service

A common migration scenario: some tables stay in Hive while others move to Iceberg. Gravitino provides an Iceberg REST catalog service for exactly this. Spark writes Iceberg tables through the REST catalog, and Trino reads them alongside Hive tables, because `catalog_rest` (Spark) and `catalog_iceberg` (Gravitino and Trino) share the same Iceberg JDBC backend and so see the same data.

The playground wires Spark to the REST service in `spark-defaults.conf`:

```text
spark.sql.catalog.catalog_rest org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.catalog_rest.type rest
spark.sql.catalog.catalog_rest.uri http://gravitino:9001/iceberg/
```

In spark-sql, write an Iceberg table through the REST catalog:

```SQL
USE catalog_rest;
CREATE DATABASE IF NOT EXISTS sales;
CREATE TABLE sales.customers (customer_id int, customer_name varchar(100));
INSERT INTO sales.customers VALUES (11, 'Rory Brown'), (12, 'Jerry Washington');
```

The same table is immediately visible to Trino as `catalog_iceberg.sales.customers`, because both point at one Iceberg backend through Gravitino. The `gravitino-spark-trino-example.ipynb` notebook runs this end to end. For more information, see the [Iceberg REST catalog service](https://gravitino.apache.org/docs/latest/iceberg-rest-service/) documentation.

### Access Control

Gravitino provides built-in access control for the Iceberg REST server, enforcing catalog,
schema, and table level privileges without requiring an external authorization service like
Ranger. You manage users, roles, and privileges through the Gravitino API, and the Iceberg
REST server enforces them.

In Basic Authentication mode, Gravitino does not verify the password: it trusts the supplied username and makes access control decisions from it, so any client that can reach the REST endpoint can act as any user. That is fine for the playground and nowhere else. Production deployments use real authentication, such as OAuth2 token validation, described in the [Gravitino security documentation](https://gravitino.apache.org/docs/latest/security/access-control).

Start the playground with `--enable-auth`, which turns on Gravitino's access control so the Iceberg REST server enforces privileges.

Spark connects as a given user by passing basic-auth conf; only the username changes between sessions:

```shell
bin/spark-sql \
  --conf spark.sql.catalog.catalog_rest.rest.auth.type=basic \
  --conf spark.sql.catalog.catalog_rest.rest.auth.basic.username=<user> \
  --conf spark.sql.catalog.catalog_rest.rest.auth.basic.password=123
```

#### Create Users

Create two users through the Gravitino API and make `manager` the metalake owner:

```bash
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" \
  -d '{"name":"manager"}' \
  http://localhost:8090/api/metalakes/metalake_demo/users

curl -X POST -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" \
  -d '{"name":"data_analyst"}' \
  http://localhost:8090/api/metalakes/metalake_demo/users

curl -X PUT -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" \
  -d '{"name":"manager","type":"USER"}' \
  http://localhost:8090/api/metalakes/metalake_demo/owners/metalake/metalake_demo
```

#### Create a Table to Protect

As `manager` in spark-sql, create the table the rest of the demo controls access to:

```sql
USE catalog_rest;
CREATE DATABASE IF NOT EXISTS demo_db;
CREATE TABLE demo_db.employees (employee_id int, name string) USING iceberg;
```

#### Denied Before the Grant

As `data_analyst`, with no privileges yet, the schema is not even visible:

```sql
USE catalog_rest.demo_db;   -- Fails: no USE_SCHEMA privilege
```

#### Grant a Role, Then Allowed

Create a role granting `USE_CATALOG`, `USE_SCHEMA`, and `SELECT_TABLE`, and assign it to `data_analyst`. The role references `catalog_iceberg` (the catalog's name in Gravitino), which is the same catalog Spark reaches as `catalog_rest`:

```bash
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" \
  -u manager:123 \
  -d '{
    "name": "analyst_role",
    "securableObjects": [
      {"fullName": "catalog_iceberg", "type": "CATALOG",
       "privileges": [{"name": "USE_CATALOG", "condition": "ALLOW"}]},
      {"fullName": "catalog_iceberg.demo_db", "type": "SCHEMA",
       "privileges": [{"name": "USE_SCHEMA", "condition": "ALLOW"}]},
      {"fullName": "catalog_iceberg.demo_db.employees", "type": "TABLE",
       "privileges": [{"name": "SELECT_TABLE", "condition": "ALLOW"}]}
    ]
  }' \
  http://localhost:8090/api/metalakes/metalake_demo/roles

curl -X PUT -H "Accept: application/vnd.gravitino.v1+json" -H "Content-Type: application/json" \
  -u manager:123 \
  -d '{"roleNames": ["analyst_role"]}' \
  http://localhost:8090/api/metalakes/metalake_demo/permissions/users/data_analyst/grant
```

Now the same query as `data_analyst` succeeds. Access was denied before the grant and allowed after, enforced by Gravitino at the REST catalog. See the [access control documentation](https://gravitino.apache.org/docs/latest/security/access-control) for details.

### Iceberg Time Travel

The playground seeds `catalog_iceberg.analytics.orders` at startup, partitioned by region and written in two commits, so it has snapshot history immediately. List the snapshots, then read the table as of an earlier commit:

```SQL
SELECT * FROM catalog_iceberg."analytics"."orders$snapshots";

SELECT COUNT(*) FROM catalog_iceberg.analytics.orders FOR VERSION AS OF <snapshot_id>;
```

## HMS

### Introduction

Gravitino manages Hive tables through the Hive Metastore (HMS), presenting them as a catalog alongside Iceberg, MySQL, and PostgreSQL. Metadata operations on the Hive catalog go through Gravitino to the HMS, so Hive data is governed and queried the same way as any other source. For more information, see the [Apache Hive catalog](https://gravitino.apache.org/docs/latest/apache-hive-catalog/) documentation.

### Ranger Authorization

Gravitino provides access control for Hive tables using the Ranger plugin. For example, a company has a manager and several staff members: the manager creates a Hive catalog, defines roles, and assigns those roles to staff.

Start the playground with `--enable-ranger`, then open the `gravitino-access-control-example.ipynb` notebook, which authorizes a Hive catalog through Gravitino and uses Spark to show operations being allowed or denied per user. You can log in to the Ranger admin UI at [http://localhost:6080](http://localhost:6080) (user `admin`) to see the permissions. For more information, see the [access control](https://gravitino.apache.org/docs/latest/security/access-control) documentation.

## Automated Governance

Gravitino can automate governance from metadata alone. This example marks a table as stale with a **statistic**, defines a **policy** for what "stale" means, and runs a **job** that drops tables the policy flags, all through the Gravitino API, with no engine involved. The three build on each other: statistics record facts about a table, a policy interprets them, and a job acts.

All calls below go to the Gravitino API at `http://localhost:8090`. They use the seeded `catalog_hive.sales.customers` table.

### Set a Statistic

Mark the table as last accessed 100 days ago, past the 90-day threshold the policy will use:

```bash
OLD_DATE=$(date -u -d '100 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-100d +%Y-%m-%dT%H:%M:%SZ)

curl -X PUT -H "Accept: application/vnd.gravitino.v1+json" \
  -H "Content-Type: application/json" \
  -d "{\"updates\": {\"custom-lastAccessTime\": \"$OLD_DATE\"}}" \
  http://localhost:8090/api/metalakes/metalake_demo/objects/table/catalog_hive.sales.customers/statistics
```

### Create a Policy

Define a custom policy that flags tables not accessed for more than 90 days:

```bash
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "unused_table_policy",
    "comment": "Flags tables not accessed for 90+ days",
    "policyType": "custom",
    "enabled": true,
    "content": {
      "supportedObjectTypes": ["TABLE"],
      "properties": {
        "checkStatistic": "custom-lastAccessTime",
        "threshold": "90d"
      }
    }
  }' \
  http://localhost:8090/api/metalakes/metalake_demo/policies
```

### Associate the Policy with the Table

```bash
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
  -H "Content-Type: application/json" \
  -d '{"policiesToAdd": ["unused_table_policy"]}' \
  http://localhost:8090/api/metalakes/metalake_demo/objects/table/catalog_hive.sales.customers/policies
```

### Register and Run a Job

Register a shell job template that takes a table and drops it if the policy's statistic shows it is stale. The script itself is a short shell file (it reads the statistic, compares against the threshold, and calls the Gravitino delete API); register it as a template, then run it against the table:

```bash
# Register the template (executable is a shell script placed in the Gravitino container)
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
  -H "Content-Type: application/json" \
  -d '{
    "jobTemplate": {
      "name": "drop_unused_table_job",
      "jobType": "shell",
      "executable": "file:///tmp/drop_unused_tables.sh",
      "arguments": ["{{catalog}}", "{{schema}}", "{{table}}"]
    }
  }' \
  http://localhost:8090/api/metalakes/metalake_demo/jobs/templates

# Run it against the stale table
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
  -H "Content-Type: application/json" \
  -d '{
    "jobTemplateName": "drop_unused_table_job",
    "jobConf": {"catalog": "catalog_hive", "schema": "sales", "table": "customers"}
  }' \
  http://localhost:8090/api/metalakes/metalake_demo/jobs/runs
```

The run returns a `jobRunId`. Query the run to see its `status` (`QUEUED`, `RUNNING`, `SUCCEEDED`, `FAILED`) and output:

```bash
curl -X GET -H "Accept: application/vnd.gravitino.v1+json" \
  http://localhost:8090/api/metalakes/metalake_demo/jobs/runs/<jobRunId>
```

Once it succeeds, the table is gone. For the full job script and API details, see [Manage jobs](https://gravitino.apache.org/docs/latest/manage-jobs-in-gravitino), [Manage policies](https://gravitino.apache.org/docs/latest/manage-policies-in-gravitino), and [Manage statistics](https://gravitino.apache.org/docs/latest/manage-statistics-in-gravitino).

## Grafana Dashboards

Open Grafana at [http://localhost:13000](http://localhost:13000). In the navigation menu, click **Dashboards** -> **Gravitino Playground**, then experiment with the default template.

## System Requirements

2 CPU cores, 8 GB RAM, 25 GB disk storage, macOS or Linux (verified on Ubuntu 22.04, Ubuntu 24.04, and Amazon Linux).

## TCP Ports Used

The playground runs several services. The TCP ports used may clash with existing services you run, such as MySQL or Postgres.

| Docker container         | Ports used             |
| ------------------------ | ---------------------- |
| playground-gravitino     | 8090 9001              |
| playground-hive          | 3307 19000 19083 60070 |
| playground-ranger        | 6080                   |
| playground-mysql         | 13306                  |
| playground-spark         | 14040                  |
| playground-postgresql    | 15432                  |
| playground-trino         | 18080                  |
| playground-jupyter       | 18888                  |
| playground-prometheus    | 19090                  |
| playground-grafana       | 13000                  |
| playground-gravitino-mcp | 8000                   |
| playground-trino-mcp     | 8001                   |

## Environment Configuration

The playground is preconfigured for local evaluation and is not a production reference architecture. The defaults reflect that:

| Aspect                   | Configuration                       | Notes                                                                                                                                                    |
| ------------------------ | ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Authentication           | None                                | Gravitino trusts the username presented by clients. See the note on Basic Authentication in the access control section below.                            |
| Authorization            | Disabled                            | Enable Gravitino native access control with `--enable-auth`, or Ranger enforcement for Hive with `--enable-ranger`.                                      |
| Transport                | Plain HTTP                          | No TLS on any service, including Trino and the Gravitino API.                                                                                            |
| Gravitino metadata store | Embedded H2 in the `data` directory | Only the Gravitino server accesses this store, so an embedded database suffices. Wiped by the full reset.                                                |
| Iceberg catalog backend  | JDBC, MySQL `db` database           | Shared by `catalog_iceberg` (Gravitino, Trino) and `catalog_rest` (Spark, through the Iceberg REST service), so it needs a database all three can reach. |
| Table storage            | HDFS in the `hive` container        | `hdfs://hive:9000` for both Hive and Iceberg warehouses. No object storage is involved.                                                                  |
| Credentials              | Hardcoded demo values               | For example, MySQL uses `mysql`/`mysql`.                                                                                                                 |

The playground has no authentication or TLS, so any reachable port grants full access to that service. If you run the playground on a remote host, control who can reach the ports, for example with firewall rules scoped to your address or an SSH tunnel.

## NOTICE

The playground stores state in Docker volumes and in the `data` directory of this repo. See the Stop section above for how to reset the playground completely.

<sub>Apache®, Apache Gravitino&trade;, Apache Hive&trade;, Apache Iceberg&trade;, and Apache Spark&trade; are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.</sub>
