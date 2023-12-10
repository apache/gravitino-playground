/*
 * Copyright 2023 Datastrato.
 * This software is licensed under the Apache License version 2.
 */
CREATE DATABASE  db;
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

-- HR.employee_roles definition

CREATE TABLE HR.employee_roles (
    role_id int4 NULL,
    employee_id int4 NULL,
    department_id int4 NULL,
    role_name varchar(100) NULL
);
COMMENT ON TABLE hr.employee_roles IS 'comment';

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

insert into hr.departments (department_id, department_name) values (1,'Sales');
insert into hr.departments (department_id, department_name) values (2,'IT');
insert into hr.departments (department_id, department_name) values (3,'Accounting');
insert into hr.departments (department_id, department_name) values (4,'Customer Service');

insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (1,1,'Manager','Gregory','Smith','1968-Apr-15','2014-Jun-04');
insert into hr.employees (employee_id, department_id, job_title, given_name,family_name, birth_date, hire_date) values (2,1,'Sales Assistant','Owen','Rivers','1988-Aug-13','2021-Feb-05');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (1,1,'P.O. Box 502, 6281 Arcu. St.','','Detroit','23674','United States');
insert into hr.employee_address (address_id, employee_id, address_line1, address_line2, city, state, postal_code) values (2,2,'Ap #469-5929 Dapibus Ave','','Metairie','55765','United States');

insert into hr.employee_contacts (contact_id, employee_id, phone_number, email) values (1,1,'1-572-573-9795','Gregory.Smith@acme.com');
insert into hr.salaries (salary_id, employee_id, effective_date, amount) values (1,1,'2019-01-14',130500.0);
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (1,4.0,'2018-02-24');
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (1,7.0,'2016-12-25');
insert into hr.employee_performance (employee_id, rating, evaluation_date) values (1,3.5,'2023-04-07');

insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (1,1,'Training','2020-06-24','2020-06-26');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (2,1,'Training','2023-05-06','2023-05-06');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (3,1,'Training','2022-09-27','2022-09-30');
insert into hr.employee_training (training_id, employee_id, training_name, start_date, end_date) values (4,1,'Training','2016-08-02','2016-08-05');
