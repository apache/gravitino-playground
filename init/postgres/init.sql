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
CREATE DATABASE db;
\c db;

CREATE SCHEMA HR;
-- HR.departments definition

CREATE TABLE HR.departments (
    department_id int4 NULL,
    department_name varchar(100) NULL
);


-- HR.employee_address definition

CREATE TABLE HR.employee_address (
    address_id int4 NULL,
    employee_id int4 NULL,
    address_line1 varchar(100) NULL,
    address_line2 varchar(100) NULL,
    city varchar(100) NULL,
    state varchar(100) NULL,
    postal_code varchar(20) NULL
);


-- HR.employee_contacts definition

CREATE TABLE HR.employee_contacts (
    contact_id int4 NULL,
    employee_id int4 NULL,
    phone_number varchar(20) NULL,
    email varchar(100) NULL
);

-- HR.employee_performance definition

CREATE TABLE HR.employee_performance (
    employee_id int4 NULL,
    evaluation_date date NULL,
    rating int4 NULL
);
COMMENT ON TABLE hr.employee_performance IS 'comment';

-- HR.employee_training definition

CREATE TABLE HR.employee_training (
    training_id int4 NULL,
    employee_id int4 NULL,
    training_name varchar(100) NULL,
    start_date date NULL,
    end_date date NULL
);
COMMENT ON TABLE hr.employee_training IS 'comment';

-- HR.employees definition

CREATE TABLE HR.employees (
    employee_id int4 NULL,
    department_id int4 NULL,
    job_title varchar(100) NULL,
    given_name varchar(100) NULL,
    family_name varchar(100) NULL,
    birth_date date NULL,
    hire_date date NULL
);
COMMENT ON TABLE hr.employees IS 'comment';

-- HR.salaries definition

CREATE TABLE HR.salaries (
    salary_id int4 NULL,
    employee_id int4 NULL,
    amount float NULL,
    effective_date date NULL
);
COMMENT ON TABLE hr.salaries IS 'comment';

