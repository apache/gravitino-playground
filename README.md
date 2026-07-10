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

## Playground introduction

The playground is a complete Apache Gravitino Docker runtime environment with `Hive`, `HDFS`, `Trino`, `Spark`, `MySQL`, `PostgreSQL`, `Ranger`, `Jupyter`, `Prometheus`, `Grafana`, and a `Gravitino` server.

Depending on your network and computer, startup time may take 3-5 minutes. Once the playground environment has started, you can open [http://localhost:8090](http://localhost:8090) in a browser to access the Gravitino Web UI.

## Prerequisites

Install Git (optional), Docker, Docker Compose.

## System Resource Requirements

2 CPU cores, 8 GB RAM, 25 GB disk storage, macOS or Linux (verified on Ubuntu 22.04, Ubuntu 24.04, and Amazon Linux).

## TCP ports used

The playground runs several services. The TCP ports used may clash with existing services you run, such as MySQL or Postgres.

| Docker container      | Ports used             |
| --------------------- | ---------------------- |
| playground-gravitino  | 8090 9001              |
| playground-hive       | 3307 19000 19083 60070 |
| playground-ranger     | 6080                   |
| playground-mysql      | 13306                  |
| playground-spark      | 14040                  |
| playground-postgresql | 15432                  |
| playground-trino      | 18080                  |
| playground-jupyter    | 18888                  |
| playground-prometheus | 19090                  |
| playground-grafana    | 13000                  |

## Environment configuration

The playground is preconfigured for local evaluation and is not a production reference architecture. The defaults reflect that:

| Aspect                   | Configuration                       | Notes                                                                                                                                                    |
| ------------------------ | ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Authentication           | None                                | Gravitino trusts the username presented by clients. See the security note in the access control demo below.                                              |
| Authorization            | Disabled                            | Enable Gravitino native access control with `--enable-auth`, or Ranger enforcement for Hive with `--enable-ranger`.                                      |
| Transport                | Plain HTTP                          | No TLS on any service, including Trino and the Gravitino API.                                                                                            |
| Gravitino metadata store | Embedded H2 in the `data` directory | Only the Gravitino server accesses this store, so an embedded database suffices. Wiped by the full reset.                                                |
| Iceberg catalog backend  | JDBC, MySQL `db` database           | Shared by `catalog_iceberg` (Gravitino, Trino) and `catalog_rest` (Spark, through the Iceberg REST service), so it needs a database all three can reach. |
| Table storage            | HDFS in the `hive` container        | `hdfs://hive:9000` for both Hive and Iceberg warehouses. No object storage is involved.                                                                  |
| Credentials              | Hardcoded demo values               | For example, MySQL uses `mysql`/`mysql`.                                                                                                                 |

The playground has no authentication or TLS, so any reachable port grants full access to that service. If you run the playground on a remote host, control who can reach the ports, for example with firewall rules scoped to your address or an SSH tunnel.

## Playground usage

There are two ways to get the playground. Use one or the other, not both.

### Option 1: One-command install and launch

Downloads the playground and starts it in a single step:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/apache/gravitino-playground/HEAD/install.sh)"
```

### Option 2: Clone and launch with git

```bash
git clone https://github.com/apache/gravitino-playground.git
cd gravitino-playground
./playground.sh start
```

The start command accepts optional flags for the access control demos described below: `--enable-auth` or `--enable-ranger` (the two cannot be combined).

### Playground management

Run these from the playground directory, whichever option you used to install it (`gravitino-playground` for git, `gravitino-playground-main` for the installer).

#### Check status

```bash
./playground.sh status
```

When all containers are healthy, open the Gravitino Web UI at <http://localhost:8090>.

#### Stop

```bash
./playground.sh stop
```

Stopping keeps container data. Gravitino also stores its data in the `data` directory of this repo. To remove all data and start completely fresh:

```bash
docker compose -p gravitino-playground down -v
rm -rf data
```

## Trino CLI

1. Log in to the Trino container:

   ```shell
   docker exec -it playground-trino bash
   ```

2. Open the Trino CLI:

   ```shell
   trino
   ```

## Jupyter Notebook

1. Open the Jupyter Notebook in the browser at [http://localhost:18888](http://localhost:18888).

2. Open the `gravitino-trino-example.ipynb` notebook.

3. Start the notebook and run the cells.

## Spark SQL client

1. Log in to the Spark container:

   ```shell
   docker exec -it playground-spark bash
   ```

2. Open the Spark SQL client:

   ```shell
   cd /opt/spark && /bin/bash bin/spark-sql
   ```

## Grafana dashboards

1. Open Grafana in the browser at [http://localhost:13000](http://localhost:13000).

2. In the navigation menu, click **Dashboards** -> **Gravitino Playground**.

3. Experiment with the default template.

## Examples

### Simple Trino queries

Test the setup with simple queries in the Trino CLI.

```SQL
SHOW CATALOGS;

