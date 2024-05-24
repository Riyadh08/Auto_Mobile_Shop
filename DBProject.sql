--AutoMobile Shop Management
--RYAD, ROLL : 2007008
--Lab 01
drop table customer CASCADE CONSTRAINTS;
drop table vehicle CASCADE CONSTRAINTS;
drop table job CASCADE CONSTRAINTS;
drop table repair CASCADE CONSTRAINTS;

--DDL Command
--Customer Table
--This table stores information about customers who bring their vehicles for repair.
CREATE table customer(
c_id number(6) PRIMARY KEY,
c_name varchar(20) not NULL,
c_phone varchar(20) not NULL,
c_address varchar(50) not NULL
);

--Vehicle Table
--This table stores information about vehicles.
create table vehicle(
car_num number(12) PRIMARY KEY,
production_company varchar(20) NOT NULL,
production_month varchar(20) NOT NULL,
c_id number(6) not NULL,
foreign key(c_id) REFERENCES customer(c_id) on DELETE CASCADE
);

--Job Table
--This table stores information about repair jobs performed on vehicles.
create table job(
j_num number(6) PRIMARY key,
j_date date not NULL,
car_num number(12) not NULL,
foreign key(car_num) REFERENCES vehicle(car_num) on DELETE cascade
);

--Repair Table
--This table stores information about the types of repairs performed on each job.
create table repair(
j_num number(4) not null,
j_type varchar(20) NOT null,
s_charge integer,
PRIMARY key(j_num,j_type),
foreign key(j_num) REFERENCES job(j_num) on delete cascade
);

desc customer;
desc vehicle;
desc job;
desc repair;

--lab 02
--DML command
--Insert data into tables
set pagesize 100
set linesize 200

insert into customer values(1,'Ryad','01773844866','Rajshahi');
insert into customer values(2,'Takiul','01773844866','Rajshahi');
insert into customer values(3,'Tanvir','01724244410','Rajbari');
insert into customer values(4,'Badhon','01750153173','Joypurhat');
insert into customer values(5,'Rahman','01773785658','Barishal');
select * from customer;

insert into vehicle values(11,'bajaj','january',2);
insert into vehicle values(12,'hundai','April',3);
insert into vehicle values(13,'hero','january',1);
insert into vehicle values(14,'mahindra','may',4);
insert into vehicle values(15,'bajaj','june',5);
select * from vehicle;

insert into job values(101,date'2022-04-05',11);
insert into job values(102,date'2022-11-05',12);
insert into job values(103,date'2022-02-15',14);
insert into job values(104,date'2022-03-23',13);
insert into job values(105,date'2022-05-02',12);
select * from job;

insert into repair values(104,'servicing',2000);
insert into repair values(102,'Buy parts',6000);
insert into repair values(103,'servicing',1000);
insert into repair values(101,'Tire buy',5000);
select * from repair;

--lab 03
--DDL Command
--Add column,modify column,drop column
describe customer;
alter table customer add(
father_name varchar(20),
mother_name varchar(20)
);
describe customer;

alter table customer modify father_name number(10);
describe customer;

alter table customer drop column father_name;

alter table customer drop column mother_name;
describe customer;

--DML Command
select * from customer;
update customer set c_address = 'Birampur' where c_id=1;
select * from customer;

select * from repair;
delete from repair where j_num='102';
select * from repair;
insert into repair values(102,'servicing',6000);

select c_id,c_name,c_address from customer;
select c_name,c_address from customer where c_id=3 or c_id=5;

select (s_charge/5) from repair;
select (s_charge/5) as from repair;

select j_num, s_charge from repair where s_charge>1000;
--set membership operator
select j_num,s_charge,j_type from repair where s_charge BETWEEN 2000 AND 5000;
SELECT j_num,s_charge,j_type FROM repair WHERE s_charge NOT BETWEEN 2000 AND 5000;
select j_num,s_charge,j_type from repair where s_charge IN(2000,5000);
select j_num,s_charge,j_type from repair where s_charge NOT IN(2000,5000);

--String operations
select c_id,c_name,c_address from customer where c_name like '_om__';
select c_id,c_name,c_address from customer where c_name like '%m%';

--Order by clause
select j_num,s_charge,j_type from repair order by s_charge;
select j_num,s_charge,j_type from repair order by s_charge desc;
select j_num,s_charge,j_type from repair order by j_num desc,s_charge;

--distinct keyword
select DISTINCT(c_name) from customer;

select car_num,production_company,production_month,c_id from vehicle
where c_id In(select c_id from customer where c_id<7);

--lab 04
--Aggregate function COUNT,SUM,AVG,MIN,MAX

SELECT COUNT(*) FROM customer; 

