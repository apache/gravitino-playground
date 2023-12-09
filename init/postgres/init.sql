/*
 * Copyright 2023 Datastrato.
 * This software is licensed under the Apache License version 2.
 */

CREATE SCHEMA HR;
-- HR.departments definition

-- Drop table
DROP TABLE HR.departments;
CREATE TABLE HR.departments (
    department_id int4 NULL,
    department_name varchar(100) NULL
);


-- HR.employee_address definition

-- Drop table
DROP TABLE HR.employee_address;
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

-- Drop table
DROP TABLE HR.employee_contacts;
CREATE TABLE HR.employee_contacts (
    contact_id int4 NULL,
    employee_id int4 NULL,
    phone_number varchar(20) NULL,
    email varchar(100) NULL
);

-- HR.employee_performance definition

-- Drop table
DROP TABLE HR.employee_performance;
CREATE TABLE HR.employee_performance (
    employee_id int4 NULL,
    evaluation_date date NULL,
    rating int4 NULL
);
COMMENT ON TABLE hr.employee_performance IS 'comment';

-- HR.employee_roles definition

-- Drop table
DROP TABLE HR.employee_roles;
CREATE TABLE HR.employee_roles (
    role_id int4 NULL,
    employee_id int4 NULL,
    department_id int4 NULL,
    role_name varchar(100) NULL
);
COMMENT ON TABLE hr.employee_roles IS 'comment';

-- HR.employee_training definition

-- Drop table
DROP TABLE HR.employee_training;
CREATE TABLE HR.employee_training (
    training_id int4 NULL,
    employee_id int4 NULL,
    training_name varchar(100) NULL,
    start_date date NULL,
    end_date date NULL
);
COMMENT ON TABLE hr.employee_training IS 'comment';

-- HR.employees definition

-- Drop table
DROP TABLE HR.employees;
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

-- Drop table
DROP TABLE HR.salaries;
CREATE TABLE HR.salaries (
    salary_id int4 NULL,
    employee_id int4 NULL,
    amount float NULL,
    effective_date date NULL
);
COMMENT ON TABLE hr.salaries IS 'comment';