CREATE SCHEMA catalog_hive.company
  WITH (location = 'hdfs://hive:9000/user/hive/warehouse/company.db');

SHOW CREATE SCHEMA catalog_hive.company;

CREATE TABLE catalog_hive.company.employees
(
  name varchar,
  salary decimal(10,2)
)
WITH (
  format = 'TEXTFILE'
);

INSERT INTO catalog_hive.company.employees (name, salary) VALUES ('Sam Evans', 55000);

SELECT * FROM catalog_hive.company.employees;

SHOW SCHEMAS from catalog_hive;

DESCRIBE catalog_hive.company.employees;

SHOW TABLES from catalog_hive.company;
```

### Cross-catalog queries

Different departments often run different data stacks. In this example, HR stores its data in Hive and sales uses PostgreSQL. Gravitino lets you join data across both.

To find the employee with the largest sales amount:

```SQL
SELECT given_name, family_name, job_title, sum(total_amount) AS total_sales
FROM catalog_hive.sales.sales as s,
  catalog_postgres.hr.employees AS e
where s.employee_id = e.employee_id
GROUP BY given_name, family_name, job_title
ORDER BY total_sales DESC
LIMIT 1;
```

To find the top customers by state:

```SQL
SELECT customer_name, location, SUM(total_amount) AS total_spent
FROM catalog_hive.sales.sales AS s,
  catalog_hive.sales.stores AS l,
  catalog_hive.sales.customers AS c
WHERE s.store_id = l.store_id AND s.customer_id = c.customer_id
GROUP BY location, customer_name
ORDER BY location, SUM(total_amount) DESC;
```

To get each employee's average performance rating and total sales:

```SQL
SELECT e.employee_id, given_name, family_name, AVG(rating) AS average_rating, SUM(total_amount) AS total_sales
FROM catalog_postgres.hr.employees AS e,
  catalog_postgres.hr.employee_performance AS p,
  catalog_hive.sales.sales AS s
WHERE e.employee_id = p.employee_id AND p.employee_id = s.employee_id
GROUP BY e.employee_id,  given_name, family_name;
```

### Spark and Trino together

You can also generate data with Spark SQL and query it with Trino:

1. Log in to the Spark container and run the SQL:

   ```sql
   -- using Hive catalog to create Hive table
   USE catalog_hive;
   CREATE DATABASE product;
   USE product;

   CREATE TABLE IF NOT EXISTS employees (
       id INT,
       name STRING,
       age INT
   )
   PARTITIONED BY (department STRING)
   STORED AS PARQUET;
   DESC TABLE EXTENDED employees;

   INSERT OVERWRITE TABLE employees PARTITION(department='Engineering') VALUES (1, 'John Doe', 30), (2, 'Jane Smith', 28);
   INSERT OVERWRITE TABLE employees PARTITION(department='Marketing') VALUES (3, 'Mike Brown', 32);
   ```

2. Log in to the Trino container and run the query:

   ```sql
   SELECT * FROM catalog_hive.product.employees WHERE department = 'Engineering';
   ```

The demo is also available as `gravitino-spark-trino-example.ipynb` in Jupyter at [http://localhost:18888](http://localhost:18888).

### Iceberg REST service

A common migration scenario: some tables remain in Hive while others move to Iceberg.
Gravitino provides an Iceberg REST catalog service for exactly this. In the example below, Spark writes
table data through the REST catalog, and Trino joins the new Iceberg table with an existing Hive table.

The playground ships with the following `spark-defaults.conf`:

```text
spark.sql.extensions org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions
spark.sql.catalog.catalog_rest org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.catalog_rest.type rest
spark.sql.catalog.catalog_rest.uri http://gravitino:9001/iceberg/
spark.locality.wait.node 0
```

Note that `catalog_rest` in Spark and `catalog_iceberg` in Gravitino and Trino share the same Iceberg JDBC backend, so they access the same dataset.

1. Log in to the Spark container and run the steps:

   ```shell
   docker exec -it playground-spark bash
   ```

   ```shell
   spark@container_id:/$ cd /opt/spark && /bin/bash bin/spark-sql
   ```

   ```SQL
   use catalog_rest;
   create database sales;
   use sales;
   create table customers (customer_id int, customer_name varchar(100), customer_email varchar(100));
   describe extended customers;
   insert into customers (customer_id, customer_name, customer_email) values (11,'Rory Brown','rory@123.com');
   insert into customers (customer_id, customer_name, customer_email) values (12,'Jerry Washington','jerry@dt.com');
   ```

2. Log in to the Trino container and query all customers across the Hive and Iceberg tables:

   ```shell
   docker exec -it playground-trino bash
   ```

   ```shell
   trino@container_id:/$ trino
   ```

   ```SQL
   select * from catalog_hive.sales.customers
   union
   select * from catalog_iceberg.sales.customers;
   ```

The demo is also available as `gravitino-spark-trino-example.ipynb` in Jupyter at [http://localhost:18888](http://localhost:18888).

The playground also seeds the Iceberg catalog with a demo table at startup: `analytics.orders`,
partitioned by region and written in two commits, so the table has snapshot history from the
first query you run:

```sql
SELECT region, SUM(amount) FROM catalog_iceberg.analytics.orders GROUP BY region;

