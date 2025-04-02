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

CREATE SCHEMA catalog_iceberg.mydb;

USE catalog_iceberg.mydb;
CREATE TABLE example_table (    c1 INTEGER,    c2 DATE,    c3 DOUBLE)WITH ( partitioning = ARRAY['c1', 'c2'],    sorted_by = ARRAY['c3'],    location = 'hdfs://hive:9000/example_table');
INSERT INTO example_table (c1, c2, c3)VALUES     (1, DATE '2021-01-01', 10.5),    (2, DATE '2021-01-02', 20.5),    (3, DATE '2021-01-03', 30.75);

CREATE SCHEMA catalog_hive.product;

USE catalog_hive.product;
CREATE TABLE page_views (  view_time TIMESTAMP,  user_id BIGINT,  page_url VARCHAR,  ds DATE,  country VARCHAR)WITH (  format = 'ORC',  partitioned_by = ARRAY['ds', 'country'],  bucketed_by = ARRAY['user_id'],  bucket_count = 50);
INSERT INTO page_views (view_time, user_id, page_url, ds, country)VALUES   (TIMESTAMP '2023-12-01 08:15:30', 123457, 'http://example.com/about', DATE '2023-12-01', 'USA'),  (TIMESTAMP '2023-12-01 09:20:45', 123458, 'http://example.com/contact', DATE '2023-12-01', 'Canada'),  (TIMESTAMP '2023-12-01 10:25:50', 123459, 'http://example.com/blog', DATE '2023-12-01', 'UK');