SELECT SUM(s_charge) FROM repair;

SELECT AVG(s_charge) FROM repair;

SELECT MIN(j_date) FROM job; 

SELECT MAX(s_charge) FROM repair;

--Natural Join
SELECT c_name, car_num 
FROM customer,vehicle
WHERE customer.c_id = vehicle.c_id;

-- SELECT c_name, car_num
-- FROM customer
-- JOIN vehicle ON customer.c_id = vehicle.c_id;

--Inner Join
SELECT c.c_id, c.c_name, v.car_num
FROM customer c
INNER JOIN vehicle v ON c.c_id = v.c_id;

--Left Join
SELECT v.car_num, j.j_num
FROM vehicle v
LEFT JOIN job j ON v.car_num = j.car_num;

--Right Join
SELECT j.j_num, r.j_type
FROM job j
RIGHT JOIN repair r ON j.j_num = r.j_num;

--Full Outer Join
SELECT c.c_id, c.c_name, r.j_type
FROM customer c
FULL OUTER JOIN repair r ON c.c_id = r.j_num;

--Lab 05
--VIEW,With cluse,nested SUBQUERY

--A view of customer without their c_phone and c_address
CREATE OR REPLACE VIEW customer_view AS
SELECT c_id, c_name
FROM customer;

--Find all vehicle owned by the customer with c_id 1
CREATE VIEW CUSTOMER1_VEHICLES AS 
SELECT production_company, production_month 
FROM vehicle 
WHERE c_id = 1;

--Views defined using other views. For example, a view that selects all 
-- customers from the customer_details view with c_id greater than or equal to 3
CREATE VIEW custom AS 
SELECT * 
FROM customer_details 
WHERE c_id >= 3;

/*
  This query selects all customers who have at least one vehicle registered.
  It achieves this by using a common table expression (CTE) named 'customer_vehicle'.
  The CTE retrieves all customers from the 'customer' table whose 'c_id' values are present in the 'vehicle' table.
  Finally, the query selects all columns from the 'customer_vehicle' CTE and returns the result.
*/

WITH customer_vehicle AS (
  SELECT * FROM customer c
  WHERE c.c_id IN (
    SELECT v.c_id FROM vehicle v
  )
) SELECT * FROM customer_vehicle;

--Nested SUBQUERY
SELECT c_name FROM customer
WHERE c_id IN (
    SELECT c_id FROM vehicle WHERE production_company = 'bajaj'
);

SELECT j_num FROM job
WHERE car_num IN (
    SELECT car_num FROM vehicle
    WHERE production_company = 'hundai'
);

SELECT j_num, (
    SELECT SUM(s_charge) FROM repair
    WHERE repair.j_num = job.j_num
)FROM job;


--Group By and having caluses
SELECT j_num, SUM(s_charge)
FROM repair GROUP BY j_num;

SELECT production_company, COUNT(*)
FROM vehicle GROUP BY production_company;

-- Inner Join with Group By and Having
--Alternatively we can write nested subquery
SELECT c.c_name, SUM(r.s_charge)
FROM customer c
INNER JOIN vehicle v ON c.c_id = v.c_id
INNER JOIN job j ON v.car_num = j.car_num
INNER JOIN repair r ON j.j_num = r.j_num
GROUP BY c.c_name
HAVING SUM(r.s_charge) > 1000;

--Lab 06
--PL SQL
--Showing Production month and Production company of car number 11

set serveroutput on
declare 
	production_month vehicle.production_month%TYPE;
	production_company vehicle.production_company%type;
BEGIN
	select production_month,production_company into production_month,production_company
	from vehicle where car_num = 11;
	dbms_output.put_line('The produc comp and produc month: ' || production_company||','||production_month);
end;
/

/*
This code block retrieves the name and address of a customer with a 
specific customer ID (c_id) and prints the values using DBMS_OUTPUT.PUT_LINE.
*/
DECLARE
-- Variable declaration
  v_customer_name customer.c_name%TYPE;
  v_customer_address customer.c_address%TYPE;
BEGIN
-- Assigning values to variables
  SELECT c_name, c_address
  INTO v_customer_name, v_customer_address
  FROM customer WHERE c_id = 1; -- Assuming you want to retrieve details for customer with c_id = 1
  
-- Printing variable values
  DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
  DBMS_OUTPUT.PUT_LINE('Customer Address: ' || v_customer_address);
END;
/

--Giving disconunt to a customer on service
declare
  customer_id customer.c_id%type := 1;
  service_charge repair.s_charge%type := 2000;
  discount_rate number := 0.1;
  discount_amount number;
  final_charge number;