SELECT * FROM catalog_iceberg."analytics"."orders$snapshots";
```

The second query lists the table's snapshots; pick a `snapshot_id` from it to read the table
as of an earlier commit:

```sql
SELECT COUNT(*) FROM catalog_iceberg.analytics.orders FOR VERSION AS OF <snapshot_id>;
```

### Iceberg REST server access control

Gravitino provides built-in access control for the Iceberg REST server, enforcing catalog,
schema, and table level privileges without requiring an external authorization service like
Ranger. You manage users, roles, and privileges through the Gravitino API, and the Iceberg
REST server enforces them.

**Security note**: the examples below use HTTP Basic Authentication only to pass a username.
Gravitino does not verify the password and trusts the supplied username for access control
decisions, so any client that can reach the REST endpoint can act as any user. That is
acceptable for the playground and nothing else. Production deployments configure real
authentication, such as OAuth2 token validation, as described in the
[Gravitino security documentation](https://gravitino.apache.org/docs/latest/security/access-control).

1. Start the playground with auth enabled:

   ```shell
   ./playground.sh start --enable-auth
   ```

   **Note**: The `--enable-auth` flag enables Gravitino's access control by removing the PassThroughAuthorizer, which allows proper privilege enforcement for the Iceberg REST catalog.

2. Create users through Gravitino's REST API:

   ```shell
   # Add manager user
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{"name":"manager"}' \
     http://localhost:8090/api/metalakes/metalake_demo/users

   # Add data_analyst user
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{"name":"data_analyst"}' \
     http://localhost:8090/api/metalakes/metalake_demo/users

   # Set manager as owner of the metalake
   curl -X PUT -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{"name":"manager","type":"USER"}' \
     http://localhost:8090/api/metalakes/metalake_demo/owners/metalake/metalake_demo
   ```

3. Create a database and table as the manager:

   Log in to the Spark container:

   ```shell
   docker exec -it playground-spark bash
   ```

   Start spark-sql as manager:

   ```shell
   cd /opt/spark && /bin/bash bin/spark-sql --conf spark.sql.catalog.catalog_rest.rest.auth.type=basic --conf spark.sql.catalog.catalog_rest.rest.auth.basic.username=manager --conf spark.sql.catalog.catalog_rest.rest.auth.basic.password=123
   ```

   Create database and table:

   ```sql
   USE catalog_rest;
   CREATE DATABASE IF NOT EXISTS demo_db;
   USE demo_db;

   CREATE TABLE IF NOT EXISTS employees (
       employee_id INT,
       name STRING,
       department STRING,
       salary DECIMAL(10,2)
   ) USING iceberg;

   INSERT INTO employees VALUES
     (1, 'Alice Johnson', 'Engineering', 95000.00),
     (2, 'Bob Smith', 'Sales', 75000.00);

   SELECT * FROM employees;
   ```

4. Test access control before granting privileges:


   Exit spark-sql and start a new session as data_analyst (without any privileges yet):

   ```shell
   export HADOOP_USER_NAME=data_analyst
   cd /opt/spark
   /bin/bash bin/spark-sql  --conf spark.sql.catalog.catalog_rest.rest.auth.type=basic --conf spark.sql.catalog.catalog_rest.rest.auth.basic.username=data_analyst --conf spark.sql.catalog.catalog_rest.rest.auth.basic.password=123
   ```

   Try to query the table. The query should fail:

   ```sql
   USE catalog_rest.demo_db;

   -- Fails: the schema is not visible without the USE_SCHEMA privilege
   ```

5. Create a role with privileges and assign it to the user:

   Exit spark-sql and create a role with the necessary privileges. Note that the role references `catalog_iceberg`, the catalog name in Gravitino; `catalog_rest` in Spark is the same catalog exposed through the Iceberg REST endpoint:

   ```shell
   # Create role with all required privileges
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -u manager:123 \
     -d '{
    "name": "analyst_role",
    "securableObjects": [
      {
        "fullName": "catalog_iceberg",
        "type": "CATALOG",
        "privileges": [
          {"name": "USE_CATALOG", "condition": "ALLOW"}
        ]
      },
      {
        "fullName": "catalog_iceberg.demo_db",
        "type": "SCHEMA",
        "privileges": [
          {"name": "USE_SCHEMA", "condition": "ALLOW"}
        ]
      },
      {
        "fullName": "catalog_iceberg.demo_db.employees",
        "type": "TABLE",
        "privileges": [
          {"name": "SELECT_TABLE", "condition": "ALLOW"}
        ]
      }
    ]
     }' \
     http://localhost:8090/api/metalakes/metalake_demo/roles

   # Assign role to user
   curl -X PUT -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -u manager:123 \
     -d '{
    "roleNames": ["analyst_role"]
   }' http://localhost:8090/api/metalakes/metalake_demo/permissions/users/data_analyst/grant
   ```

   Start spark-sql as data_analyst again and test:

   ```shell
   cd /opt/spark && /bin/bash bin/spark-sql \
     --conf spark.sql.catalog.catalog_rest.rest.auth.type=basic \
     --conf spark.sql.catalog.catalog_rest.rest.auth.basic.username=data_analyst \
     --conf spark.sql.catalog.catalog_rest.rest.auth.basic.password=123
   ```

   Try to query the table again. The query should succeed now:

   ```sql
   USE catalog_rest.demo_db;

   -- Succeeds: the role now grants SELECT_TABLE
   SELECT * FROM employees;
   ```

The demo shows Gravitino's access control at work: access is denied before the privileges are
granted and allowed after.

For more details, refer to the [Gravitino documentation](https://gravitino.apache.org/docs/latest/security/access-control).

### Ranger authorization with Hive

Gravitino provides access control for Hive tables using the Ranger plugin.

For example, a company has a manager and several staff members. The manager creates a Hive catalog and defines different roles,
then assigns those roles to staff members.

Start the playground with Ranger enabled:

```shell
./playground.sh start --enable-ranger
```

The demo notebook is `gravitino-access-control-example.ipynb` in Jupyter at [http://localhost:18888](http://localhost:18888).

### Unused table cleanup with policies, statistics, and jobs

Gravitino provides a powerful combination of policies, statistics, and jobs that enables automated, metadata-driven data governance. The demo shows how to identify and drop tables that haven't been accessed for a long time, reducing storage costs.

**Workflow Overview:**
1. **Statistics** - Track table usage with custom statistics (e.g., `custom-lastAccessTime`)
2. **Policies** - Define rules for identifying unused tables (e.g., not accessed for 90 days)
3. **Jobs** - Execute automated actions to drop unused tables

1. Start the playground:

   ```shell
   ./playground.sh start
   ```

2. Update statistics for an existing table:

   The playground already has tables in the Hive catalog. Update the statistics of an existing table to simulate an old, unused table:

   ```shell
   # First, verify the existing table
   docker exec -it playground-trino trino --execute "SELECT * FROM catalog_hive.sales.customers LIMIT 5"

   # Calculate a date 100 days ago (more than the 90-day threshold)
   OLD_DATE=$(date -u -d '100 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-100d +%Y-%m-%dT%H:%M:%SZ)

   # Update last access time for the table to make it appear unused
   curl -X PUT -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d "{
    \"updates\": {
      \"custom-lastAccessTime\": \"$OLD_DATE\",
      \"custom-rowCount\": \"10\"
    }
     }" \
     http://localhost:8090/api/metalakes/metalake_demo/objects/table/catalog_hive.sales.customers/statistics

   # Check statistics to verify they were set
   curl -X GET -H "Accept: application/vnd.gravitino.v1+json" \
     http://localhost:8090/api/metalakes/metalake_demo/objects/table/catalog_hive.sales.customers/statistics
   ```

   You should see output like:
   ```json
   {
     "statistics": {
    "custom-lastAccessTime": {
      "value": "2024-09-08T10:30:00Z"
    },
    "custom-rowCount": {
      "value": "10"
    }
     }
   }
   ```

3. Create a policy for unused tables:

   Create a custom policy to identify tables not accessed for more than 90 days:

   ```shell
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{
       "name": "unused_table_policy",
       "comment": "Policy to identify tables not accessed for 90+ days",
       "policyType": "custom",
       "enabled": true,
       "content": {
         "customRules": {
           "maxIdleDays": 90,
           "action": "drop"
         },
         "supportedObjectTypes": ["TABLE"],
         "properties": {
           "checkStatistic": "custom-lastAccessTime",
           "threshold": "90d"
         }
       }
     }' \
     http://localhost:8090/api/metalakes/metalake_demo/policies
   ```

4. Associate the policy with tables:

   Associate the policy with the existing customers table:

   ```shell
   # Associate policy with the customers table
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{
    "policiesToAdd": ["unused_table_policy"]
     }' \
     http://localhost:8090/api/metalakes/metalake_demo/objects/table/catalog_hive.sales.customers/policies

   # Verify the policy was associated
   curl -X GET -H "Accept: application/vnd.gravitino.v1+json" \
     http://localhost:8090/api/metalakes/metalake_demo/objects/table/catalog_hive.sales.customers/policies
   ```

   Alternatively, you can associate the policy with the entire schema to monitor all tables:

   ```shell
   # Associate with the entire schema (will apply to all tables in sales)
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{
    "policiesToAdd": ["unused_table_policy"]
     }' \
     http://localhost:8090/api/metalakes/metalake_demo/objects/schema/catalog_hive.sales/policies
   ```

5. Register a job template to drop unused tables:

   Create a shell script job template to drop tables:

   ```shell
   # First, create the drop script on the host
   cat > /tmp/drop_unused_tables.sh << 'EOF'
   #!/bin/bash
   # Script to drop unused tables based on policy evaluation
   CATALOG=$1
   SCHEMA=$2
   TABLE=$3

   echo "Checking if table ${CATALOG}.${SCHEMA}.${TABLE} should be dropped..."

   # Get table statistics (use localhost since script runs on host or in container with port mapping)
   STATS=$(curl -s -X GET -H "Accept: application/vnd.gravitino.v1+json" \
     "http://localhost:8090/api/metalakes/metalake_demo/objects/table/${CATALOG}.${SCHEMA}.${TABLE}/statistics")

   echo "Statistics response: $STATS"

   # Parse the statistics array to find custom-lastAccessTime
   LAST_ACCESS=$(echo $STATS | jq -r '.statistics[] | select(.name=="custom-lastAccessTime") | .value')
   echo "Last access time: $LAST_ACCESS"

   # Calculate days since last access
   if [ -n "$LAST_ACCESS" ] && [ "$LAST_ACCESS" != "null" ]; then
     CURRENT_DATE=$(date +%s)
     LAST_ACCESS_DATE=$(date -d "$LAST_ACCESS" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_ACCESS" +%s)
     DAYS_IDLE=$(( ($CURRENT_DATE - $LAST_ACCESS_DATE) / 86400 ))
     
     echo "Days since last access: $DAYS_IDLE"
     
     if [ $DAYS_IDLE -gt 90 ]; then
    echo "Table has been idle for more than 90 days. Dropping table..."
    # Drop table via Gravitino API
    DROP_RESPONSE=$(curl -s -X DELETE -H "Accept: application/vnd.gravitino.v1+json" \
      "http://localhost:8090/api/metalakes/metalake_demo/catalogs/${CATALOG}/schemas/${SCHEMA}/tables/${TABLE}")
    echo "Drop response: $DROP_RESPONSE"
    echo "Table ${CATALOG}.${SCHEMA}.${TABLE} dropped successfully"
     else
    echo "Table is still active. No action needed."
     fi
   else
     echo "No last access time found. Skipping..."
   fi
   EOF

   chmod +x /tmp/drop_unused_tables.sh

   # Copy the script into the Gravitino container
   docker cp /tmp/drop_unused_tables.sh playground-gravitino:/tmp/drop_unused_tables.sh

   # Make it executable in the container
   docker exec playground-gravitino chmod +x /tmp/drop_unused_tables.sh

   # Register the job template
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{
    "jobTemplate": {
      "name": "drop_unused_table_job",
      "jobType": "shell",
      "comment": "Job to drop unused tables based on policy",
      "executable": "file:///tmp/drop_unused_tables.sh",
      "arguments": ["{{catalog}}", "{{schema}}", "{{table}}"],
      "environments": {},
      "customFields": {},
      "scripts": []
    }
     }' \
     http://localhost:8090/api/metalakes/metalake_demo/jobs/templates
   ```

6. Run the job to drop unused tables:

   Execute the job for the customers table:

   ```shell
   # Run job for the customers table (should drop it since it's > 90 days old)
   curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
     -H "Content-Type: application/json" \
     -d '{
    "jobTemplateName": "drop_unused_table_job",
    "jobConf": {
      "catalog": "catalog_hive",
      "schema": "sales",
      "table": "customers"
    }
     }' \
     http://localhost:8090/api/metalakes/metalake_demo/jobs/runs
   ```

   The response will contain a `jobRunId` that you can use to check the job status.

7. Verify the job result:

   Check the job execution status and result:

   ```shell
   # Get the job run details (replace {jobRunId} with the actual ID from the response in the previous step)
   curl -X GET -H "Accept: application/vnd.gravitino.v1+json" \
     http://localhost:8090/api/metalakes/metalake_demo/jobs/runs/{jobRunId}

   # Example: If jobRunId is "job-123"
   curl -X GET -H "Accept: application/vnd.gravitino.v1+json" \
     http://localhost:8090/api/metalakes/metalake_demo/jobs/runs/job-123
   ```

   The response will show:
   - **status**: Job status (`QUEUED`, `RUNNING`, `SUCCEEDED`, `FAILED`, `CANCELLING`, `CANCELLED`)
   - **startTime**: When the job started
   - **endTime**: When the job completed
   - **output**: Job execution output/logs

   Verify the table was dropped:

   ```shell
   # Check if the table still exists (should show it's gone)
   docker exec -it playground-trino trino --execute "SHOW TABLES FROM catalog_hive.sales"

   # Or try to query the dropped table (should fail with "Table not found")
   docker exec -it playground-trino trino --execute "SELECT * FROM catalog_hive.sales.customers LIMIT 1"
   ```

   If the table was successfully dropped, you'll see an error like:
   ```
   Query failed: line 1:15: Table 'hive.sales.customers' does not exist
   ```

For more details, refer to:
- [Manage Statistics in Gravitino](https://gravitino.apache.org/docs/latest/manage-statistics-in-gravitino)
- [Manage Policies in Gravitino](https://gravitino.apache.org/docs/latest/manage-policies-in-gravitino)
- [Manage Jobs in Gravitino](https://gravitino.apache.org/docs/latest/manage-jobs-in-gravitino)

### Gravitino with LlamaIndex

The Gravitino Playground also provides a simple RAG demo with LlamaIndex. The demo shows the
ability to use Gravitino to manage both tabular and non-tabular datasets, connecting to
LlamaIndex as a unified data source, then use LlamaIndex and LLM to query both tabular and
non-tabular data with one natural language query.

The demo notebook is `gravitino_llama_index_demo.ipynb` in Jupyter at [http://localhost:18888](http://localhost:18888).

In the demo scenario, structured city statistics live in MySQL and detailed city introductions
live in PDF files. A single natural language question needs answers drawn from both.

You will manage the MySQL table with a relational catalog and the PDF files with a fileset
catalog, treating Gravitino as a unified data source for LlamaIndex to index both. An LLM then
answers natural language queries over the combined data.

Note: the demo requires `OPENAI_API_KEY` to be set in `gravitino_llama_index_demo.ipynb` as shown
below. `OPENAI_API_BASE` is optional.

```python
import os

os.environ["OPENAI_API_KEY"] = ""
os.environ["OPENAI_API_BASE"] = ""
```

## NOTICE

The playground stores state in Docker volumes and in the `data` directory of this repo. See the Stop section above for how to reset the playground completely.

<sub>Apache®, Apache Gravitino&trade;, Apache Hive&trade;, Apache Iceberg&trade;, and Apache Spark&trade; are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.</sub>

