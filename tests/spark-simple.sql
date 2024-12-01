USE catalog_hive;
CREATE DATABASE IF NOT EXISTS product;
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

use catalog_rest;
create database sales;
use sales;
create table customers (customer_id int, customer_name varchar(100), customer_email varchar(100));
describe extended customers;
insert into customers (customer_id, customer_name, customer_email) values (11,'Rory Brown','rory@123.com');
insert into customers (customer_id, customer_name, customer_email) values (12,'Jerry Washington','jerry@dt.com');

use catalog_iceberg;
use mydb;
create table abc(a int, b int) partitioned by (a)  TBLPROPERTIES ('format-version'='2', 'write.merge.mode'='merge-on-read', 'write.delete.mode'='merge-on-read');
insert into abc values(1,2);
insert into abc values(2,3);
insert into abc values(3,4);
update abc set a = 4 where b = 4;
delete from abc where a = 1;
merge into abc USING (select 2 as a,20 as b) as t on abc.a = t.a when matched then update set * when not matched then insert *;
merge into abc USING (select 8 as a,8 as b) as t on abc.a = t.a when matched then update set * when not matched then insert *;

select * from catalog_iceberg.mydb.example_table;

select * from catalog_hive.product.page_views where country = 'USA';