begin
  discount_amount := service_charge * discount_rate;
  final_charge := service_charge - discount_amount;
  dbms_output.put_line('Customer ID: ' || customer_id);
  dbms_output.put_line('Service Charge: ' || service_charge);
  dbms_output.put_line('Discount Amount: ' || discount_amount);
  dbms_output.put_line('Final Charge: ' || final_charge);
end;
/

-- Define a row type
DECLARE
  TYPE customer_record IS RECORD (
    c_id customer.c_id%TYPE,
    c_name customer.c_name%TYPE,
    c_phone customer.c_phone%TYPE,
    c_address customer.c_address%TYPE
  );

-- Declare a variable of the row type
  v_customer_info customer_record;
BEGIN
-- Assign values to the variable
  SELECT c_id, c_name, c_phone, c_address
  INTO v_customer_info
  FROM customer
  WHERE c_id = 1; -- Assuming you want to retrieve details for customer with c_id = 1
  
  -- Print the values of the variable
  DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_info.c_id);
  DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_info.c_name);
  DBMS_OUTPUT.PUT_LINE('Customer Phone: ' || v_customer_info.c_phone);
  DBMS_OUTPUT.PUT_LINE('Customer Address: ' || v_customer_info.c_address);
END;
/

DECLARE
-- Declare variables
  v_count INTEGER := 0;
  
-- Declare a cursor
  CURSOR customer_cursor IS
    SELECT * FROM customer;
  
-- Declare variables to store column values
  v_customer_id customer.c_id%TYPE;
  v_customer_name customer.c_name%TYPE;
  v_customer_phone customer.c_phone%TYPE;
  v_customer_address customer.c_address%TYPE;
BEGIN
-- Open the cursor
  OPEN customer_cursor;
  
-- Loop through the cursor
  LOOP
-- Fetch a row from the cursor into variables
    FETCH customer_cursor INTO v_customer_id, v_customer_name, v_customer_phone, v_customer_address;
    
-- Exit the loop if no more rows to fetch
    EXIT WHEN customer_cursor%NOTFOUND;
    
-- Increment the row count
    v_count := v_count + 1;
    
-- Process the row (you can perform any operations here)
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id || ', Name: ' || v_customer_name || ', Phone: ' || v_customer_phone || ', Address: ' || v_customer_address);
  END LOOP;
  
-- Close the cursor
  CLOSE customer_cursor;
  
-- Print the row count
  DBMS_OUTPUT.PUT_LINE('Total number of customers: ' || v_count);
END;
/

/*
Array processing
*/
DECLARE
  -- Declare an array type
  TYPE customer_names_array IS TABLE OF customer.c_name%TYPE INDEX BY PLS_INTEGER;

  -- Declare variables
  v_index PLS_INTEGER := 1;
  v_customer_name customer.c_name%TYPE;

  -- Declare an array variable
  v_customer_names customer_names_array;
BEGIN
  -- Populate the array using a FOR LOOP
  FOR c_rec IN (SELECT c_name FROM customer) LOOP
    v_customer_names(v_index) := c_rec.c_name;
    v_index := v_index + 1;
  END LOOP;

  -- Print array elements using a WHILE LOOP
  WHILE v_index > 1 LOOP
    v_index := v_index - 1;
    v_customer_name := v_customer_names(v_index);
    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
  END LOOP;

  -- Extend the array and add new elements
  v_index := v_index + 1; -- Increment the index to add new elements
  v_customer_names(v_index) := 'New Customer 1'; -- Add new element
  v_index := v_index + 1; -- Increment the index to add new elements
  v_customer_names(v_index) := 'New Customer 2'; -- Add new element
  v_index := v_index + 1; -- Increment the index to add new elements
  v_customer_names(v_index) := 'New Customer 3'; -- Add new element

  -- Print extended array elements using a FOR LOOP
  FOR i IN v_customer_names.FIRST..v_customer_names.LAST LOOP
    DBMS_OUTPUT.PUT_LINE('Extended Customer Name: ' || v_customer_names(i));
  END LOOP;
END;
/

DECLARE
-- Declare an array type
  TYPE customer_names_array IS TABLE OF customer.c_name%TYPE INDEX BY PLS_INTEGER;
  
-- Declare variables
  v_index PLS_INTEGER := 1;
  v_customer_name customer.c_name%TYPE;
  
-- Declare an array variable
  v_customer_names customer_names_array;
BEGIN
-- Populate the array using a FOR LOOP
  FOR c_rec IN (SELECT c_name FROM customer) LOOP
    v_customer_names(v_index) := c_rec.c_name;
    v_index := v_index + 1;
  END LOOP;
  
