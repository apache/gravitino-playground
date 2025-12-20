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

The playground is a complete Apache Gravitino Docker runtime environment with `Hive`, `HDFS`, `Trino`, `MySQL`, `PostgreSQL`, `Jupyter`, and a `Gravitino` server.

Depending on your network and computer, startup time may take 3-5 minutes. Once the playground environment has started, you can open [http://localhost:8090](http://localhost:8090) in a browser to access the Gravitino Web UI.

## Prerequisites

Install Git (optional), Docker, Docker Compose.

## System Resource Requirements

2 CPU cores, 8 GB RAM, 25 GB disk storage, MacOS or Linux OS (Verified Ubuntu22.04 Ubuntu24.04 AmazonLinux).

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

## Playground usage

### One curl command launch playground
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/apache/gravitino-playground/HEAD/install.sh)"
```

### Use git to download and launch playground

```shell
git clone git@github.com:apache/gravitino-playground.git
cd gravitino-playground
```

### Start

```shell
./playground.sh start
```

### Check status
```shell
./playground.sh status
```

### Stop
```shell
./playground.sh stop
```

## Experiencing Apache Gravitino with Trino SQL

### Using Trino CLI in Docker Container

1. Login to the Gravitino playground Trino Docker container using the following command:

```shell
docker exec -it playground-trino bash
```

2. Open the Trino CLI in the container.

```shell
trino
```

## Using Jupyter Notebook

1. Open the Jupyter Notebook in the browser at [http://localhost:18888](http://localhost:18888).

2. Open the `gravitino-trino-example.ipynb` notebook.

3. Start the notebook and run the cells.

## Using Spark client

1. Login to the Gravitino playground Spark Docker container using the following command:

```shell
docker exec -it playground-spark bash
````

2. Open the Spark SQL client in the container.

```shell
cd /opt/spark && /bin/bash bin/spark-sql
```

## Monitoring Gravitino

