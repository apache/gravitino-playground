/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

create schema catalog_hive.sales with (location = 'hdfs://hive:9000/user/hive/warehouse/sales.db');

CREATE TABLE  catalog_hive.sales.categories (category_id int,category_name varchar(100));

CREATE TABLE catalog_hive.sales.customers (customer_id int, customer_name varchar(100), customer_email varchar(100));

CREATE TABLE catalog_hive.sales.products (product_id int, category_id int, product_name varchar(100), price decimal(10,2));

CREATE TABLE catalog_hive.sales.sales (sale_id int, employee_id int, store_id int, product_id int, customer_id int, sold date, quantity int, total_amount decimal(10,2));

CREATE TABLE catalog_hive.sales.stores (store_id int, store_name varchar(100), location varchar(100));

insert into catalog_hive.sales.stores (store_id, store_name, location) values
(1,'Lincoln store','Nebraska'),(2,'Montpelier store','Vermont'),(3,'Olathe store','Kansas'),
(1,'Lincoln store','Nebraska'),(2,'Montpelier store','Vermont'),(3,'Olathe store','Kansas'),
(4,'Dallas store','Texas'),(5,'Bellevue store','Nebraska'),(6,'Wichita store','Kansas'),
(10,'Akron store','Ohio');
insert into catalog_hive.sales.categories (category_id, category_name) values
(1,'Bakeware'),(2,'Coffee & Tea'),(3,'Candles'),(4,'Cookware'),(5,'Dinnerware'),
(6,'Glassware'),(7,'Kitchenware'),(8,'Knives'),(9,'Tableware'),(10,'Outdoor');
insert into catalog_hive.sales.products (product_id, category_id, product_name, price) values
(1,8,'Steak knife (set of 6)',16.99),(1,8,'Steak knife (set of 6)',16.99),(2,4,'Induction non stick frypan',129.99),
(4,1,'Cookie Sheet',14.99),(4,1,'Cookie Sheet',14.99),(5,1,'Macaron Baking Mat',24.99),
(7,1,'Marble Rolling Pin',27.99),(7,1,'Marble Rolling Pin',27.99),(8,1,'Beech Wood Rolling Pin',24.99),
(10,1,'Chocolate Mould Heart',12.99),(10,1,'Chocolate Mould Heart',12.99),(11,1,'Chocolate Mould Dome',12.99),
(13,1,'Round Cooling Rack',15.99),(13,1,'Round Cooling Rack',15.99),(14,4,'Frying Pan (large)',149.99),
(16,4,'Saute Pan (large)',139.99),(16,4,'Saute Pan (large)',139.99),(17,4,'Saute Pan (medium',79.99),
(19,4,'Saucepan (small)',99.99),(19,4,'Saucepan (small)',99.99),(20,4,'Skillet (large)',159.99),
(22,4,'Paella Pan (large)',59.99),(22,4,'Paella Pan (large)',59.99),(23,4,'Paella Pan (medium)',54.99),
(25,5,'12 Piece Dinner Set Black',69.99),(25,5,'12 Piece Dinner Set Black',69.99),(26,5,'12 Piece Dinner Set Teal',69.99),
(28,9,'40 Piece Cutlery Set',169.99),(28,9,'40 Piece Cutlery Set',169.99),(29,9,'24 Piece Cutlery Set',99.99),
(31,6,'6 Piece White Wine Glass Set',44.99),(31,6,'6 Piece White Wine Glass Set',44.99),(32,6,'6 Piece Red Wine Glass Set',44.99),
(34,2,'6 Cup Espresso Maker',39.99),(34,2,'6 Cup Espresso Maker',39.99),(35,2,'9 Cup Espresso Maker',49.99),
(37,2,'3 Cup Plunger',39.99),(37,2,'3 Cup Plunger',39.99),(38,2,'Tea Pot 1.2L',79.99),
(40,2,'Blue Stovetop Kettle 2.2L',59.99),(40,2,'Blue Stovetop Kettle 2.2L',59.99),(41,8,'Japanese Steel Chef Knife (medium)',399.99),
(43,8,'Pro Chefs Knife (medium)',64.99);
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (1,'Nasim Duke','nasimduke@hotmail.net');
insert into catalog_hive.sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values
(1,29,2,26,5,from_iso8601_date('2022-10-05'),3,689.97),(1,29,2,26,5,from_iso8601_date('2022-10-05'),3,689.97),(2,40,2,40,9,from_iso8601_date('2023-08-27'),3,1199.97),
(4,10,2,28,9,from_iso8601_date('2022-09-08'),3,299.96999999999997),(5,46,2,13,2,from_iso8601_date('2022-10-22'),1,149.99),(6,32,2,18,6,from_iso8601_date('2023-03-21'),1,99.99);
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (2,'Perry Tyler','perrytyler@outlook.com');
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (3,'Leah Swanson','leahswanson1069@protonmail.com');
insert into catalog_hive.sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values
(1,26,4,33,2,from_iso8601_date('2022-12-14'),3,119.97),(1,26,4,33,2,from_iso8601_date('2022-12-14'),3,119.97),(2,44,4,7,3,from_iso8601_date('2022-06-12'),1,24.99),
(4,41,4,30,1,from_iso8601_date('2023-10-12'),3,134.97),(4,41,4,30,1,from_iso8601_date('2023-10-12'),3,134.97),(5,22,4,40,5,from_iso8601_date('2023-04-12'),2,799.98),
(7,1,4,15,4,from_iso8601_date('2023-11-25'),1,139.99),(7,1,4,15,4,from_iso8601_date('2023-11-25'),1,139.99),(8,30,4,5,7,from_iso8601_date('2023-06-29'),1,28.0),
(10,21,4,26,9,from_iso8601_date('2023-09-17'),2,459.98),(10,21,4,26,9,from_iso8601_date('2023-09-17'),2,459.98),(11,46,4,41,1,from_iso8601_date('2023-11-12'),2,569.98),
(13,28,4,29,6,from_iso8601_date('2023-03-28'),1,44.99);
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (4,'Mia Hahn','miahahn@yahoo.edu');
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (5,'Quin Hurst','quinhurst5485@google.net');
insert into catalog_hive.sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values
(1,18,6,24,7,from_iso8601_date('2022-09-12'),2,139.98),(1,18,6,24,7,from_iso8601_date('2022-09-12'),2,139.98),(2,41,6,41,3,from_iso8601_date('2023-09-10'),3,1139.97),
(4,6,6,21,1,from_iso8601_date('2023-09-24'),2,119.98),(4,6,6,21,1,from_iso8601_date('2023-09-24'),2,119.98),(5,49,6,17,5,from_iso8601_date('2023-07-24'),1,89.99),
(7,11,6,42,3,from_iso8601_date('2022-12-22'),3,194.96999999999997),(7,11,6,42,3,from_iso8601_date('2022-12-22'),3,194.96999999999997),(8,48,6,17,4,from_iso8601_date('2023-03-20'),3,256.46999999999997),
(10,18,6,30,5,from_iso8601_date('2023-09-29'),2,89.98),(10,18,6,30,5,from_iso8601_date('2023-09-29'),2,89.98),(11,42,6,35,7,from_iso8601_date('2022-06-02'),1,49.49),
(13,46,6,27,6,from_iso8601_date('2023-09-09'),3,509.97),(13,46,6,27,6,from_iso8601_date('2023-09-09'),3,509.97),(14,32,6,7,3,from_iso8601_date('2023-11-14'),3,74.97),
(16,11,6,39,1,from_iso8601_date('2023-07-07'),1,59.99),(16,11,6,39,1,from_iso8601_date('2023-07-07'),1,59.99),(17,25,6,34,9,from_iso8601_date('2023-02-27'),1,49.99),
(19,15,6,39,9,from_iso8601_date('2023-10-04'),1,59.99),(19,15,6,39,9,from_iso8601_date('2023-10-04'),1,59.99),(20,19,6,23,7,from_iso8601_date('2023-03-30'),2,139.98),
(22,6,6,39,2,from_iso8601_date('2022-10-23'),3,179.97),(22,6,6,39,2,from_iso8601_date('2022-10-23'),3,179.97),(23,24,6,30,9,from_iso8601_date('2023-07-27'),1,44.99),
(25,15,6,28,8,from_iso8601_date('2023-10-25'),3,299.96999999999997),(26,21,6,7,5,from_iso8601_date('2023-03-26'),2,49.98);
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (6,'Harriet Best','harrietbest2890@icloud.com');
insert into catalog_hive.sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values
(1,28,7,15,5,from_iso8601_date('2023-10-24'),3,419.97),(1,28,7,15,5,from_iso8601_date('2023-10-24'),3,419.97),(2,11,7,3,9,from_iso8601_date('2023-10-31'),3,44.97),
(4,19,7,11,1,from_iso8601_date('2023-05-05'),3,65.97),(4,19,7,11,1,from_iso8601_date('2023-05-05'),3,65.97),(5,47,7,41,9,from_iso8601_date('2022-12-14'),2,759.98),
(7,24,7,13,5,from_iso8601_date('2023-11-24'),3,449.97),(8,26,7,27,4,from_iso8601_date('2022-05-08'),1,169.99),(9,34,7,28,2,from_iso8601_date('2022-08-25'),1,99.99);
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (7,'Erasmus Phelps','erasmusphelps9105@protonmail.net');
insert into catalog_hive.sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values
(1,13,8,42,8,from_iso8601_date('2023-11-10'),3,194.96999999999997),(1,13,8,42,8,from_iso8601_date('2023-11-10'),3,194.96999999999997),(2,42,8,21,6,from_iso8601_date('2023-02-19'),2,119.98),
(4,23,8,37,7,from_iso8601_date('2023-08-25'),3,239.96999999999997),(4,23,8,37,7,from_iso8601_date('2023-08-25'),3,239.96999999999997),(5,16,8,19,3,from_iso8601_date('2023-08-18'),2,319.98),
(7,24,8,23,3,from_iso8601_date('2022-12-11'),1,69.99),(7,24,8,23,3,from_iso8601_date('2022-12-11'),1,69.99),(8,47,8,15,6,from_iso8601_date('2023-10-02'),3,419.97),
(10,15,8,15,8,from_iso8601_date('2022-06-10'),2,279.98),(10,15,8,15,8,from_iso8601_date('2022-06-10'),2,279.98),(11,34,8,30,6,from_iso8601_date('2022-10-12'),3,134.97),
(13,28,8,42,1,from_iso8601_date('2023-08-16'),1,64.99),(14,8,8,36,8,from_iso8601_date('2022-04-24'),3,119.97),(15,36,8,42,7,from_iso8601_date('2023-11-26'),2,129.98);
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (8,'Lenore Wilder','lenorewilder@aol.net');
insert into catalog_hive.sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values
(1,45,9,18,6,from_iso8601_date('2022-12-28'),1,99.99),(1,45,9,18,6,from_iso8601_date('2022-12-28'),1,99.99),(2,22,9,1,9,from_iso8601_date('2023-04-20'),1,97.49),
(4,52,9,19,7,from_iso8601_date('2023-09-16'),2,319.98),(4,52,9,19,7,from_iso8601_date('2023-09-16'),2,319.98),(5,37,9,7,6,from_iso8601_date('2022-12-09'),2,49.98),
(7,18,9,41,1,from_iso8601_date('2023-08-17'),1,284.99),(7,18,9,41,1,from_iso8601_date('2023-08-17'),1,284.99),(8,42,9,36,7,from_iso8601_date('2023-06-16'),2,75.98),
(10,21,9,2,1,from_iso8601_date('2023-02-04'),1,2.39),(10,21,9,2,1,from_iso8601_date('2023-02-04'),1,2.39),(11,42,9,20,7,from_iso8601_date('2023-07-06'),2,239.98),
(13,41,9,18,5,from_iso8601_date('2023-06-30'),2,199.98),(13,41,9,18,5,from_iso8601_date('2023-06-30'),2,199.98),(14,13,9,22,5,from_iso8601_date('2023-01-07'),1,54.99),
(16,26,9,4,6,from_iso8601_date('2023-06-28'),2,49.98),(16,26,9,4,6,from_iso8601_date('2023-06-28'),2,49.98),(17,8,9,29,9,from_iso8601_date('2023-02-10'),3,134.97),
(19,37,9,25,5,from_iso8601_date('2023-01-12'),1,69.99),(20,24,9,21,8,from_iso8601_date('2023-11-28'),1,59.99),(21,6,9,37,4,from_iso8601_date('2023-08-13'),2,135.98);
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (9,'Raya Mcguire','rayamcguire@hotmail.com');
insert into catalog_hive.sales.customers (customer_id, customer_name, customer_email) values (10,'Ronan Joyner','ronanjoyner5549@aol.com');
insert into catalog_hive.sales.sales (sale_id, employee_id, customer_id, product_id, store_id, sold, quantity, total_amount) values (1,40,11,33,2,from_iso8601_date('2023-05-12'),1,37.99);