insert into hr.departments (department_id, department_name) values
(1,'Sales'),(2,'IT'),(3,'Accounting'),(4,'Customer Service');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (1,3,'Sales Assistant','Gregory','Smith','1969-Nov-02','2021-Apr-23');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (1,1,'P.O. Box 502, 6281 Arcu. St.','','Detroit','23674','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (1,1,'1-572-573-9795','Gregory.Smith@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (1,1,'2023-11-23',60000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (2,1,'Store Manager','Owen','Rivers','1971-Sep-18','2011-Feb-10');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (2,2,'Ap #469-5929 Dapibus Ave','','Metairie','55765','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (2,2,'1-191-811-0472','Owen.Rivers@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (2,2,'2015-07-19',216000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (3,3,'Programmer','Avram','Lawrence','1994-Jan-16','2016-Mar-26');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (3,3,'661-7101 Molestie. Av.','','Madison','88882','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (3,3,'(551) 454-0653','Avram.Lawrence@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (3,3,'2019-09-03',115500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(3,7.5,'2017-05-18'),(3,2.5,'2019-06-13'),(3,7.5,'2017-06-03'),(3,7.0,'2019-09-17');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(1,3,'Stress Management','2022-03-15','2022-03-16'), (2,3,'Occupational Health and Safety','2016-12-08','2016-12-10'),(3,3,'Effective Time Management','2022-08-12','2022-08-14'),
(4,3,'Team Building and Collaboration','2023-09-08','2023-09-09'),(5,3,'Effective Time Management','2023-08-26','2023-08-28'),(6,3,'Intellectual Property Rights','2017-03-31','2017-04-03'),
(7,3,'Mindfulness in the Workplace','2021-10-22','2021-10-25'),(8,3,'Sales Negotiation Skills','2020-01-16','2020-01-16'),(9,3,'Mindfulness in the Workplace','2022-07-18','2022-07-18'),
(10,3,'Sales Negotiation Skills','2017-10-09','2017-10-09'),(11,3,'Effective Time Management','2018-05-20','2018-05-23'),(12,3,'Diversity and Inclusion Training','2017-03-31','2017-04-03');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (4,1,'Senior Manager','Burton','Everett','2008-Apr-28','2011-Mar-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (4,4,'Ap #450-2944 Amet, Road','','Newport News','74773','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (4,4,'1-480-467-1020','Burton.Everett@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (4,4,'2021-09-02',213500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (4,9.0,'2017-02-12');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (5,3,'Manager','Cedric','Barlow','1983-Jan-15','2022-Nov-07');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (5,5,'P.O. Box 956, 5202 Velit St.','','Glendale','72757','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (5,5,'1-651-444-8356','Cedric.Barlow@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (5,5,'2023-07-07',68000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (6,3,'Store Manager','Jasper','Mack','1969-May-16','2016-Nov-02');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (6,6,'P.O. Box 361, 7432 Massa. Rd.','','Omaha','85134','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (6,6,'(647) 257-7221','Jasper.Mack@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (6,6,'2023-11-26',159000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(6,6.0,'2017-10-13'),(6,3.5,'2019-03-26'),(6,1.5,'2018-12-28');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(13,6,'Cybersecurity Awareness','2023-01-14','2023-01-17'),(14,6,'Team Building and Collaboration','2018-05-30','2018-05-30'),(15,6,'Cybersecurity Awareness','2017-11-24','2017-11-27'),
(16,6,'Occupational Health and Safety','2018-01-08','2018-01-11'),(17,6,'Intellectual Property Rights','2022-06-09','2022-06-12'),(18,6,'Effective Time Management','2017-09-23','2017-09-24'),
(19,6,'Cross-Cultural Communication','2021-05-19','2021-05-19'),(20,6,'Cybersecurity Awareness','2021-10-13','2021-10-13'),(21,6,'Business Ethics and Compliance','2018-02-16','2018-02-19'),
(22,6,'Handling Difficult Customers','2018-08-28','2018-08-28'),(23,6,'Effective Business Writing','2019-02-24','2019-02-26'),(24,6,'Risk Management','2021-02-28','2021-03-03');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (7,3,'Programmer','Felicia','Robinson','1966-Jul-24','2016-Apr-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (7,7,'141-9619 Sit Street','','Savannah','91107','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (7,7,'1-995-222-4055','Felicia.Robinson@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (7,7,'2021-03-09',122500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (8,3,'Manager','Mason','Steele','1966-Jan-23','2023-Sep-19');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (8,8,'P.O. Box 329, 6884 Lacinia St.','','Detroit','99703','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (8,8,'1-481-174-9664','Mason.Steele@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (8,8,'2023-11-28',61000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (9,3,'Programmer','Bernard','Cameron','1987-Nov-05','2014-Jan-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (9,9,'4176 Eu Rd.','','Las Vegas','83165','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (9,9,'1-542-461-8463','Bernard.Cameron@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (9,9,'2022-09-30',138000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(9,5.0,'2017-02-02'),(9,7.5,'2018-07-10'),(9,3.5,'2023-10-27'),(9,4.5,'2023-08-22'),
(9,5.5,'2018-12-11'),(9,6.0,'2021-07-04'),(9,6.0,'2018-05-19'),(9,6.0,'2015-03-13');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(25,9,'Stress Management','2020-05-28','2020-05-30'),(26,9,'Sales Negotiation Skills','2015-10-24','2015-10-27'),(27,9,'Intellectual Property Rights','2019-03-08','2019-03-09'),
(28,9,'Occupational Health and Safety','2020-06-27','2020-06-28'),(29,9,'Cross-Cultural Communication','2016-09-02','2016-09-02'),(30,9,'Business Ethics and Compliance','2017-09-10','2017-09-10'),
(31,9,'Cybersecurity Awareness','2015-01-24','2015-01-27'),(32,9,'Business Ethics and Compliance','2022-10-08','2022-10-09'),(33,9,'Presentation Skills','2017-04-12','2017-04-13'),
(34,9,'Handling Difficult Customers','2018-10-21','2018-10-23'),(35,9,'Interpersonal Communication','2014-07-28','2014-07-29'),(36,9,'Mindfulness in the Workplace','2019-04-13','2019-04-16'),
(37,9,'Effective Business Writing','2016-11-14','2016-11-15'),(38,9,'Business Ethics and Compliance','2014-11-20','2014-11-23'),(39,9,'Presentation Skills','2020-06-01','2020-06-04'),
(40,9,'Risk Management','2017-03-02','2017-03-05'),(41,9,'Introduction to Cloud Computing','2014-06-26','2014-06-26');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (10,2,'Manager','Chelsea','Wade','1993-Jul-12','2021-Aug-29');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (10,10,'Ap #505-1050 Etiam Av.','','Essex','94858','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (10,10,'(247) 937-7164','Chelsea.Wade@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (10,10,'2022-07-31',85000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (10,5.0,'2021-12-17');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (11,1,'Sales Assistant','Clarke','Sanders','1972-Jan-08','2013-Jun-22');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (11,11,'3461 Congue, Street','','Jonesboro','94889','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (11,11,'1-560-427-6685','Clarke.Sanders@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (11,11,'2019-01-08',99000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(11,6.5,'2023-10-25'),(11,4.5,'2020-11-19'),(11,6.0,'2015-01-16'),(11,5.5,'2022-10-07'),
(11,5.0,'2018-10-16'),(11,5.5,'2014-07-29');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(42,11,'Presentation Skills','2019-11-06','2019-11-07'),(43,11,'Risk Management','2022-09-07','2022-09-08'),(44,11,'Mindfulness in the Workplace','2015-01-02','2015-01-02'),
(45,11,'Effective Business Writing','2018-07-16','2018-07-17');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (12,2,'Sales Assistant','Jaime','Erickson','1997-Apr-02','2019-Jul-01');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (12,12,'102-1834 Nonummy Road','','Aurora','32063','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (12,12,'1-709-417-2772','Jaime.Erickson@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (12,12,'2020-12-21',67500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (13,2,'Sales Assistant','Risa','Barber','1979-Sep-17','2012-Nov-24');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (13,13,'P.O. Box 354, 5362 Morbi Rd.','','Eugene','62170','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (13,13,'1-472-245-9477','Risa.Barber@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (13,13,'2022-02-03',96500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(13,8.0,'2020-08-10'),(13,6.5,'2021-05-13'),(13,5.5,'2022-03-10'),(13,7.0,'2016-10-19');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(46,13,'Creative Problem Solving','2012-12-06','2012-12-06'),(47,13,'Stress Management','2018-09-20','2018-09-20'),(48,13,'Intellectual Property Rights','2018-04-22','2018-04-24'),
(49,13,'Presentation Skills','2022-02-13','2022-02-15');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (14,2,'Programmer','Fritz','Savage','1999-Jun-14','2012-Jun-07');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (14,14,'Ap #933-9369 Quis St.','','Little Rock','18874','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (14,14,'1-824-956-2152','Fritz.Savage@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (14,14,'2015-09-21',150000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(14,3.5,'2021-10-13'),(14,3.0,'2015-08-04'),(14,2.5,'2020-02-05'),(14,1.0,'2017-08-17');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (15,1,'Sales Assistant','Oprah','Noel','1997-May-27','2016-Mar-21');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (15,15,'Ap #983-9306 Lacus. St.','','Birmingham','47546','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (15,15,'(467) 334-0246','Oprah.Noel@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (15,15,'2020-04-13',84000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(15,7.5,'2016-12-18'),(15,1.5,'2023-11-29');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(50,15,'Stress Management','2019-04-03','2019-04-03'),(51,15,'Effective Time Management','2020-07-30','2020-07-31'),(52,15,'Intellectual Property Rights','2022-01-20','2022-01-21'),
(53,15,'Interpersonal Communication','2017-05-23','2017-05-24'),(54,15,'Cybersecurity Awareness','2020-07-31','2020-07-31'),(55,15,'Risk Management','2020-09-27','2020-09-29'),
(56,15,'Creative Problem Solving','2019-09-09','2019-09-12'),(57,15,'Interpersonal Communication','2018-03-31','2018-03-31'),(58,15,'Mindfulness in the Workplace','2018-10-06','2018-10-08');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (16,3,'Store Manager','Bradley','Phelps','1988-Apr-29','2021-Jul-19');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (16,16,'Ap #516-3675 Sit Rd.','','Jonesboro','32565','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (16,16,'(144) 682-1257','Bradley.Phelps@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (16,16,'2022-05-15',100500.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (59,16,'Stress Management','2023-08-10','2023-08-10');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (17,3,'Sales Assistant','Kasper','Madden','2008-May-02','2018-Jun-27');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (17,17,'375-397 Consequat Avenue','','Lewiston','31156','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (17,17,'(287) 552-1876','Kasper.Madden@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (17,17,'2018-11-23',70500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (17,3.0,'2021-06-23');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (18,2,'Manager','Carolyn','Bradshaw','2002-Apr-09','2020-Aug-26');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (18,18,'P.O. Box 898, 5027 In St.','','Pocatello','79654','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (18,18,'1-343-926-4042','Carolyn.Bradshaw@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (18,18,'2021-11-01',86500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (18,7.0,'2021-04-02');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (19,3,'Sales Assistant','Xyla','Le','1978-Jul-31','2019-Dec-16');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (19,19,'Ap #744-8916 Leo. St.','','Cheyenne','60351','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (19,19,'(302) 816-9038','Xyla.Le@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (19,19,'2020-04-13',62000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (19,4.0,'2022-03-24');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (60,19,'Handling Difficult Customers','2021-10-28','2021-10-29');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (20,1,'Sales Assistant','Wanda','Berry','1974-Jul-08','2014-Jan-29');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (20,20,'P.O. Box 224, 8229 Quis Rd.','','Portland','38580','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (20,20,'1-727-646-5887','Wanda.Berry@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (20,20,'2021-11-08',91000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(20,2.0,'2015-03-05'),(20,7.0,'2019-06-14'),(20,7.5,'2020-12-25'),(20,8.5,'2021-11-08');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (21,3,'Sales Assistant','Carol','Decker','2000-Sep-03','2017-Aug-21');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (21,21,'Ap #220-2142 Sit Rd.','','Provo','83418','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (21,21,'1-823-746-9366','Carol.Decker@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (21,21,'2018-10-15',72500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(21,5.0,'2018-11-14'),(21,5.0,'2023-02-26'),(21,6.5,'2020-09-29');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (22,2,'Store Manager','Quemby','Lucas','1989-Jan-07','2016-Sep-28');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (22,22,'Ap #827-314 Pede, Rd.','','Independence','72456','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (22,22,'(175) 217-4373','Quemby.Lucas@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (22,22,'2018-09-09',151500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (22,4.5,'2018-07-17');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(61,22,'Cybersecurity Awareness','2019-03-01','2019-03-03'),(62,22,'Effective Business Writing','2023-07-09','2023-07-09'),(63,22,'Effective Time Management','2023-07-24','2023-07-25');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (23,1,'Sales Assistant','Phoebe','Forbes','1998-Sep-25','2013-Jun-29');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (23,23,'P.O. Box 544, 5561 Penatibus Rd.','','Springdale','89771','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (23,23,'1-324-647-1218','Phoebe.Forbes@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (23,23,'2014-04-16',91000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(23,4.0,'2013-09-15'),(23,2.5,'2015-05-09'),(23,5.5,'2014-01-12'),(23,4.0,'2021-07-04');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (64,23,'Effective Business Writing','2023-11-04','2023-11-06');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (24,3,'Senior Manager','Jennifer','Albert','2008-Sep-02','2020-Aug-22');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (24,24,'594-8456 Posuere, Street','','Gresham','44738','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (24,24,'1-550-389-0531','Jennifer.Albert@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (24,24,'2022-02-07',112500.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(65,24,'Team Building and Collaboration','2023-01-14','2023-01-14'),(66,24,'Occupational Health and Safety','2023-12-04','2023-12-05');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (25,2,'Sales Assistant','Elijah','Burnett','1972-Jul-11','2013-Apr-02');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (25,25,'Ap #331-5545 Diam Ave','','Waterbury','45756','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (25,25,'(228) 376-0733','Elijah.Burnett@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (25,25,'2015-03-02',91000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(25,3.0,'2022-04-22'),(25,2.0,'2023-06-29'),(25,1.5,'2017-05-18'),(25,5.0,'2022-11-26'),
(25,7.0,'2013-07-04');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(67,25,'Presentation Skills','2015-12-23','2015-12-24'),(68,25,'Occupational Health and Safety','2016-07-25','2016-07-27'),(69,25,'Mindfulness in the Workplace','2019-03-18','2019-03-20'),
(70,25,'Stress Management','2018-03-22','2018-03-22'),(71,25,'Interpersonal Communication','2016-01-09','2016-01-11'),(72,25,'Mindfulness in the Workplace','2020-10-07','2020-10-09'),
(73,25,'Effective Time Management','2013-11-05','2013-11-07');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (26,3,'Sales Assistant','Kylie','Shepherd','1978-Feb-16','2021-Jun-18');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (26,26,'Ap #769-9248 Suspendisse St.','','Lawton','66437','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (26,26,'(247) 470-1548','Kylie.Shepherd@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (26,26,'2022-02-26',57500.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (74,26,'Effective Time Management','2022-07-30','2022-07-31');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (27,2,'Sales Assistant','Ina','Perez','2000-Jun-11','2011-Dec-02');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (27,27,'945-2248 Ipsum. St.','','Atlanta','20673','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (27,27,'(621) 302-0385','Ina.Perez@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (27,27,'2021-11-27',109500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(27,3.5,'2019-09-08'),(27,3.5,'2012-04-18'),(27,5.0,'2022-12-24'),(27,6.0,'2019-06-03');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(75,27,'Critical Thinking and Decision Making','2020-09-12','2020-09-12'),(76,27,'Effective Time Management','2013-10-05','2013-10-07');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (28,2,'Sales Assistant','Reuben','Rojas','1964-Dec-17','2010-Nov-01');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (28,28,'543-7825 Nec Rd.','','Austin','90795','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (28,28,'(260) 343-1566','Reuben.Rojas@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (28,28,'2011-05-22',111500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(28,5.0,'2021-06-01'),(28,4.5,'2011-01-12'),(28,5.0,'2020-09-17'),(28,2.0,'2016-03-14');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(77,28,'Effective Time Management','2022-03-30','2022-03-31'),(78,28,'Creative Problem Solving','2023-09-20','2023-09-21'),(79,28,'Intellectual Property Rights','2015-10-19','2015-10-21'),
(80,28,'Team Building and Collaboration','2019-07-27','2019-07-30'),(81,28,'Cybersecurity Awareness','2023-07-07','2023-07-09'),(82,28,'Business Ethics and Compliance','2015-08-12','2015-08-14'),
(83,28,'Diversity and Inclusion Training','2017-01-26','2017-01-27'),(84,28,'Creative Problem Solving','2021-01-03','2021-01-06');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (29,2,'Sales Assistant','Maxwell','Patel','1989-Aug-27','2010-Dec-13');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (29,29,'Ap #368-634 Elit Street','','Kansas City','40458','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (29,29,'1-286-873-2117','Maxwell.Patel@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (29,29,'2015-09-27',107500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(29,5.5,'2023-08-10'),(29,7.5,'2015-04-07');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(85,29,'Effective Business Writing','2011-07-27','2011-07-29'),(86,29,'Interpersonal Communication','2013-07-17','2013-07-18'),(87,29,'Introduction to Cloud Computing','2019-03-16','2019-03-18'),
(88,29,'Interpersonal Communication','2011-11-03','2011-11-04'),(89,29,'Business Ethics and Compliance','2017-10-14','2017-10-14'),(90,29,'Handling Difficult Customers','2014-02-23','2014-02-25'),
(91,29,'Effective Time Management','2011-10-13','2011-10-14'),(92,29,'Mindfulness in the Workplace','2021-11-19','2021-11-20'),(93,29,'Diversity and Inclusion Training','2015-03-09','2015-03-09'),
(94,29,'Business Ethics and Compliance','2011-11-14','2011-11-16'),(95,29,'Creative Problem Solving','2014-03-12','2014-03-14'),(96,29,'Introduction to Cloud Computing','2019-09-01','2019-09-03'),
(97,29,'Stress Management','2014-04-14','2014-04-15'),(98,29,'Risk Management','2015-07-28','2015-07-28'),(99,29,'Business Ethics and Compliance','2021-03-17','2021-03-19'),
(100,29,'Risk Management','2012-12-19','2012-12-19'),(101,29,'Intellectual Property Rights','2014-09-22','2014-09-24'),(102,29,'Sales Negotiation Skills','2017-01-25','2017-01-26'),
(103,29,'Cross-Cultural Communication','2011-08-25','2011-08-25'),(104,29,'Occupational Health and Safety','2015-06-21','2015-06-21'),(105,29,'Business Ethics and Compliance','2012-11-19','2012-11-22'),
(106,29,'Risk Management','2017-11-09','2017-11-12'),(107,29,'Creative Problem Solving','2012-09-29','2012-10-02');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (30,2,'Sales Manager','Edward','Reed','1989-Sep-22','2009-Aug-19');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (30,30,'6636 Pede Rd.','','Aurora','34583','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (30,30,'1-359-632-7521','Edward.Reed@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (30,30,'2015-10-26',146500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(30,9.0,'2012-08-19'),(30,6.0,'2012-05-06'),(30,5.0,'2016-01-21'),(30,6.0,'2022-03-11'),
(30,3.0,'2017-03-21'),(30,3.0,'2011-07-17');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(108,30,'Sales Negotiation Skills','2014-06-15','2014-06-15'),(109,30,'Risk Management','2016-09-12','2016-09-12'),(110,30,'Stress Management','2014-12-24','2014-12-25'),
(111,30,'Effective Business Writing','2022-04-14','2022-04-16'),(112,30,'Intellectual Property Rights','2021-04-06','2021-04-09'),(113,30,'Interpersonal Communication','2013-07-17','2013-07-19'),
(114,30,'Occupational Health and Safety','2012-03-27','2012-03-30'),(115,30,'Effective Business Writing','2011-06-22','2011-06-23'),(116,30,'Handling Difficult Customers','2022-11-05','2022-11-08'),
(117,30,'Handling Difficult Customers','2010-08-02','2010-08-04'),(118,30,'Intellectual Property Rights','2010-10-14','2010-10-17'),(119,30,'Team Building and Collaboration','2014-01-20','2014-01-21'),
(120,30,'Mindfulness in the Workplace','2023-04-19','2023-04-19'),(121,30,'Occupational Health and Safety','2017-09-19','2017-09-21'),(122,30,'Risk Management','2015-02-14','2015-02-17'),
(123,30,'Effective Business Writing','2016-10-22','2016-10-25'),(124,30,'Introduction to Cloud Computing','2013-01-19','2013-01-19'),(125,30,'Mindfulness in the Workplace','2014-03-05','2014-03-05'),
(126,30,'Presentation Skills','2012-03-14','2012-03-15');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (31,3,'Sales Assistant','Herrod','Gardner','1979-Jan-09','2010-Apr-30');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (31,31,'377 Mauris Avenue','','Gaithersburg','32206','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (31,31,'(974) 712-3626','Herrod.Gardner@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (31,31,'2021-09-21',109000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(31,4.0,'2013-03-25'),(31,3.0,'2015-05-28'),(31,9.5,'2014-11-06'),(31,1.0,'2018-03-12');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (32,1,'Programmer','Jesse','Contreras','2008-Feb-18','2012-Dec-09');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (32,32,'P.O. Box 209, 3080 Tellus. Road','','Paradise','88088','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (32,32,'1-835-357-3911','Jesse.Contreras@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (32,32,'2018-04-04',144500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(32,7.5,'2023-07-14'),(32,2.5,'2021-03-14'),(32,5.0,'2022-11-06'),(32,6.0,'2014-07-03'),
(32,3.0,'2021-08-15'),(32,5.0,'2018-04-16');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (33,2,'Sales Assistant','Arsenio','Oneil','1964-Apr-18','2013-Aug-31');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (33,33,'2524 Turpis Road','','Southaven','57603','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (33,33,'(851) 167-8111','Arsenio.Oneil@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (33,33,'2020-09-10',93500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(33,8.5,'2015-03-28'),(33,7.5,'2014-11-10');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(127,33,'Intellectual Property Rights','2018-11-24','2018-11-25'),(128,33,'Intellectual Property Rights','2022-09-29','2022-09-30'),(129,33,'Sales Negotiation Skills','2016-05-26','2016-05-28'),
(130,33,'Handling Difficult Customers','2018-03-29','2018-03-30'),(131,33,'Handling Difficult Customers','2014-03-18','2014-03-18'),(132,33,'Business Ethics and Compliance','2017-06-26','2017-06-29'),
(133,33,'Critical Thinking and Decision Making','2015-07-02','2015-07-04'),(134,33,'Introduction to Cloud Computing','2017-11-08','2017-11-11'),(135,33,'Risk Management','2018-11-19','2018-11-22'),
(136,33,'Sales Negotiation Skills','2018-03-01','2018-03-02'),(137,33,'Stress Management','2022-07-25','2022-07-25'),(138,33,'Cross-Cultural Communication','2014-08-27','2014-08-27');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (34,3,'Manager','Autumn','Leach','1973-Sep-06','2017-Nov-30');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (34,34,'117-5809 Tortor. Rd.','','Wilmington','75606','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (34,34,'1-211-248-7174','Autumn.Leach@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (34,34,'2018-12-24',111000.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(139,34,'Interpersonal Communication','2020-06-23','2020-06-24'),(140,34,'Introduction to Cloud Computing','2018-09-04','2018-09-06'),(141,34,'Mindfulness in the Workplace','2023-01-20','2023-01-23'),
(142,34,'Interpersonal Communication','2023-12-04','2023-12-07');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (35,3,'Sales Assistant','Vincent','Potter','2002-Jul-23','2014-Mar-06');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (35,35,'4332 Arcu Avenue','','Milwaukee','72473','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (35,35,'(517) 234-2362','Vincent.Potter@acme.com');
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(35,7.0,'2014-12-14'),(35,5.0,'2018-08-21'),(35,3.5,'2022-11-19');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(143,35,'Occupational Health and Safety','2014-12-04','2014-12-05'),(144,35,'Cross-Cultural Communication','2014-12-12','2014-12-14'),(145,35,'Occupational Health and Safety','2019-01-11','2019-01-13'),
(146,35,'Cybersecurity Awareness','2018-04-06','2018-04-09'),(147,35,'Effective Time Management','2023-11-29','2023-12-01'),(148,35,'Mindfulness in the Workplace','2022-03-03','2022-03-04'),
(149,35,'Mindfulness in the Workplace','2014-09-23','2014-09-25'),(150,35,'Introduction to Cloud Computing','2017-06-14','2017-06-17'),(151,35,'Effective Time Management','2018-11-16','2018-11-16'),
(152,35,'Diversity and Inclusion Training','2020-12-16','2020-12-16'),(153,35,'Cross-Cultural Communication','2017-03-27','2017-03-28'),(154,35,'Handling Difficult Customers','2018-09-25','2018-09-26'),
(155,35,'Mindfulness in the Workplace','2019-03-08','2019-03-08'),(156,35,'Effective Time Management','2022-02-19','2022-02-21'),(157,35,'Introduction to Cloud Computing','2017-11-13','2017-11-15'),
(158,35,'Effective Business Writing','2019-06-07','2019-06-07'),(159,35,'Stress Management','2023-01-11','2023-01-14'),(160,35,'Sales Negotiation Skills','2021-08-01','2021-08-04'),
(161,35,'Sales Negotiation Skills','2021-09-10','2021-09-12');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (36,2,'Sales Assistant','Amir','Flowers','1974-Aug-29','2017-Feb-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (36,36,'178-4244 Nunc Road','','Naperville','45214','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (36,36,'1-834-325-6642','Amir.Flowers@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (36,36,'2021-05-01',82500.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (162,36,'Stress Management','2021-02-16','2021-02-16');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (37,3,'Sales Assistant','Giselle','Battle','1992-Sep-21','2019-Nov-17');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (37,37,'529-1430 Quis Rd.','','Juneau','18718','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (37,37,'(446) 273-6113','Giselle.Battle@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (37,37,'2022-06-14',63500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (38,2,'Programmer','Preston','Owens','2006-Aug-19','2011-Dec-08');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (38,38,'Ap #845-8538 Vitae Ave','','Detroit','47235','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (38,38,'(368) 565-6463','Preston.Owens@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (38,38,'2015-10-09',151000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(38,2.5,'2023-10-25'),(38,7.0,'2017-07-14'),(38,7.0,'2012-11-05'),(38,7.5,'2017-08-14'),
(38,1.5,'2014-09-13'),(38,7.0,'2022-09-01'),(38,8.5,'2012-10-24'),(38,8.5,'2014-12-17'),
(38,4.5,'2015-11-25');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(164,38,'Sales Negotiation Skills','2019-05-04','2019-05-04'),(165,38,'Risk Management','2020-03-27','2020-03-27');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (39,2,'Programmer','Wade','Daniel','1979-Feb-06','2015-Aug-30');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (39,39,'Ap #982-8468 Vivamus Rd.','','Montpelier','46516','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (39,39,'1-735-258-9125','Wade.Daniel@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (39,39,'2020-02-11',122000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(39,3.0,'2017-07-10'),(39,7.0,'2018-06-18'),(39,3.5,'2018-05-14'),(39,9.5,'2018-09-01'),
(39,5.5,'2023-11-21');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (40,3,'Sales Assistant','Althea','Kelley','1988-Dec-21','2022-Mar-08');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (40,40,'Ap #418-4412 Sed Ave','','Huntsville','67749','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (40,40,'1-322-518-9286','Althea.Kelley@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (40,40,'2022-05-30',53000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (41,3,'Sales Assistant','Dale','Lindsey','1980-Mar-27','2015-Aug-28');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (41,41,'610-7468 Semper Road','','Provo','45163','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (41,41,'1-797-676-7218','Dale.Lindsey@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (41,41,'2016-01-02',89000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (41,6.5,'2019-09-04');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(166,41,'Presentation Skills','2023-09-15','2023-09-16'),(167,41,'Interpersonal Communication','2019-04-02','2019-04-02'),(168,41,'Critical Thinking and Decision Making','2022-10-08','2022-10-10'),
(169,41,'Introduction to Cloud Computing','2016-09-12','2016-09-12'),(170,41,'Cross-Cultural Communication','2017-06-02','2017-06-05'),(171,41,'Risk Management','2016-11-08','2016-11-11'),
(172,41,'Effective Business Writing','2020-02-24','2020-02-26'),(173,41,'Cross-Cultural Communication','2023-01-07','2023-01-09'),(174,41,'Creative Problem Solving','2019-01-02','2019-01-05'),
(175,41,'Cybersecurity Awareness','2021-06-27','2021-06-30'),(176,41,'Diversity and Inclusion Training','2017-06-23','2017-06-26'),(177,41,'Creative Problem Solving','2019-04-12','2019-04-15'),
(178,41,'Stress Management','2019-07-21','2019-07-22');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (42,3,'Manager','Maite','Riddle','1984-Nov-03','2017-Jun-13');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (42,42,'Ap #876-1083 Quisque Street','','Colchester','99964','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (42,42,'(377) 848-1184','Maite.Riddle@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (42,42,'2021-10-13',107500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (42,5.0,'2020-09-26');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(179,42,'Mindfulness in the Workplace','2019-04-11','2019-04-13'),(180,42,'Occupational Health and Safety','2019-02-15','2019-02-17'),(181,42,'Effective Business Writing','2021-03-03','2021-03-05'),
(182,42,'Handling Difficult Customers','2020-06-20','2020-06-22'),(183,42,'Business Ethics and Compliance','2017-08-21','2017-08-22'),(184,42,'Effective Time Management','2022-01-02','2022-01-04'),
(185,42,'Mindfulness in the Workplace','2023-02-16','2023-02-19'),(186,42,'Creative Problem Solving','2018-11-02','2018-11-02'),(187,42,'Critical Thinking and Decision Making','2022-12-31','2023-01-03'),
(188,42,'Effective Time Management','2018-02-09','2018-02-09');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (43,1,'Sales Assistant','Astra','Montgomery','1984-Nov-12','2022-Nov-20');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (43,43,'Ap #328-9513 Torquent Street','','Fort Smith','83714','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (43,43,'1-697-746-4388','Astra.Montgomery@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (43,43,'2022-11-20',54500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (44,1,'Senior Manager','Perry','Roberson','2008-Nov-30','2013-Mar-23');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (44,44,'Ap #744-5932 Adipiscing Road','','Lafayette','76639','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (44,44,'1-355-821-2169','Perry.Roberson@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (44,44,'2014-05-10',188500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(44,7.5,'2018-03-13'),(44,6.5,'2023-01-21');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(189,44,'Team Building and Collaboration','2016-03-16','2016-03-16'),(190,44,'Stress Management','2013-07-07','2013-07-10'),(191,44,'Critical Thinking and Decision Making','2015-07-18','2015-07-18'),
(192,44,'Occupational Health and Safety','2013-06-29','2013-07-01'),(193,44,'Diversity and Inclusion Training','2019-11-24','2019-11-27'),(194,44,'Interpersonal Communication','2020-12-11','2020-12-13'),
(195,44,'Cybersecurity Awareness','2014-03-04','2014-03-04'),(196,44,'Creative Problem Solving','2015-07-31','2015-08-02'),(197,44,'Stress Management','2014-04-14','2014-04-16'),
(198,44,'Cybersecurity Awareness','2022-09-03','2022-09-06'),(199,44,'Stress Management','2019-02-06','2019-02-09'),(200,44,'Cross-Cultural Communication','2022-06-30','2022-07-03'),
(201,44,'Business Ethics and Compliance','2023-06-12','2023-06-14'),(202,44,'Cross-Cultural Communication','2015-01-06','2015-01-08'),(203,44,'Diversity and Inclusion Training','2014-08-22','2014-08-22'),
(204,44,'Diversity and Inclusion Training','2019-09-02','2019-09-03'),(205,44,'Cross-Cultural Communication','2020-11-20','2020-11-21');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (45,1,'Programmer','Steel','Yates','1987-Jun-17','2022-Aug-04');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (45,45,'Ap #949-6610 Elit, Rd.','','Cedar Rapids','21456','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (45,45,'1-616-545-4699','Steel.Yates@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (45,45,'2023-02-03',69000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (46,3,'Sales Assistant','Oleg','Tran','1980-Mar-30','2010-Aug-18');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (46,46,'975-469 Quis, Rd.','','Springfield','86335','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (46,46,'(464) 454-3117','Oleg.Tran@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (46,46,'2019-01-29',112500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (46,9.5,'2013-08-31');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (206,46,'Business Ethics and Compliance','2013-04-16','2013-04-17');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (47,3,'Sales Assistant','Ariel','Levine','2006-Sep-06','2023-Jan-07');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (47,47,'7397 Sed Road','','Montpelier','83751','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (47,47,'(386) 872-3691','Ariel.Levine@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (47,47,'2023-10-19',44000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (48,1,'Programmer','Mohammad','Caldwell','1965-Mar-15','2012-Dec-04');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (48,48,'Ap #958-7484 Aenean St.','','Baton Rouge','85802','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (48,48,'1-533-683-3697','Mohammad.Caldwell@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (48,48,'2021-08-14',143500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (48,5.5,'2021-07-23');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (49,1,'Manager','Zephr','Long','1976-Dec-31','2019-Aug-07');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (49,49,'Ap #974-7887 Orci St.','','Springfield','22872','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (49,49,'1-363-840-0151','Zephr.Long@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (49,49,'2021-12-12',91000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(49,6.0,'2021-02-02'),(49,5.5,'2023-09-26');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (50,2,'Sales Manager','Drew','Bowman','1965-Apr-04','2023-Jan-03');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (50,50,'617 Risus. St.','','North Las Vegas','65827','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (50,50,'1-678-421-7134','Drew.Bowman@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (50,50,'2023-07-14',61500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (51,2,'Sales Assistant','Echo','Sosa','1965-Mar-30','2021-Sep-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (51,51,'9433 Ridiculus Ave','','Houston','99691','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (51,51,'1-543-807-4574','Echo.Sosa@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (51,51,'2021-09-26',56000.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (207,51,'Cross-Cultural Communication','2023-05-17','2023-05-18');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (52,1,'Store Manager','Laura','Macdonald','1980-Jul-17','2013-Sep-04');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (52,52,'578-7977 Nisl. Road','','Denver','76155','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (52,52,'1-564-645-1476','Laura.Macdonald@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (52,52,'2013-11-17',183000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(52,7.5,'2019-06-03'),(52,4.5,'2017-02-23'),(52,8.0,'2015-03-06'),(52,7.5,'2022-06-22'),
(52,4.0,'2022-09-18'),(52,9.5,'2015-02-26');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(208,52,'Diversity and Inclusion Training','2016-06-29','2016-06-29'),(209,52,'Handling Difficult Customers','2020-07-03','2020-07-05'),(210,52,'Team Building and Collaboration','2019-01-13','2019-01-14'),
(211,52,'Handling Difficult Customers','2017-05-31','2017-06-03'),(212,52,'Team Building and Collaboration','2019-06-17','2019-06-19'),(213,52,'Creative Problem Solving','2014-06-13','2014-06-14'),
(214,52,'Interpersonal Communication','2017-06-23','2017-06-26'),(215,52,'Effective Time Management','2023-12-01','2023-12-04'),(216,52,'Sales Negotiation Skills','2015-12-14','2015-12-14'),
(217,52,'Cybersecurity Awareness','2021-08-19','2021-08-19'),(218,52,'Effective Business Writing','2022-11-08','2022-11-08'),(219,52,'Cybersecurity Awareness','2014-06-04','2014-06-06'),
(220,52,'Risk Management','2019-03-26','2019-03-27'),(221,52,'Diversity and Inclusion Training','2016-07-31','2016-08-02');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (53,1,'Store Manager','Freya','Bishop','2007-Oct-03','2019-Aug-19');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (53,53,'709-4861 Ornare St.','','San Francisco','58898','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (53,53,'1-946-114-8250','Freya.Bishop@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (53,53,'2020-04-13',129000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (54,2,'Sales Assistant','Mollie','Greer','1975-Jun-05','2018-Nov-02');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (54,54,'Ap #408-769 Nunc Av.','','Newport News','92341','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (54,54,'(844) 420-5213','Mollie.Greer@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (54,54,'2021-01-10',73500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(54,5.0,'2020-06-18'),(54,4.0,'2019-10-03'),(54,9.0,'2021-06-18');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (55,1,'Sales Assistant','Alika','Shaw','1967-Apr-19','2019-Oct-31');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (55,55,'699-2391 Nunc Road','','Helena','92462','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (55,55,'(197) 602-6773','Alika.Shaw@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (55,55,'2019-12-14',63500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (55,5.5,'2022-09-23');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (56,2,'Sales Assistant','Shoshana','Mejia','1987-Aug-07','2013-Feb-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (56,56,'4632 Leo. Avenue','','Athens','72121','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (56,56,'(707) 128-0746','Shoshana.Mejia@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (56,56,'2018-01-16',105000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(56,2.5,'2017-01-31'),(56,6.5,'2015-08-30'),(56,4.5,'2020-01-09'),(56,3.0,'2018-01-26'),
(56,3.5,'2023-11-14'),(56,6.5,'2013-12-01');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(222,56,'Presentation Skills','2017-05-13','2017-05-16'),(223,56,'Creative Problem Solving','2017-08-24','2017-08-27'),(224,56,'Sales Negotiation Skills','2019-03-22','2019-03-25'),
(225,56,'Cybersecurity Awareness','2022-01-31','2022-02-03'),(226,56,'Mindfulness in the Workplace','2020-12-31','2020-12-31');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (57,3,'Programmer','Merrill','Matthews','1967-Apr-17','2016-Feb-13');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (57,57,'Ap #869-8040 Proin Rd.','','Hilo','91868','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (57,57,'1-416-827-9285','Merrill.Matthews@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (57,57,'2023-10-05',124000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(57,7.0,'2020-08-14'),(57,4.0,'2022-06-14');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (58,2,'Senior Manager','Illana','Sims','1973-Jul-23','2011-Oct-12');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (58,58,'P.O. Box 568, 4495 Orci Ave','','Toledo','27213','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (58,58,'(551) 401-1323','Illana.Sims@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (58,58,'2016-01-05',206000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(58,6.5,'2013-01-19'),(58,7.0,'2016-12-16');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(227,58,'Introduction to Cloud Computing','2012-10-29','2012-10-29'),(228,58,'Cross-Cultural Communication','2013-12-11','2013-12-11'),(229,58,'Cybersecurity Awareness','2013-07-06','2013-07-08'),
(230,58,'Effective Business Writing','2020-03-10','2020-03-12'),(231,58,'Creative Problem Solving','2021-02-17','2021-02-17'),(232,58,'Occupational Health and Safety','2018-10-21','2018-10-24'),
(233,58,'Cybersecurity Awareness','2013-02-20','2013-02-21'),(234,58,'Critical Thinking and Decision Making','2021-08-31','2021-09-02');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (59,1,'Sales Assistant','Baxter','Stafford','1976-Sep-12','2012-Feb-12');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (59,59,'Ap #557-7750 Proin Av.','','Auburn','35553','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (59,59,'1-278-488-6469','Baxter.Stafford@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (59,59,'2013-07-30',103000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (59,8.5,'2013-12-13');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(235,59,'Critical Thinking and Decision Making','2023-06-17','2023-06-20'),(236,59,'Effective Business Writing','2023-10-28','2023-10-29'),(237,59,'Occupational Health and Safety','2021-02-21','2021-02-24'),
(238,59,'Interpersonal Communication','2022-09-24','2022-09-24'),(239,59,'Cross-Cultural Communication','2016-03-01','2016-03-03'),(240,59,'Sales Negotiation Skills','2013-06-27','2013-06-28'),
(241,59,'Introduction to Cloud Computing','2012-04-21','2012-04-23'),(242,59,'Cybersecurity Awareness','2019-11-13','2019-11-14'),(243,59,'Intellectual Property Rights','2023-05-01','2023-05-03'),
(244,59,'Creative Problem Solving','2017-12-07','2017-12-07'),(245,59,'Presentation Skills','2012-08-26','2012-08-29'),(246,59,'Business Ethics and Compliance','2021-08-29','2021-08-29'),
(247,59,'Intellectual Property Rights','2014-02-19','2014-02-21'),(248,59,'Cybersecurity Awareness','2022-12-19','2022-12-22'),(249,59,'Team Building and Collaboration','2020-06-11','2020-06-13'),
(250,59,'Business Ethics and Compliance','2014-01-16','2014-01-16'),(251,59,'Cybersecurity Awareness','2013-06-04','2013-06-06');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (60,3,'Programmer','Rhona','Fischer','1993-Apr-21','2016-Jan-25');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (60,60,'6921 Luctus Rd.','','Olathe','17181','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (60,60,'(747) 510-7437','Rhona.Fischer@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (60,60,'2023-09-07',130000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(60,4.0,'2018-08-30'),(60,9.5,'2016-09-02'),(60,7.0,'2022-12-20');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(252,60,'Introduction to Cloud Computing','2023-05-07','2023-05-10'),(253,60,'Effective Business Writing','2021-11-22','2021-11-25'),(254,60,'Risk Management','2016-06-21','2016-06-22'),
(255,60,'Team Building and Collaboration','2020-08-20','2020-08-22'),(256,60,'Creative Problem Solving','2016-09-07','2016-09-08'),(257,60,'Stress Management','2023-02-17','2023-02-17'),
(258,60,'Creative Problem Solving','2020-10-15','2020-10-17');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (61,2,'Store Manager','Ebony','Bentley','2002-Sep-20','2014-Nov-25');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (61,61,'Ap #172-8048 Est Rd.','','Boston','84758','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (61,61,'(866) 673-5402','Ebony.Bentley@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (61,61,'2022-07-11',176000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(61,2.5,'2020-05-07'),(61,6.5,'2021-08-08');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (62,1,'Programmer','Olga','Harmon','1975-Oct-26','2009-Feb-09');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (62,62,'151-9787 Proin Ave','','Fort Smith','37420','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (62,62,'(378) 707-7653','Olga.Harmon@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (62,62,'2021-10-31',182500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(62,5.0,'2015-02-14'),(62,7.5,'2010-11-12'),(62,8.0,'2019-11-08'),(62,8.5,'2010-11-25'),
(62,8.0,'2009-09-26'),(62,7.5,'2015-10-27');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(259,62,'Presentation Skills','2014-03-30','2014-04-02'),(260,62,'Cross-Cultural Communication','2023-02-04','2023-02-07'),(261,62,'Effective Time Management','2011-03-04','2011-03-05'),
(262,62,'Sales Negotiation Skills','2017-09-26','2017-09-28'),(263,62,'Risk Management','2018-08-28','2018-08-29'),(264,62,'Effective Business Writing','2022-10-15','2022-10-17'),
(265,62,'Creative Problem Solving','2021-10-11','2021-10-13'),(266,62,'Sales Negotiation Skills','2014-04-29','2014-04-30'),(267,62,'Sales Negotiation Skills','2010-07-03','2010-07-05'),
(268,62,'Creative Problem Solving','2012-08-22','2012-08-25'),(269,62,'Cybersecurity Awareness','2019-02-07','2019-02-08'),(270,62,'Effective Time Management','2020-09-07','2020-09-07'),
(271,62,'Diversity and Inclusion Training','2012-10-21','2012-10-22'),(272,62,'Introduction to Cloud Computing','2009-11-29','2009-12-02'),(273,62,'Cybersecurity Awareness','2010-10-30','2010-10-31'),
(274,62,'Diversity and Inclusion Training','2010-08-09','2010-08-09'),(275,62,'Critical Thinking and Decision Making','2014-06-14','2014-06-16'),(276,62,'Stress Management','2012-06-25','2012-06-28'),
(277,62,'Cybersecurity Awareness','2018-12-24','2018-12-26'),(278,62,'Cross-Cultural Communication','2011-03-11','2011-03-13'),(279,62,'Presentation Skills','2014-03-26','2014-03-29'),
(280,62,'Mindfulness in the Workplace','2017-12-15','2017-12-16'),(281,62,'Business Ethics and Compliance','2019-12-09','2019-12-11'),(282,62,'Interpersonal Communication','2016-11-08','2016-11-11'),
(283,62,'Critical Thinking and Decision Making','2022-10-12','2022-10-15'),(284,62,'Occupational Health and Safety','2022-11-26','2022-11-26');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (63,1,'Store Manager','Rosalyn','Strong','1996-Jun-25','2019-Nov-20');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (63,63,'Ap #156-5904 Praesent Ave','','Independence','99832','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (63,63,'(857) 587-2464','Rosalyn.Strong@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (63,63,'2023-06-02',126500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (63,2.0,'2021-01-27');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(285,63,'Effective Time Management','2020-09-09','2020-09-10'),(286,63,'Team Building and Collaboration','2021-04-15','2021-04-17'),(287,63,'Sales Negotiation Skills','2020-02-08','2020-02-08'),
(288,63,'Intellectual Property Rights','2021-09-02','2021-09-04'),(289,63,'Effective Time Management','2020-03-27','2020-03-30'),(290,63,'Creative Problem Solving','2023-04-17','2023-04-19'),
(291,63,'Cybersecurity Awareness','2023-01-02','2023-01-03');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (64,2,'Programmer','Sierra','Mason','1979-Dec-24','2010-Aug-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (64,64,'P.O. Box 632, 2130 Eu Road','','Broken Arrow','70065','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (64,64,'1-520-528-5160','Sierra.Mason@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (64,64,'2016-09-30',160500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(64,5.5,'2012-09-24'),(64,2.5,'2019-10-28'),(64,8.5,'2022-05-10'),(64,8.5,'2014-02-15'),
(64,5.0,'2011-01-11'),(64,6.0,'2019-12-29'),(64,9.0,'2012-03-01'),(64,6.5,'2021-12-09'),
(64,6.0,'2023-04-03'),(64,4.5,'2015-02-22');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (65,2,'Sales Assistant','Lane','Santana','1969-Nov-04','2014-Dec-10');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (65,65,'1807 Proin Street','','Rockford','27933','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (65,65,'1-545-876-7436','Lane.Santana@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (65,65,'2023-07-21',92000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(65,3.5,'2016-03-21'),(65,2.5,'2019-12-18');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(292,65,'Risk Management','2020-03-29','2020-03-31'),(293,65,'Effective Business Writing','2021-05-10','2021-05-13'),(294,65,'Interpersonal Communication','2020-07-24','2020-07-27'),
(295,65,'Diversity and Inclusion Training','2015-01-07','2015-01-07'),(296,65,'Business Ethics and Compliance','2023-06-04','2023-06-07'),(297,65,'Mindfulness in the Workplace','2020-05-12','2020-05-14'),
(298,65,'Effective Time Management','2017-09-23','2017-09-26'),(299,65,'Effective Business Writing','2017-04-14','2017-04-17'),(300,65,'Sales Negotiation Skills','2016-07-28','2016-07-28'),
(301,65,'Risk Management','2019-08-26','2019-08-28');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (66,3,'Sales Assistant','Yoshi','Hayden','1964-Aug-17','2020-Nov-02');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (66,66,'703-7113 Et Ave','','Frederick','51151','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (66,66,'(699) 821-9393','Yoshi.Hayden@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (66,66,'2021-07-01',60000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (67,1,'Sales Assistant','Angelica','Carroll','1978-Sep-07','2014-May-28');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (67,67,'6562 Enim. Rd.','','Cedar Rapids','84911','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (67,67,'(422) 694-1671','Angelica.Carroll@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (67,67,'2021-03-25',88000.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(302,67,'Effective Business Writing','2017-02-11','2017-02-12'),(303,67,'Business Ethics and Compliance','2020-04-22','2020-04-23'),(304,67,'Business Ethics and Compliance','2019-06-22','2019-06-25'),
(305,67,'Intellectual Property Rights','2015-09-24','2015-09-25'),(306,67,'Mindfulness in the Workplace','2022-04-24','2022-04-26'),(307,67,'Creative Problem Solving','2014-06-10','2014-06-11'),
(308,67,'Creative Problem Solving','2023-05-23','2023-05-24'),(309,67,'Effective Business Writing','2021-01-06','2021-01-09'),(310,67,'Introduction to Cloud Computing','2018-10-31','2018-11-02'),
(311,67,'Diversity and Inclusion Training','2015-09-30','2015-10-01'),(312,67,'Business Ethics and Compliance','2020-11-16','2020-11-18'),(313,67,'Mindfulness in the Workplace','2019-09-17','2019-09-17'),
(314,67,'Cross-Cultural Communication','2016-07-14','2016-07-16'),(315,67,'Intellectual Property Rights','2018-11-13','2018-11-16'),(316,67,'Sales Negotiation Skills','2017-12-04','2017-12-06'),
(317,67,'Effective Business Writing','2015-10-23','2015-10-25');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (68,2,'Senior Manager','Shaeleigh','Sanders','1996-May-06','2018-Jul-14');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (68,68,'Ap #868-4059 Ac, Av.','','Meridian','36483','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (68,68,'(330) 613-2102','Shaeleigh.Sanders@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (68,68,'2019-05-13',135500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(68,4.0,'2018-10-30'),(68,8.5,'2023-07-29');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (69,1,'Sales Assistant','Rahim','Harris','1995-Jan-12','2009-May-28');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (69,69,'318-8695 Diam. Ave','','Baton Rouge','89116','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (69,69,'(831) 683-7761','Rahim.Harris@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (69,69,'2023-09-22',113500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(69,7.0,'2012-10-09'),(69,6.0,'2011-07-29');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(318,69,'Diversity and Inclusion Training','2018-09-02','2018-09-04'),(319,69,'Presentation Skills','2013-01-20','2013-01-23'),(320,69,'Occupational Health and Safety','2010-02-15','2010-02-15'),
(321,69,'Introduction to Cloud Computing','2020-04-26','2020-04-29'),(322,69,'Business Ethics and Compliance','2018-06-27','2018-06-27'),(323,69,'Sales Negotiation Skills','2022-03-02','2022-03-03'),
(324,69,'Team Building and Collaboration','2009-08-12','2009-08-14'),(325,69,'Business Ethics and Compliance','2015-11-20','2015-11-21'),(326,69,'Stress Management','2012-10-21','2012-10-22'),
(327,69,'Creative Problem Solving','2022-10-03','2022-10-04');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (70,3,'Senior Manager','Lance','Mcpherson','2007-Aug-25','2014-Jan-15');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (70,70,'775-2533 Massa. Ave','','Lakewood','15981','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (70,70,'(717) 831-1941','Lance.Mcpherson@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (70,70,'2019-07-22',182000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(70,5.0,'2014-10-25'),(70,5.0,'2016-02-06'),(70,5.0,'2021-02-20'),(70,6.5,'2021-07-19');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (71,2,'Programmer','Melissa','Hopper','1976-Sep-26','2022-Sep-19');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (71,71,'Ap #998-8364 Netus Av.','','Cambridge','67194','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (71,71,'1-762-774-4756','Melissa.Hopper@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (71,71,'2023-10-02',75000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (72,2,'Sales Assistant','Gannon','Head','1993-Jun-25','2017-Nov-07');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (72,72,'P.O. Box 144, 5864 Non, Av.','','Nashville','84466','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (72,72,'(543) 212-6978','Gannon.Head@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (72,72,'2022-07-28',72500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (72,5.0,'2019-01-13');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(328,72,'Introduction to Cloud Computing','2023-07-19','2023-07-21'),(329,72,'Cross-Cultural Communication','2020-07-14','2020-07-17'),(330,72,'Mindfulness in the Workplace','2020-02-05','2020-02-05'),
(331,72,'Business Ethics and Compliance','2023-08-19','2023-08-19'),(332,72,'Stress Management','2019-12-02','2019-12-02');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (73,2,'Manager','Merritt','Roman','2008-Aug-23','2020-Oct-23');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (73,73,'447-713 Vel St.','','Lansing','38814','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (73,73,'(665) 612-2522','Merritt.Roman@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (73,73,'2023-01-08',90500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (74,1,'Sales Assistant','Summer','Lopez','2003-Nov-03','2011-Sep-18');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (74,74,'P.O. Box 543, 5002 Phasellus St.','','Newport News','49137','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (74,74,'1-426-822-3455','Summer.Lopez@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (74,74,'2016-06-20',101500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(74,3.0,'2019-09-22'),(74,5.0,'2018-12-04'),(74,6.0,'2016-10-08'),(74,4.0,'2023-04-10'),
(74,2.5,'2014-01-23'),(74,4.5,'2021-12-07');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(333,74,'Creative Problem Solving','2018-06-01','2018-06-01'),(334,74,'Risk Management','2013-03-11','2013-03-14'),(335,74,'Creative Problem Solving','2023-02-18','2023-02-19'),
(336,74,'Stress Management','2012-06-21','2012-06-23'),(337,74,'Diversity and Inclusion Training','2015-12-06','2015-12-08'),(338,74,'Sales Negotiation Skills','2021-01-03','2021-01-05'),
(339,74,'Risk Management','2013-11-30','2013-12-01'),(340,74,'Sales Negotiation Skills','2011-11-18','2011-11-19'),(341,74,'Sales Negotiation Skills','2020-11-27','2020-11-30'),
(342,74,'Diversity and Inclusion Training','2018-12-02','2018-12-05'),(343,74,'Stress Management','2020-06-26','2020-06-29');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (75,3,'Sales Assistant','Ciara','Fischer','1981-May-04','2023-Jan-24');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (75,75,'507-305 Fusce Street','','Anchorage','97834','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (75,75,'(625) 354-9935','Ciara.Fischer@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (75,75,'2023-08-04',46500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (76,1,'Sales Assistant','Vernon','Holt','1979-Mar-13','2019-Dec-04');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (76,76,'P.O. Box 430, 5421 Lorem Rd.','','South Burlington','17461','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (76,76,'1-765-134-2144','Vernon.Holt@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (76,76,'2022-04-04',64500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (77,2,'Programmer','Piper','Stout','1965-Jan-12','2018-Jun-15');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (77,77,'9858 Proin Avenue','','Bellevue','41471','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (77,77,'(766) 852-6816','Piper.Stout@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (77,77,'2020-08-27',107000.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (78,2,'Sales Assistant','Imelda','Singleton','2008-Oct-30','2008-Dec-14');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (78,78,'Ap #637-6126 Ipsum. St.','','Wichita','71173','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (78,78,'(691) 265-9227','Imelda.Singleton@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (78,78,'2008-12-20',123000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (78,6.5,'2019-08-10');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(344,78,'Risk Management','2017-06-10','2017-06-13'),(345,78,'Handling Difficult Customers','2016-09-19','2016-09-22'),(346,78,'Stress Management','2014-01-18','2014-01-20'),
(347,78,'Creative Problem Solving','2008-12-25','2008-12-27'),(348,78,'Effective Time Management','2020-09-16','2020-09-19'),(349,78,'Interpersonal Communication','2012-10-02','2012-10-03'),
(350,78,'Stress Management','2023-02-11','2023-02-11'),(351,78,'Critical Thinking and Decision Making','2009-06-25','2009-06-28'),(352,78,'Business Ethics and Compliance','2022-06-24','2022-06-24'),
(353,78,'Team Building and Collaboration','2013-07-02','2013-07-03'),(354,78,'Presentation Skills','2020-09-08','2020-09-10'),(355,78,'Creative Problem Solving','2016-01-12','2016-01-15'),
(356,78,'Occupational Health and Safety','2014-09-28','2014-09-29'),(357,78,'Effective Time Management','2015-05-25','2015-05-25'),(358,78,'Intellectual Property Rights','2013-08-10','2013-08-12'),
(359,78,'Cross-Cultural Communication','2021-12-07','2021-12-07'),(360,78,'Occupational Health and Safety','2022-05-07','2022-05-07'),(361,78,'Team Building and Collaboration','2013-10-21','2013-10-23'),
(362,78,'Team Building and Collaboration','2010-08-17','2010-08-18'),(363,78,'Critical Thinking and Decision Making','2011-06-08','2011-06-08'),(364,78,'Creative Problem Solving','2012-05-31','2012-06-02');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (79,2,'Manager','Elizabeth','Klein','1977-Nov-17','2015-Oct-21');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (79,79,'281-2012 Est Rd.','','Colorado Springs','99778','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (79,79,'(316) 759-8424','Elizabeth.Klein@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (79,79,'2021-08-07',121000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(79,2.5,'2019-07-09'),(79,5.5,'2020-11-02'),(79,7.5,'2022-03-24'),(79,7.5,'2023-02-16'),
(79,6.5,'2015-10-21');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(365,79,'Sales Negotiation Skills','2022-06-12','2022-06-12'),(366,79,'Effective Business Writing','2016-07-29','2016-07-31'),(367,79,'Cybersecurity Awareness','2023-02-17','2023-02-19'),
(368,79,'Stress Management','2018-10-11','2018-10-13'),(369,79,'Stress Management','2023-11-29','2023-12-02'),(370,79,'Diversity and Inclusion Training','2017-11-12','2017-11-14'),
(371,79,'Occupational Health and Safety','2022-11-18','2022-11-21'),(372,79,'Introduction to Cloud Computing','2023-04-10','2023-04-13'),(373,79,'Mindfulness in the Workplace','2020-12-23','2020-12-24'),
(374,79,'Risk Management','2019-07-18','2019-07-21');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (80,1,'Programmer','Hilel','Hart','1983-Aug-13','2011-Sep-07');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (80,80,'391-3328 Scelerisque St.','','Virginia Beach','85845','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (80,80,'1-677-680-4621','Hilel.Hart@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (80,80,'2022-12-30',151500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (80,4.5,'2017-03-22');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(375,80,'Sales Negotiation Skills','2022-07-20','2022-07-22'),(376,80,'Business Ethics and Compliance','2023-03-02','2023-03-05'),(377,80,'Introduction to Cloud Computing','2019-07-17','2019-07-20'),
(378,80,'Occupational Health and Safety','2020-05-01','2020-05-04'),(379,80,'Interpersonal Communication','2019-08-12','2019-08-15'),(380,80,'Effective Business Writing','2012-03-28','2012-03-28'),
(381,80,'Business Ethics and Compliance','2021-10-28','2021-10-29'),(382,80,'Creative Problem Solving','2013-01-05','2013-01-08'),(383,80,'Risk Management','2015-04-12','2015-04-14'),
(384,80,'Effective Business Writing','2016-07-08','2016-07-10'),(385,80,'Handling Difficult Customers','2012-03-05','2012-03-05'),(386,80,'Interpersonal Communication','2019-04-13','2019-04-16'),
(387,80,'Critical Thinking and Decision Making','2019-04-30','2019-05-02'),(388,80,'Business Ethics and Compliance','2012-08-05','2012-08-07'),(389,80,'Presentation Skills','2015-09-21','2015-09-24'),
(390,80,'Handling Difficult Customers','2015-04-28','2015-05-01'),(391,80,'Presentation Skills','2013-07-29','2013-07-31'),(392,80,'Handling Difficult Customers','2019-01-28','2019-01-28'),
(393,80,'Mindfulness in the Workplace','2014-09-07','2014-09-09');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (81,1,'Sales Assistant','Philip','Leon','1987-Aug-23','2018-Oct-03');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (81,81,'450-3666 Fusce Avenue','','Fayetteville','80438','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (81,81,'1-282-577-7542','Philip.Leon@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (81,81,'2022-08-09',75000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(81,7.5,'2019-06-24'),(81,4.5,'2019-09-16');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(394,81,'Critical Thinking and Decision Making','2023-04-25','2023-04-28'),(395,81,'Introduction to Cloud Computing','2022-03-05','2022-03-08'),(396,81,'Introduction to Cloud Computing','2019-06-23','2019-06-23'),
(397,81,'Sales Negotiation Skills','2021-01-30','2021-02-02');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (82,2,'Programmer','Tanisha','Curry','1996-Nov-04','2021-Oct-18');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (82,82,'202-6416 Gravida Road','','Houston','79686','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (82,82,'1-464-289-2502','Tanisha.Curry@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (82,82,'2023-08-06',84500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (83,3,'Programmer','Alvin','Joyner','2004-May-07','2011-Jul-07');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (83,83,'Ap #458-2259 Proin St.','','West Jordan','87345','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (83,83,'(315) 241-4036','Alvin.Joyner@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (83,83,'2014-03-03',150500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(83,3.5,'2023-10-21'),(83,6.0,'2021-12-26'),(83,8.0,'2020-09-26'),(83,8.5,'2011-08-23'),
(83,6.0,'2019-08-28'),(83,5.0,'2018-05-19'),(83,6.0,'2020-07-05');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(398,83,'Mindfulness in the Workplace','2019-11-12','2019-11-12'),(399,83,'Mindfulness in the Workplace','2011-11-21','2011-11-24'),(400,83,'Handling Difficult Customers','2016-06-13','2016-06-13'),
(401,83,'Creative Problem Solving','2020-06-17','2020-06-19'),(402,83,'Effective Time Management','2021-06-03','2021-06-04'),(403,83,'Business Ethics and Compliance','2019-05-23','2019-05-24'),
(404,83,'Creative Problem Solving','2017-02-15','2017-02-16'),(405,83,'Stress Management','2017-04-07','2017-04-08'),(406,83,'Interpersonal Communication','2018-09-20','2018-09-21'),
(407,83,'Team Building and Collaboration','2011-09-28','2011-09-30'),(408,83,'Introduction to Cloud Computing','2012-02-20','2012-02-21'),(409,83,'Presentation Skills','2012-02-18','2012-02-18'),
(410,83,'Stress Management','2021-04-11','2021-04-12'),(411,83,'Intellectual Property Rights','2011-12-16','2011-12-18'),(412,83,'Risk Management','2014-09-26','2014-09-29'),
(413,83,'Cybersecurity Awareness','2012-01-26','2012-01-27'),(414,83,'Intellectual Property Rights','2014-05-02','2014-05-03'),(415,83,'Stress Management','2014-06-25','2014-06-25'),
(416,83,'Diversity and Inclusion Training','2019-01-25','2019-01-27');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (84,2,'Sales Assistant','Buffy','Robinson','1982-May-22','2010-May-19');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (84,84,'635-9490 Nunc St.','','South Bend','75635','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (84,84,'(800) 654-4581','Buffy.Robinson@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (84,84,'2011-01-13',109000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(84,4.0,'2021-07-10'),(84,7.0,'2021-02-16'),(84,2.5,'2021-09-06'),(84,4.5,'2019-01-01');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (85,1,'Sales Assistant','Paki','Norton','1991-Jan-24','2017-May-12');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (85,85,'558-3929 Dolor Avenue','','Pittsburgh','71134','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (85,85,'(110) 317-1552','Paki.Norton@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (85,85,'2019-06-05',78500.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(417,85,'Interpersonal Communication','2020-09-16','2020-09-17'),(418,85,'Introduction to Cloud Computing','2018-09-12','2018-09-12'),(419,85,'Presentation Skills','2022-09-10','2022-09-10'),
(420,85,'Cross-Cultural Communication','2022-05-16','2022-05-18'),(421,85,'Effective Time Management','2017-11-03','2017-11-06'),(422,85,'Presentation Skills','2020-02-06','2020-02-08'),
(423,85,'Risk Management','2017-10-24','2017-10-24'),(424,85,'Effective Time Management','2019-10-05','2019-10-07'),(425,85,'Presentation Skills','2018-12-17','2018-12-17'),
(426,85,'Cybersecurity Awareness','2017-12-29','2018-01-01');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (86,1,'Manager','Phoebe','Morrison','1983-Aug-07','2013-Feb-03');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (86,86,'873-279 Arcu. Rd.','','Tulsa','16138','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (86,86,'1-270-237-7976','Phoebe.Morrison@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (86,86,'2016-05-13',146500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(86,4.0,'2017-02-07'),(86,5.0,'2015-05-23'),(86,2.5,'2018-11-14'),(86,2.0,'2022-12-18'),
(86,4.0,'2016-09-18');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(427,86,'Effective Business Writing','2013-12-06','2013-12-07'),(428,86,'Cross-Cultural Communication','2023-09-09','2023-09-11'),(429,86,'Critical Thinking and Decision Making','2013-11-19','2013-11-22'),
(430,86,'Effective Time Management','2018-03-17','2018-03-17'),(431,86,'Intellectual Property Rights','2016-05-31','2016-06-01'),(432,86,'Creative Problem Solving','2023-06-16','2023-06-16'),
(433,86,'Effective Business Writing','2013-10-25','2013-10-27'),(434,86,'Intellectual Property Rights','2020-07-11','2020-07-12'),(435,86,'Presentation Skills','2019-10-31','2019-11-03'),
(436,86,'Handling Difficult Customers','2023-11-01','2023-11-01'),(437,86,'Critical Thinking and Decision Making','2023-11-04','2023-11-04'),(438,86,'Mindfulness in the Workplace','2013-05-03','2013-05-03'),
(439,86,'Critical Thinking and Decision Making','2022-08-26','2022-08-26'),(440,86,'Risk Management','2023-04-13','2023-04-15'),(441,86,'Introduction to Cloud Computing','2023-12-05','2023-12-07'),
(442,86,'Occupational Health and Safety','2019-12-08','2019-12-11'),(443,86,'Risk Management','2016-05-09','2016-05-10'),(444,86,'Introduction to Cloud Computing','2019-04-08','2019-04-08'),
(445,86,'Interpersonal Communication','2013-08-31','2013-09-03'),(446,86,'Interpersonal Communication','2018-05-16','2018-05-17'),(447,86,'Mindfulness in the Workplace','2013-04-18','2013-04-18');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (87,1,'Sales Assistant','Kelly','Parrish','2006-Mar-30','2009-Sep-08');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (87,87,'P.O. Box 295, 4061 Sociis Rd.','','Phoenix','85433','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (87,87,'(324) 632-4391','Kelly.Parrish@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (87,87,'2017-07-17',114500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(87,5.0,'2020-10-19'),(87,6.0,'2010-10-20'),(87,6.5,'2018-08-20'),(87,1.5,'2013-08-17'),
(87,4.0,'2017-06-20'),(87,3.0,'2011-02-08'),(87,7.5,'2016-11-26'),(87,4.5,'2023-08-16');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (88,2,'Manager','Brandon','Hatfield','1966-Sep-18','2020-Nov-27');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (88,88,'Ap #390-2024 Metus St.','','Virginia Beach','61669','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (88,88,'(416) 285-7691','Brandon.Hatfield@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (88,88,'2021-09-09',86000.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(448,88,'Effective Time Management','2022-12-14','2022-12-14'),(449,88,'Business Ethics and Compliance','2023-10-10','2023-10-12'),(450,88,'Diversity and Inclusion Training','2023-06-22','2023-06-23');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (89,2,'Senior Manager','Grant','Wilkerson','1997-Jul-05','2011-Oct-10');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (89,89,'936-3391 Sed St.','','Philadelphia','24046','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (89,89,'(821) 433-4711','Grant.Wilkerson@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (89,89,'2017-07-22',202500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(89,3.5,'2021-08-09'),(89,6.0,'2018-06-19'),(89,6.5,'2012-03-06'),(89,10.0,'2018-06-09'),
(89,4.0,'2015-11-08'),(89,3.0,'2012-08-01'),(89,7.0,'2023-03-23'),(89,7.0,'2017-05-05');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(451,89,'Occupational Health and Safety','2018-03-02','2018-03-05'),(452,89,'Handling Difficult Customers','2012-11-14','2012-11-15'),(453,89,'Effective Time Management','2020-01-20','2020-01-20'),
(454,89,'Handling Difficult Customers','2015-02-26','2015-03-01'),(455,89,'Risk Management','2018-03-11','2018-03-12'),(456,89,'Interpersonal Communication','2015-09-08','2015-09-08'),
(457,89,'Risk Management','2017-03-22','2017-03-25');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (90,1,'Sales Assistant','Fritz','Brooks','1991-Jul-06','2016-Jan-12');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (90,90,'8784 Integer St.','','Paradise','58322','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (90,90,'1-924-123-1234','Fritz.Brooks@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (90,90,'2020-06-23',80500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(90,2.0,'2023-04-13'),(90,6.0,'2017-07-26'),(90,8.5,'2019-07-10'),(90,4.0,'2019-07-07'),
(90,4.5,'2021-05-09');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (91,1,'Store Manager','Sybil','Stevenson','1967-Dec-09','2010-Nov-29');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (91,91,'Ap #828-6635 Nulla. Street','','Lafayette','36736','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (91,91,'1-969-398-3746','Sybil.Stevenson@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (91,91,'2021-12-07',216000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(91,6.0,'2016-06-16'),(91,5.5,'2014-07-18'),(91,4.5,'2022-03-11'),(91,8.5,'2011-02-10'),
(91,6.0,'2021-01-08'),(91,7.5,'2017-11-08'),(91,4.5,'2020-11-07'),(91,2.5,'2018-12-13'),
(91,3.0,'2014-03-30'),(91,5.0,'2016-01-05');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(458,91,'Sales Negotiation Skills','2020-12-27','2020-12-27'),(459,91,'Business Ethics and Compliance','2017-02-22','2017-02-24'),(460,91,'Cross-Cultural Communication','2023-04-12','2023-04-13');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (92,2,'Sales Assistant','Ferdinand','Lancaster','1975-Apr-11','2018-Sep-17');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (92,92,'Ap #545-6235 Pellentesque Av.','','Springfield','57128','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (92,92,'1-374-616-4255','Ferdinand.Lancaster@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (92,92,'2023-01-21',70000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(92,8.5,'2020-08-05'),(92,5.5,'2022-10-10');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (93,3,'Manager','Lacey','Craig','2007-Jul-09','2022-Apr-10');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (93,93,'Ap #482-2621 Mattis St.','','Kearney','88085','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (93,93,'1-813-770-7711','Lacey.Craig@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (93,93,'2022-11-29',77500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (94,3,'Sales Assistant','Bo','Miles','1992-Jul-26','2009-Mar-04');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (94,94,'Ap #433-8674 Metus Av.','','Montpelier','58668','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (94,94,'(638) 331-3890','Bo.Miles@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (94,94,'2019-08-22',116000.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(461,94,'Stress Management','2013-08-03','2013-08-03'),(462,94,'Team Building and Collaboration','2019-04-05','2019-04-07'),(463,94,'Sales Negotiation Skills','2015-04-11','2015-04-12'),
(464,94,'Stress Management','2011-05-08','2011-05-10'),(465,94,'Diversity and Inclusion Training','2016-05-04','2016-05-05'),(466,94,'Occupational Health and Safety','2013-11-28','2013-12-01'),
(467,94,'Creative Problem Solving','2020-11-02','2020-11-03'),(468,94,'Creative Problem Solving','2021-03-12','2021-03-13'),(469,94,'Sales Negotiation Skills','2014-12-09','2014-12-11'),
(470,94,'Effective Time Management','2013-01-03','2013-01-05'),(471,94,'Intellectual Property Rights','2021-05-15','2021-05-18'),(472,94,'Introduction to Cloud Computing','2014-10-01','2014-10-04'),
(473,94,'Creative Problem Solving','2012-09-26','2012-09-28'),(474,94,'Creative Problem Solving','2022-05-16','2022-05-17'),(475,94,'Introduction to Cloud Computing','2020-07-28','2020-07-30'),
(476,94,'Creative Problem Solving','2023-09-11','2023-09-13'),(477,94,'Business Ethics and Compliance','2017-07-20','2017-07-21'),(478,94,'Diversity and Inclusion Training','2020-05-09','2020-05-11'),
(479,94,'Effective Time Management','2015-10-10','2015-10-11');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (95,2,'Programmer','Nora','Lott','1977-Jul-10','2011-Jul-20');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (95,95,'P.O. Box 588, 236 Imperdiet Ave','','Idaho Falls','21221','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (95,95,'1-364-585-4725','Nora.Lott@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (95,95,'2015-12-18',158000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(95,2.5,'2019-03-28'),(95,8.0,'2013-07-12'),(95,3.0,'2018-05-07'),(95,4.0,'2017-09-19'),
(95,6.5,'2019-02-13'),(95,7.0,'2014-10-11'),(95,8.0,'2021-07-31');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(480,95,'Sales Negotiation Skills','2022-10-04','2022-10-07'),(481,95,'Risk Management','2017-11-09','2017-11-09'),(482,95,'Effective Time Management','2013-05-14','2013-05-14'),
(483,95,'Diversity and Inclusion Training','2014-05-23','2014-05-26'),(484,95,'Presentation Skills','2012-12-21','2012-12-24'),(485,95,'Critical Thinking and Decision Making','2012-12-30','2012-12-31'),
(486,95,'Cybersecurity Awareness','2020-10-18','2020-10-20'),(487,95,'Occupational Health and Safety','2020-05-25','2020-05-27'),(488,95,'Interpersonal Communication','2023-02-09','2023-02-10'),
(489,95,'Risk Management','2016-12-06','2016-12-06'),(490,95,'Cybersecurity Awareness','2013-07-16','2013-07-18'),(491,95,'Diversity and Inclusion Training','2021-01-17','2021-01-19'),
(492,95,'Intellectual Property Rights','2011-10-29','2011-10-29'),(493,95,'Intellectual Property Rights','2011-10-16','2011-10-18'),(494,95,'Presentation Skills','2022-06-28','2022-06-29'),
(495,95,'Mindfulness in the Workplace','2014-03-28','2014-03-29'),(496,95,'Introduction to Cloud Computing','2022-12-04','2022-12-07'),(497,95,'Presentation Skills','2017-08-21','2017-08-22');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (96,2,'Sales Assistant','Shellie','Tillman','1999-Oct-10','2013-Feb-16');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (96,96,'Ap #284-3416 Felis Road','','Overland Park','53683','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (96,96,'1-636-631-2908','Shellie.Tillman@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (96,96,'2021-04-10',105000.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(96,4.5,'2014-06-19'),(96,3.5,'2018-06-30'),(96,5.0,'2017-08-31'),(96,5.5,'2017-10-31'),
(96,5.5,'2021-07-21'),(96,6.0,'2019-12-06'),(96,1.5,'2022-08-19'),(96,8.5,'2022-11-08'),
(96,8.5,'2016-11-16');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(498,96,'Presentation Skills','2014-03-06','2014-03-09'),(499,96,'Cross-Cultural Communication','2020-10-30','2020-11-01'),(500,96,'Business Ethics and Compliance','2023-02-13','2023-02-13');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (97,2,'Sales Assistant','Hilel','Dean','1972-May-16','2021-Aug-13');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (97,97,'P.O. Box 197, 5106 Tristique St.','','Henderson','58228','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (97,97,'(722) 483-3476','Hilel.Dean@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (97,97,'2022-08-07',59500.0);
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (98,3,'Sales Manager','Hiram','Morgan','1999-May-03','2011-Aug-13');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (98,98,'Ap #576-4672 Lectus Rd.','','Hartford','99577','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (98,98,'(961) 524-6623','Hiram.Morgan@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (98,98,'2021-07-01',130500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values
(98,8.0,'2014-08-12'),(98,2.0,'2018-05-27'),(98,5.5,'2016-01-19'),(98,4.5,'2023-11-08');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(501,98,'Risk Management','2012-02-09','2012-02-12'),(502,98,'Introduction to Cloud Computing','2016-04-11','2016-04-12'),(503,98,'Cross-Cultural Communication','2021-02-13','2021-02-15'),
(504,98,'Team Building and Collaboration','2020-10-09','2020-10-09'),(505,98,'Effective Time Management','2018-09-15','2018-09-17'),(506,98,'Diversity and Inclusion Training','2019-10-21','2019-10-22'),
(507,98,'Critical Thinking and Decision Making','2019-03-06','2019-03-08'),(508,98,'Interpersonal Communication','2013-07-11','2013-07-12'),(509,98,'Cybersecurity Awareness','2016-07-26','2016-07-29'),
(510,98,'Diversity and Inclusion Training','2021-08-05','2021-08-06'),(511,98,'Cross-Cultural Communication','2012-10-24','2012-10-24'),(512,98,'Business Ethics and Compliance','2017-11-26','2017-11-29'),
(513,98,'Presentation Skills','2018-10-12','2018-10-13');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (99,3,'Sales Assistant','Coby','Wheeler','1972-Jan-06','2020-Jul-28');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (99,99,'157-3255 Consectetuer St.','','Hillsboro','36823','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (99,99,'(571) 634-4132','Coby.Wheeler@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (99,99,'2022-09-24',58500.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (514,99,'Team Building and Collaboration','2021-11-03','2021-11-03');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (100,1,'Programmer','Basia','Potts','2002-May-31','2019-Mar-01');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (100,100,'6795 Cubilia Rd.','','Baltimore','35411','United States');
insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (100,100,'(271) 214-9275','Basia.Potts@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (100,100,'2021-09-22',96000.0);
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values
(515,100,'Critical Thinking and Decision Making','2020-09-15','2020-09-16'),(516,100,'Critical Thinking and Decision Making','2019-05-24','2019-05-25'),(517,100,'Occupational Health and Safety','2021-01-08','2021-01-09'),
(518,100,'Introduction to Cloud Computing','2019-08-08','2019-08-10'),(519,100,'Team Building and Collaboration','2019-09-15','2019-09-15'),(520,100,'Stress Management','2021-11-14','2021-11-16');