1. Open the Grafana in the browser at [http://localhost:13000](http://localhost:13000).

2. In the navigation menu, click **Dashboards** -> **Gravitino Playground**.

3. Experiment with the default template.

## Example

### Simple Trino queries

You can use simple queries to test in the Trino CLI.

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

In a company, there may be different departments using different data stacks. In this example, the HR department uses Apache Hive to store its data, and the sales department uses PostgreSQL. You can run some interesting queries by joining the two departments' data together with Gravitino.

To know which employee has the largest sales amount, run this SQL:

```SQL
SELECT given_name, family_name, job_title, sum(total_amount) AS total_sales
FROM catalog_hive.sales.sales as s,
  catalog_postgres.hr.employees AS e
where s.employee_id = e.employee_id
GROUP BY given_name, family_name, job_title
ORDER BY total_sales DESC
LIMIT 1;
```

To know the top customers who bought the most by state, run this SQL:

```SQL
SELECT customer_name, location, SUM(total_amount) AS total_spent
FROM catalog_hive.sales.sales AS s,
  catalog_hive.sales.stores AS l,
  catalog_hive.sales.customers AS c
WHERE s.store_id = l.store_id AND s.customer_id = c.customer_id
GROUP BY location, customer_name
ORDER BY location, SUM(total_amount) DESC;
```

To know the employee's average performance rating and total sales, run this SQL:

```SQL
SELECT e.employee_id, given_name, family_name, AVG(rating) AS average_rating, SUM(total_amount) AS total_sales
FROM catalog_postgres.hr.employees AS e,
  catalog_postgres.hr.employee_performance AS p,
  catalog_hive.sales.sales AS s
WHERE e.employee_id = p.employee_id AND p.employee_id = s.employee_id
GROUP BY e.employee_id,  given_name, family_name;
```

### Using Spark and Trino

You might also consider generating data with SparkSQL and then querying this data using Trino. Give it a try with Gravitino:

1. Login Spark container and execute the SQLs:

```sql
// using Hive catalog to create Hive table
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

2. Login Trino container and execute SQLs:

```sql
SELECT * FROM catalog_hive.product.employees WHERE department = 'Engineering';
```

The demo is located in the `jupyter` folder, and you can open the `gravitino-spark-trino-example.ipynb`
demo via Jupyter Notebook by [http://localhost:18888](http://localhost:18888).

### Using Apache Iceberg REST service

Suppose you want to migrate your business from Hive to Iceberg. Some tables will use Hive, and the other tables will use Iceberg.
Gravitino provides an Iceberg REST catalog service, too. You can use Spark to access the REST catalog to write the table data.
Then, you can use Trino to read the data from the Hive table joining the Iceberg table.

`spark-defaults.conf` is as follows (It's already configured in the playground):

```text
spark.sql.extensions org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions
spark.sql.catalog.catalog_rest org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.catalog_rest.type rest
spark.sql.catalog.catalog_rest.uri http://gravitino:9001/iceberg/
spark.locality.wait.node 0
```

Please note that `catalog_rest` in SparkSQL and `catalog_iceberg` in Gravitino and Trino share the same Iceberg JDBC backend, implying they can access the same dataset.

1. Login Spark container and execute the steps.

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

2. Login Trino container and execute the steps.
   You can get all the customers from both the Hive and Iceberg table.

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

The demo is located in the `jupyter` folder, you can open the `gravitino-spark-trino-example.ipynb`
demo via Jupyter Notebook by [http://localhost:18888](http://localhost:18888).

### Using Gravitino with LlamaIndex

The Gravitino Playground also provides a simple RAG demo with LlamaIndex. This demo will show you the
the ability to use Gravitino to manage both tabular and non-tabular datasets, connecting to
LlamaIndex as a unified data source, then use LlamaIndex and LLM to query both tabular and
non-tabular data with one natural language query.

The demo is located in the `jupyter` folder, and you can open the `gravitino_llama_index_demo.ipynb`
demo via Jupyter Notebook by [http://localhost:18888](http://localhost:18888).

The scenario of this demo is that basic structured city statistics data is stored in MySQL, and
detailed city introductions are stored in PDF files. The user wants to know the answers to the
cities both in the structured data and the PDF files.

In this demo, you will use Gravitino to manage the MySQL table using a relational catalog, pdf
files using a fileset catalog, treating Gravitino as a unified data source for LlamaIndex to build
indexes on both tabular and non-tabular data. Then you will use LLM to query the data with natural
language queries.

Note: to run this demo, you need to set `OPENAI_API_KEY` in the `gravitino_llama_index_demo.ipynb`,
like below, `OPENAI_API_BASE` is optional.

```python
import os

os.environ["OPENAI_API_KEY"] = ""
os.environ["OPENAI_API_BASE"] = ""
```

### Using Gravitino with Ranger authorization

Gravitino supports to provide the ability of access control for Hive tables using Ranger plugin.

For example, there are a manager and staffs in your company. Manager creates a Hive catalog and create different roles.
The manager can give different roles to different staffs.

You can run the command

```shell
./playground.sh start --enable-ranger
```

The demo is located in the `jupyter` folder, you can open the `gravitino-access-control-example.ipynb`
demo via Jupyter Notebook by [http://localhost:18888](http://localhost:18888).

### Using Gravitino Iceberg REST Server with Access Control

Gravitino 1.1 introduced built-in access control for the Iceberg REST server, enabling fine-grained
authorization for Iceberg tables without requiring external authorization services like Ranger. 
This feature allows you to manage user permissions through Gravitino's unified API with native 
access control enforcement at the REST API level.

**Security note (authentication)**: The Iceberg REST catalog examples shown here use HTTP Basic Authentication only as a transport to pass the username through the `Authorization` header. Gravitino currently **does not verify the Basic Auth password** and instead fully trusts the username provided in the header for access control decisions. As a result, this mechanism **does not provide real authentication**: any client that can reach the REST endpoint could impersonate any user by choosing their username in the header.

This behavior is intended **for local/demo use only** (such as when running the playground) and **must not be relied upon in production** or any environment exposed to untrusted clients. For secure deployments, you must front the Iceberg REST server with a real authentication mechanism (for example, an authenticating reverse proxy, API gateway, or other identity provider) and configure Gravitino to validate the authenticated identity, rather than trusting arbitrary usernames from the `Authorization` header.
#### Demo Steps

**Step 1: Start the Playground with Auth Enabled**

```shell
./playground.sh start --enable-auth
```

**Note**: The `--enable-auth` flag enables Gravitino's access control by removing the PassThroughAuthorizer, which allows proper privilege enforcement for the Iceberg REST catalog.

**Step 2: Create Users**

Create users through Gravitino's REST API:

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
  -d '{"name":"manager"}' \
  http://localhost:8090/api/metalakes/metalake_demo/owners
```

**Step 3: Create Database and Table with Manager**

Login to Spark container:

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

**Step 4: Test Access Control Before Granting Privileges**


Exit spark-sql and start a new session as data_analyst (without any privileges yet):

```shell
export HADOOP_USER_NAME=data_analyst
cd /opt/spark
/bin/bash bin/spark-sql  --conf spark.sql.catalog.catalog_rest.rest.auth.type=basic --conf spark.sql.catalog.catalog_rest.rest.auth.basic.username=data_analyst --conf spark.sql.catalog.catalog_rest.rest.auth.basic.password=123
```

Try to query the table (this should FAIL):

```sql
USE catalog_rest.demo_db;

-- This should FAIL - schema doesn't exist, because we don't have USE_SCHEMA privilege
```

**Step 5: Create Role with Privileges and Assign to User**

Exit spark-sql and create a role with the necessary privileges:

```shell
# Create role with all required privileges
curl -X POST -H "Accept: application/vnd.gravitino.v1+json" \
  -H "Content-Type: application/json" \
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
  -H "Content-Type: application/json" -d '{
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

Try to query the table again (this should SUCCEED now):

```sql
USE catalog_rest.demo_db;

-- This should succeed - now has SELECT_TABLE privilege
SELECT * FROM employees;
```

This demonstrates how Gravitino's access control works:
- Before granting privileges: Access denied
- After granting privileges: Access allowed

For more details, refer to the [Gravitino documentation](https://gravitino.apache.org/docs/latest/security/access-control).

### Using Gravitino Policies, Statistics, and Jobs to Drop Unused Tables

Gravitino 1.0+ provides a powerful combination of policies, statistics, and jobs that enables automated data governance tasks. This demo shows how to identify and drop tables that haven't been accessed for a long time, helping you manage data lifecycle and reduce storage costs.

**Workflow Overview:**
1. **Statistics** - Track table usage with custom statistics (e.g., `custom-lastAccessTime`)
2. **Policies** - Define rules for identifying unused tables (e.g., not accessed for 90 days)
3. **Jobs** - Execute automated actions to drop unused tables

#### Demo Steps

**Step 1: Start the Playground**

```shell
./playground.sh start
```

**Step 2: Update Statistics for an Existing Table**

The playground already has tables in the Hive catalog. We'll use one of the existing tables and update its statistics to simulate an old, unused table:

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

**Step 3: Create a Policy for Unused Tables**

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

**Step 4: Associate Policy with Tables**

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

**Step 5: Register a Job Template to Drop Unused Tables**

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

**Step 6: Run the Job to Drop Unused Tables**

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

**Step 7: Verify the Job Result**

Check the job execution status and result:

```shell
# Get the job run details (replace {jobRunId} with the actual ID from Step 6 response)
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

You can also verify the table was actually dropped:

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

**Key Concepts:**

- **Statistics**: Track custom metrics like `custom-lastAccessTime` to monitor table usage
- **Policies**: Define governance rules to identify tables that meet certain criteria (e.g., idle for 90+ days)
- **Jobs**: Execute automated actions (drop tables) based on policy evaluation
- **Metadata-driven actions**: Use Gravitino's metadata (statistics, policies) to drive data governance decisions

This approach enables:
- ✅ Automated data lifecycle management
- ✅ Cost reduction by removing unused data
- ✅ Compliance with data retention policies
- ✅ Centralized governance across multiple catalogs

For more details, refer to:
- [Manage Statistics in Gravitino](https://gravitino.apache.org/docs/latest/manage-statistics-in-gravitino)
- [Manage Policies in Gravitino](https://gravitino.apache.org/docs/latest/manage-policies-in-gravitino)
- [Manage Jobs in Gravitino](https://gravitino.apache.org/docs/latest/manage-jobs-in-gravitino)

## NOTICE

If you want to clean cache files, you can delete the directory `data` of this repo.

## ASF Incubator disclaimer

Apache Gravitino is an effort undergoing incubation at The Apache Software Foundation (ASF), sponsored by the Apache Incubator. Incubation is required of all newly accepted projects until a further review indicates that the infrastructure, communications, and decision making process have stabilized in a manner consistent with other successful ASF projects. While incubation status is not necessarily a reflection of the completeness or stability of the code, it does indicate that the project has yet to be fully endorsed by the ASF.

<sub>Apache®, Apache Gravitino&trade;, Apache Hive&trade;, Apache Iceberg&trade;, and Apache Spark&trade; are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.</sub>

