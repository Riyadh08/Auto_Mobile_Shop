# AutoMobile Shop Management

## Introduction
This project is designed to manage an automobile shop, including customer information, vehicle data, job details, and repair records. The database schema and operations are implemented using SQL and PL/SQL in Oracle.

## Database Schema
The database consists of the following tables:
- `customer`: Stores customer information.
- `vehicle`: Stores vehicle information, associated with a customer.
- `job`: Stores information about repair jobs performed on vehicles.
- `repair`: Stores information about the types of repairs performed on each job.

### Table Definitions

```sql
-- Customer Table
CREATE table customer (
  c_id NUMBER(6) PRIMARY KEY,
  c_name VARCHAR(20) NOT NULL,
  c_phone VARCHAR(20) NOT NULL,
  c_address VARCHAR(50) NOT NULL
);

-- Vehicle Table
CREATE table vehicle (
  car_num NUMBER(12) PRIMARY KEY,
  production_company VARCHAR(20) NOT NULL,
  production_month VARCHAR(20) NOT NULL,
  c_id NUMBER(6) NOT NULL,
  FOREIGN KEY(c_id) REFERENCES customer(c_id) ON DELETE CASCADE
);

-- Job Table
CREATE table job (
  j_num NUMBER(6) PRIMARY KEY,
  j_date DATE NOT NULL,
  car_num NUMBER(12) NOT NULL,
  FOREIGN KEY(car_num) REFERENCES vehicle(car_num) ON DELETE CASCADE
);

-- Repair Table
CREATE table repair (
  j_num NUMBER(4) NOT NULL,
  j_type VARCHAR(20) NOT NULL,
  s_charge INTEGER,
  PRIMARY KEY(j_num, j_type),
  FOREIGN KEY(j_num) REFERENCES job(j_num) ON DELETE CASCADE
);
-- Insert data into customer table
INSERT INTO customer VALUES (1, 'Ryad', '01773844866', 'Rajshahi');
INSERT INTO customer VALUES (2, 'Takiul', '01773844866', 'Rajshahi');
INSERT INTO customer VALUES (3, 'Tanvir', '01724244410', 'Rajbari');
INSERT INTO customer VALUES (4, 'Badhon', '01750153173', 'Joypurhat');
INSERT INTO customer VALUES (5, 'Rahman', '01773785658', 'Barishal');

-- Insert data into vehicle table
INSERT INTO vehicle VALUES (11, 'bajaj', 'january', 2);
INSERT INTO vehicle VALUES (12, 'hundai', 'April', 3);
INSERT INTO vehicle VALUES (13, 'hero', 'january', 1);
INSERT INTO vehicle VALUES (14, 'mahindra', 'may', 4);
INSERT INTO vehicle VALUES (15, 'bajaj', 'june', 5);

-- Insert data into job table
INSERT INTO job VALUES (101, DATE '2022-04-05', 11);
INSERT INTO job VALUES (102, DATE '2022-11-05', 12);
INSERT INTO job VALUES (103, DATE '2022-02-15', 14);
INSERT INTO job VALUES (104, DATE '2022-03-23', 13);
INSERT INTO job VALUES (105, DATE '2022-05-02', 12);

-- Insert data into repair table
INSERT INTO repair VALUES (104, 'servicing', 2000);
INSERT INTO repair VALUES (102, 'Buy parts', 6000);
INSERT INTO repair VALUES (103, 'servicing', 1000);
INSERT INTO repair VALUES (101, 'Tire buy', 5000);
-- Update customer address
UPDATE customer SET c_address = 'Birampur' WHERE c_id = 1;
-- Delete a repair record
DELETE FROM repair WHERE j_num = 102;
-- Select customers
SELECT * FROM customer;

-- Select vehicles
SELECT * FROM vehicle;

-- Select jobs
SELECT * FROM job;

-- Select repairs
SELECT * FROM repair;
-- Count the number of customers
SELECT COUNT(*) FROM customer;

-- Sum of service charges
SELECT SUM(s_charge) FROM repair;

-- Average service charge
SELECT AVG(s_charge) FROM repair;

-- Minimum job date
SELECT MIN(j_date) FROM job;

-- Maximum service charge
SELECT MAX(s_charge) FROM repair;
-- Natural Join
SELECT c_name, car_num
FROM customer, vehicle
WHERE customer.c_id = vehicle.c_id;

-- Inner Join
SELECT c.c_id, c.c_name, v.car_num
FROM customer c
INNER JOIN vehicle v ON c.c_id = v.c_id;

-- Left Join
SELECT v.car_num, j.j_num
FROM vehicle v
LEFT JOIN job j ON v.car_num = j.car_num;

-- Right Join
SELECT j.j_num, r.j_type
FROM job j
RIGHT JOIN repair r ON j.j_num = r.j_num;

-- Full Outer Join
SELECT c.c_id, c.c_name, r.j_type
FROM customer c
FULL OUTER JOIN repair r ON c.c_id = r.j_num;
-- Create a view for customer without phone and address
CREATE OR REPLACE VIEW customer_view AS
SELECT c_id, c_name
FROM customer;

-- Find all vehicles owned by the customer with c_id 1
CREATE VIEW customer1_vehicles AS 
SELECT production_company, production_month 
FROM vehicle 
WHERE c_id = 1;
-- Retrieve customer information based on customer ID
CREATE OR REPLACE PROCEDURE get_customer_info(
  p_customer_id IN NUMBER,
  p_customer_name OUT VARCHAR2,
  p_customer_phone OUT VARCHAR2,
  p_customer_address OUT VARCHAR2
)
IS
BEGIN
  SELECT c_name, c_phone, c_address
  INTO p_customer_name, p_customer_phone, p_customer_address
  FROM customer
  WHERE c_id = p_customer_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' not found.');
END;
/
-- Calculate total service charge for a given job
CREATE OR REPLACE FUNCTION calculate_total_service_charge(job_id IN NUMBER)
RETURN NUMBER
IS
  total_charge NUMBER := 0;
BEGIN
  SELECT SUM(s_charge) INTO total_charge
  FROM repair
  WHERE j_num = job_id;
  
  RETURN total_charge;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/

-- Example of using the function
DECLARE
  v_job_id NUMBER := 101;
  v_total_charge NUMBER;
BEGIN
  v_total_charge := calculate_total_service_charge(v_job_id);
  DBMS_OUTPUT.PUT_LINE('Total Service Charge for Job ' || v_job_id || ': ' || v_total_charge);
END;
/
-- Trigger to delete vehicle records when a customer is deleted
CREATE OR REPLACE TRIGGER delete_vehicle
BEFORE DELETE ON customer
FOR EACH ROW
BEGIN
    DELETE FROM vehicle WHERE c_id = :OLD.c_id;
END;
/