-- Print array elements using a FOR LOOP
  FOR i IN 1..v_index-1 LOOP
    v_customer_name := v_customer_names(i);
    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
  END LOOP;
END;
/
-- Create a function to calculate the total service charge for a given job
CREATE OR REPLACE FUNCTION calculate_total_service_charge(job_id IN NUMBER)
RETURN NUMBER
IS
  total_charge NUMBER := 0;
BEGIN
-- Sum up the service charges for all repairs associated with the job
  SELECT SUM(s_charge) INTO total_charge
  FROM repair
  WHERE j_num = job_id;
  
  RETURN total_charge;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0; -- Return 0 if no repairs are found for the job
END;
/

-- Example of using the function
DECLARE
  v_job_id NUMBER := 101; -- Assume job_id for demonstration
  v_total_charge NUMBER;
BEGIN
-- Call the function to calculate the total service charge for the job
  v_total_charge := calculate_total_service_charge(v_job_id);
  
-- Print the result
  DBMS_OUTPUT.PUT_LINE('Total Service Charge for Job ' || v_job_id || ': ' || v_total_charge);
END;
/

DECLARE
  v_num_repairs NUMBER := 3; -- Assume the number of repairs for demonstration
  
BEGIN
-- Check the number of repairs and perform actions accordingly
  IF v_num_repairs = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No repairs found.');
  ELSIF v_num_repairs = 1 THEN
    DBMS_OUTPUT.PUT_LINE('One repair found.');
  ELSIF v_num_repairs = 2 THEN
    DBMS_OUTPUT.PUT_LINE('Two repairs found.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('More than two repairs found.');
  END IF;
  
END;
/
-- Create a procedure to retrieve customer information based on customer ID
CREATE OR REPLACE PROCEDURE get_customer_info(
  p_customer_id IN NUMBER,
  p_customer_name OUT VARCHAR2,
  p_customer_phone OUT VARCHAR2,
  p_customer_address OUT VARCHAR2
)
IS
BEGIN
-- Retrieve customer information based on customer ID
  SELECT c_name, c_phone, c_address
  INTO p_customer_name, p_customer_phone, p_customer_address
  FROM customer
  WHERE c_id = p_customer_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' not found.');
END;
/

-- Example of using the procedure
DECLARE
  v_customer_id NUMBER := 1; -- Assume customer ID for demonstration
  v_customer_name VARCHAR2(50);
  v_customer_phone VARCHAR2(20);
  v_customer_address VARCHAR2(100);
BEGIN
-- Call the procedure to retrieve customer information
  get_customer_info(v_customer_id, v_customer_name, v_customer_phone, v_customer_address);
  
-- Print the retrieved customer information
  IF v_customer_name IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
    DBMS_OUTPUT.PUT_LINE('Customer Phone: ' || v_customer_phone);
    DBMS_OUTPUT.PUT_LINE('Customer Address: ' || v_customer_address);
  END IF;
END;
/
CREATE OR REPLACE FUNCTION calculate_total_repair_cost(job_id IN NUMBER)
RETURN NUMBER
IS
  total_cost NUMBER := 0;
BEGIN
  SELECT SUM(s_charge)
  INTO total_cost
  FROM repair
  WHERE j_num = job_id;
  
  RETURN total_cost;
END;
/

-- Show Total expense of servicing and bonus to the employee
--funtion name 'get_bonus'
CREATE OR REPLACE FUNCTION get_bonus(
expense IN repair.s_charge%TYPE)
RETURN NUMBER IS
BEGIN
RETURN (NVL(0.1,0) * NVL(expense,0) );
END get_bonus;
/

SELECT j_num,s_charge,
get_bonus(s_charge) "Annual
Compensation"
FROM repair;

--Lab 8 labtest

------Lab 9-----
--Trigger

set serveroutput on
CREATE OR REPLACE TRIGGER delete_vehicle
BEFORE DELETE ON customer
FOR EACH ROW
BEGIN
    DELETE FROM vehicle WHERE c_id = :OLD.c_id;
END;
/


-- set serveroutput on
-- CREATE OR REPLACE TRIGGER trg_calculate_total_cost
-- AFTER INSERT OR UPDATE ON repair
-- FOR EACH ROW
-- BEGIN
--     UPDATE job
--     SET total_cost = (SELECT SUM(s_charge) FROM repair WHERE j_num = :NEW.j_num)
--     WHERE j_num = :NEW.j_num;
-- END;
-- /

CREATE OR REPLACE TRIGGER trg_upd_vehicle_on_cust_del
AFTER DELETE ON customer
FOR EACH ROW
BEGIN
    UPDATE vehicle
    SET c_id = NULL
    WHERE c_id = :OLD.c_id;
END;
/


		