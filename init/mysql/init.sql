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
GRANT ALL PRIVILEGES on *.* to 'mysql'@'%';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS `demo_llamaindex`;
CREATE TABLE IF NOT EXISTS `demo_llamaindex`.`city_stats`  (
  `city_name` text,
  `population` int DEFAULT NULL,
  `country` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `demo_llamaindex`.`city_stats` (city_name, population, country) VALUES ("Toronto", 2930000, "Canada");
INSERT INTO `demo_llamaindex`.`city_stats` (city_name, population, country) VALUES ("Tokyo", 13960000, "Japan");
INSERT INTO `demo_llamaindex`.`city_stats` (city_name, population, country) VALUES ("Berlin", 3645000, "Germany");
