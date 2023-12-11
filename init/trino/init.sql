/*
 * Copyright 2023 Datastrato Pvt Ltd.
 * This software is licensed under the Apache License version 2.
 */

create schema "metalake_demo.catalog_demo".sales with (location = 'hdfs://hive:9000/user/hive/warehouse/sales.db');

CREATE TABLE  "metalake_demo.catalog_demo".sales.categories (category_id int,category_name varchar(100));

CREATE TABLE "metalake_demo.catalog_demo".sales.customers (customer_id int, customer_name varchar(100), customer_email varchar(100));

CREATE TABLE "metalake_demo.catalog_demo".sales.products (product_id int, category_id int, product_name varchar(100), price decimal);

CREATE TABLE "metalake_demo.catalog_demo".sales.sales (sale_id int, employee_id int, store_id int, product_id int, customer_id int, sold date, quantity int, total_amount decimal);

CREATE TABLE "metalake_demo.catalog_demo".sales.stores (store_id int, store_name varchar(100), location varchar(100));

insert into "metalake_demo.catalog_demo".sales.categories (category_id, category_name) values (1,'Bakeware');
insert into "metalake_demo.catalog_demo".sales.categories (category_id, category_name) values (2,'Book');
insert into "metalake_demo.catalog_demo".sales.categories (category_id, category_name) values (3,'Toy');

insert into "metalake_demo.catalog_demo".sales.stores (store_id, store_name, location) values (1,'Manager store','1.5');
insert into "metalake_demo.catalog_demo".sales.stores (store_id, store_name, location) values (2,'Manager store','1.5');
insert into "metalake_demo.catalog_demo".sales.stores (store_id, store_name, location) values (3,'Senior Manager store','2');
insert into "metalake_demo.catalog_demo".sales.stores (store_id, store_name, location) values (4,'Programmer store','1.5');
insert into "metalake_demo.catalog_demo".sales.stores (store_id, store_name, location) values (5,'Programmer store','1.5');
insert into "metalake_demo.catalog_demo".sales.stores (store_id, store_name, location) values (6,'Store Manager store','2');
insert into "metalake_demo.catalog_demo".sales.stores (store_id, store_name, location) values (7,'Sales Manager store','1.3');

insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (1,3,'Cars',16.99);
insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (2,2,'Chinese stories',129.99);
insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (3,2,'Health magazine',2.99);
insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (4,1,'Cookie Sheet',14.99);
insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (5,1,'Macaron Baking Mat',24.99);
insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (6,1,'Non-Stick Baking Sheet',28.0);
insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (7,1,'Marble Rolling Pin',27.99);
insert into "metalake_demo.catalog_demo".sales.products (product_id, category_id, product_name, price) values (8,1,'Beech Wood Rolling Pin',24.99);

insert into "metalake_demo.catalog_demo".sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values (1,1,1,7,9,date '2023-02-16',2,87.98);
insert into "metalake_demo.catalog_demo".sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values (2,2,2,5,9,date '2023-04-24',2,129.98);
insert into "metalake_demo.catalog_demo".sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values (3,1,3,5,3,date '2022-11-17',2,43.98);
insert into "metalake_demo.catalog_demo".sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values (4,2,1,4,1,date '2022-02-23',3,269.9);
insert into "metalake_demo.catalog_demo".sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values (5,2,2,3,10,date '2023-03-02',2,25.98);
insert into "metalake_demo.catalog_demo".sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values (6,2,3,7,3,date '2023-10-09',1,24.99);

insert into "metalake_demo.catalog_demo".sales.customers (customer_id, customer_name, customer_email) values (1,'Lesley Chapman','lesleychapman5721@aol.net');
insert into "metalake_demo.catalog_demo".sales.customers (customer_id, customer_name, customer_email) values (2,'Salvador Bean','salvadorbean@protonmail.edu');
insert into "metalake_demo.catalog_demo".sales.customers (customer_id, customer_name, customer_email) values (3,'Ifeoma Pollard','ifeomapollard@icloud.edu');
